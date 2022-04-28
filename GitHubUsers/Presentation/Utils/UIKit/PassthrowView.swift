//
//  PassthrowView.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import UIKit

class PassthroughView: BaseUIView {
    // https://medium.com/@nguyenminhphuc/how-to-pass-ui-events-through-views-in-ios-c1be9ab1626b
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

class PassthroughStackView: UIStackView {
    // https://medium.com/@nguyenminhphuc/how-to-pass-ui-events-through-views-in-ios-c1be9ab1626b
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

func remapAction<TSub, TSuper>(_ action: @escaping ActionOf<TSub>) -> ActionOf<TSuper> {
    {
        action($0 as! TSub)
    }
}

extension NSObjectProtocol where Self: BaseUIView {
    var onLayout: ActionOf<Self> {
        get {
            // had to do the remaping because reading the prop with always return invalid casting, and fall back into default value
            let action: ActionOf<UIView> = objcGet(defaultValue: { _ in })
            return remapAction(action)
        }
        set {
            let remapped: ActionOf<UIView> = remapAction(newValue)
            objcSetCopy(remapped)
        }
    }

    @discardableResult
    func withOnLayout(onLayout: @escaping ActionOf<Self>) -> Self {
        with {
            $0.onLayout = onLayout
        }
    }
 
}

class BaseUIView: UIView, UIGestureRecognizerDelegate, IPassthroughView {
    

    override func layoutSubviews() {
        super.layoutSubviews()
        onLayout(self)
    }


    open var assosiatedViews = [UIView]()

    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {}
//    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        let a = gestureRecognizer
//        let b = otherGestureRecognizer
//        if a is UIPanGestureRecognizer || b is UIPanGestureRecognizer {
//            return false
//        }
//        return true
//    }
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    open var isPassthrough: Bool = false

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if isPassthrough {
            return view == self ? nil : view
        }
        return view
    }
}

protocol IPassthroughView: AnyObject, IExtensible {
    var isPassthrough: Bool { get set }
}

extension IPassthroughView {
    @discardableResult
    @inline(__always)
    func with(passthrough: Bool) -> Self {
        with {
            $0.isPassthrough = passthrough
        }
    }
}

fileprivate enum KeyLocker {
    static var keys = [String]()
    static let keyLocker = NSObject()

    static func keyFor(name: String) -> UnsafeRawPointer {
        var value = 0
        lock(keyLocker) {
            if let index = keys.firstIndex(of: name) {
                value = index
            } else {
                value = keys.count
                keys.append(name)
            }
        }
        return UnsafeRawPointer(bitPattern: value + 1)!
    }
}

public extension NSObject {
    func objcGet<TValue>(name: String = #function, defaultValue: TValue) -> TValue {
        objc_getAssociatedObject(self, KeyLocker.keyFor(name: name)) as? TValue ?? defaultValue
    }

    func objcGetOptional<TValue>(name: String = #function, defaultValue: TValue? = nil) -> TValue? {
        objc_getAssociatedObject(self, KeyLocker.keyFor(name: name)) as? TValue ?? defaultValue
    }

    func objcSetRetain<TValue>(name: String = #function, _ new: TValue) {
        objc_setAssociatedObject(self, KeyLocker.keyFor(name: name), new, .OBJC_ASSOCIATION_RETAIN)
    }

    func objcSetCopy<TValue>(name: String = #function, _ new: TValue) {
        objc_setAssociatedObject(self, KeyLocker.keyFor(name: name), new, .OBJC_ASSOCIATION_COPY)
    }
}

func lock(_ obj: NSObject, action: Action) {
    obj.lock(action: action)
}

extension NSObject {
    func lock(action: Action) {
        self.locked(action: action)
    }

    @discardableResult
    @inline(__always)
    func locked<T>(action: () -> T) -> T {
        objc_sync_enter(self)
        let value = action()
        objc_sync_exit(self)
        return value
    }
}
extension CGSize {
    var min: CGFloat {
        Swift.min(width, height)
    }
}
