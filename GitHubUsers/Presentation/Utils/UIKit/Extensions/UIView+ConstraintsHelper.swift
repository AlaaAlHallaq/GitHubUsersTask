//
//  UIView+ExtensionsHelper.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import UIKit

typealias Action = () -> ()
typealias ActionOf<T> = (T) -> ()
typealias ActionOf2<T1, T2> = (T1, T2) -> ()
extension UIView: ILayoutGuide {}
protocol IExtensible {}
extension NSObject: IExtensible {}
extension IExtensible {
    @discardableResult
    func with(_ action: ActionOf<Self>) -> Self {
        action(self)
        return self
    }
}

extension CGFloat {
    static var one: Self { 1 }
}
extension Bool {
    var inverted: Bool { !self }
}

extension UILayoutGuide: ILayoutGuide {}

public protocol ILayoutGuide {
    var leadingAnchor: NSLayoutXAxisAnchor { get }

    var trailingAnchor: NSLayoutXAxisAnchor { get }

    var leftAnchor: NSLayoutXAxisAnchor { get }

    var rightAnchor: NSLayoutXAxisAnchor { get }

    var topAnchor: NSLayoutYAxisAnchor { get }

    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }

    var heightAnchor: NSLayoutDimension { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }

    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension ILayoutGuide {
    @discardableResult
    func below(
        of to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        topToBottom(of: to, safe: safe, value, action: action)
    }

    @discardableResult
    func above(
        of to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.bottomToTop(of: to, safe: safe, value, action: action)
    }

    func layoutGuide(safe: Bool) -> ILayoutGuide {
        if let view = self as? UIView {
            return safe ? view.safeAreaLayoutGuide : view
        }
        return self
    }

    @discardableResult
    @inline(__always)
    func fillHorizontal(
        into view: ILayoutGuide,
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        position: CGFloat = .zero,
        flip: Bool = false,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        self.fill(
            into: view,
            safe: safe,
            horizontal: true,
            vertical: false,
            scale: .init(width: scale, height: 1),
            extraSize: .init(width: extraSize, height: 0),
            position: .init(x: position, y: 0),
            flip: flip,
            action: action
        )
    }

    @discardableResult
    @inline(__always)
    func fillVertical(
        into view: ILayoutGuide,
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        position: CGFloat = .zero,
        flip: Bool = false,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        self.fill(
            into: view,
            safe: safe,
            horizontal: false,
            vertical: true,
            scale: .init(width: 1, height: scale),
            extraSize: .init(width: 0, height: extraSize),
            position: .init(x: 0, y: position),
            flip: flip,
            action: action
        )
    }

    @discardableResult @inline(__always)
    func fill(
        into view: ILayoutGuide,
        safe: Bool = false,
        horizontal: Bool = true,
        vertical: Bool = true,
        scale: CGSize = .init(width: 1, height: 1),
        extraSize: CGSize = .zero,
        position: CGPoint = .zero,
        flip: Bool = false,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        let g: ILayoutGuide = view.layoutGuide(safe: safe)

        var constraint = [NSLayoutConstraint]()
        if horizontal {
            self.widthAnchor
                .constraint(
                    equalTo: flip ? g.heightAnchor : g.widthAnchor,
                    multiplier: scale.width,
                    constant: extraSize.width
                )
                .with { $0.identifier = "w" }
                //.with { $0.name = .width }
                .activate()
                .with { constraint.append($0) }

            self.centerXAnchor
                .constraint(
                    equalTo: g.centerXAnchor,
                    constant: position.x
                )
                .with { $0.identifier = "cx" }
                //.with { $0.name = .centerX }

                .activate()
                .with { constraint.append($0) }
        }
        if vertical {
            self.heightAnchor
                .constraint(
                    equalTo: flip.inverted ? g.heightAnchor : g.widthAnchor,
                    multiplier: scale.height,
                    constant: extraSize.height
                )
                .with { $0.identifier = "h" }
                //.with { $0.name = .height }

                .activate()
                .with { constraint.append($0) }

            self.centerYAnchor.constraint(
                equalTo: g.centerYAnchor,
                constant: position.y
            )
            .with { $0.identifier = "cy" }
            //.with { $0.name = .centerY }
            .activate()
            .with { constraint.append($0) }
        }
        action(constraint)
        return self
    }

    @discardableResult @inline(__always)
    func trailing(
        to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        to.layoutGuide(safe: safe).trailingAnchor
            .constraint(
                equalTo: self.trailingAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func leading(
        to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.leadingAnchor
            .constraint(
                equalTo: to
                    .layoutGuide(safe: safe)
                    .leadingAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func trailingToLeading(
        of to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        to.layoutGuide(safe: safe)
            .leadingAnchor
            .constraint(
                equalTo: self.trailingAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func leadingToTrailing(
        of to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.leadingAnchor
            .constraint(
                equalTo: to
                    .layoutGuide(safe: safe)
                    .trailingAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    //////
    ///
    @discardableResult @inline(__always)
    func top(
        to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.topAnchor
            .constraint(
                equalTo: to
                    .layoutGuide(safe: safe)
                    .topAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func bottom(
        to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        to.layoutGuide(safe: safe)
            .bottomAnchor
            .constraint(
                equalTo: self.bottomAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func topToBottom(
        of to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.topAnchor
            .constraint(
                equalTo: to.layoutGuide(safe: safe).bottomAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func bottomToTop(
        of to: ILayoutGuide,
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        to.layoutGuide(safe: safe)
            .topAnchor
            .constraint(
                equalTo: self.bottomAnchor,
                constant: value
            )
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func centerH(
        into view: ILayoutGuide,
        safe: Bool = false,
        position: CGPoint = .zero,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        center(
            into: view,
            safe: safe,
            horizontal: true,
            vertical: false,
            position: position,
            action: {
                if let f = $0.first {
                    action(f)
                }
            }
        )
    }

    @discardableResult @inline(__always)
    func centerV(
        into view: ILayoutGuide,
        safe: Bool = false,
        position: CGPoint = .zero,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        center(
            into: view, safe: safe,
            horizontal: false,
            vertical: true,
            position: position,
            action: {
                if let f = $0.first {
                    action(f)
                }
            }
        )
    }

    @discardableResult @inline(__always)
    func centerHorizontal(
        into view: ILayoutGuide,
        safe: Bool = false,
        position: CGFloat = .zero,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        self.center(
            into: view,
            safe: safe,
            horizontal: true,
            vertical: false,
            position: .init(x: position, y: 0),
            action: action
        )
    }

    @discardableResult @inline(__always)
    func centerVertical(
        into view: ILayoutGuide,
        safe: Bool = false,
        position: CGFloat = .zero,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        self.center(
            into: view,
            safe: safe,
            horizontal: false,
            vertical: true,
            position: .init(x: 0, y: position),
            action: action
        )
    }

    @discardableResult @inline(__always)
    func center(
        into view: ILayoutGuide,
        safe: Bool = false,
        horizontal: Bool = true,
        vertical: Bool = true,
        position: CGPoint = .zero,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        let g: ILayoutGuide = view.layoutGuide(safe: safe)

        var constraints = [NSLayoutConstraint]()
        if horizontal {
            self.centerXAnchor
                .constraint(
                    equalTo: g.centerXAnchor,
                    constant: position.x
                )
                .activate()
                //.with { $0.name = .centerX }

                .with { $0.identifier = "cx" }
                .with { constraints.append($0) }
        }
        if vertical {
            self.centerYAnchor
                .constraint(
                    equalTo: g.centerYAnchor,
                    constant: position.y
                )
                //.with { $0.name = .centerY }

                .with { $0.identifier = "cy" }
                .activate()
                .with { constraints.append($0) }
        }
        action(constraints)
        return self
    }

    @discardableResult @inline(__always)
    func fixed(
        width: CGFloat,
        height: CGFloat,
        priority: UILayoutPriority? = nil,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        var constraints = [NSLayoutConstraint]()
        self.fixed(width: width, priority: priority) { constraints.append($0) }
        self.fixed(height: height, priority: priority) { constraints.append($0) }
        action(constraints)
        return self
    }

    @discardableResult @inline(__always)
    func fixed(
        width: CGFloat,
        priority: UILayoutPriority? = nil,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.widthAnchor.constraint(equalToConstant: width)
            //.with { $0.name = .width }
            .with {
                if let priority = priority {
                    $0.priority = priority
                }
            }
            .activate()
            .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func aspectRatio(
        _ ratio: CGFloat,
        extra: CGFloat = 0,
        priority: UILayoutPriority? = nil,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.widthAnchor.constraint(
            equalTo: heightAnchor,
            multiplier: ratio,
            constant: extra
        )
        .with {
            if let priority = priority {
                $0.priority = priority
            }
        }
        //.with { $0.name = .aspectRatio }
        .activate()
        .with { action($0) }
        return self
    }

    @discardableResult @inline(__always)
    func fixed(
        side: CGFloat,
        priority: UILayoutPriority? = nil,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        self.fixed(width: side, height: side, priority: priority, action: action)
        return self
    }

    @discardableResult @inline(__always)
    func fixed(
        size: CGSize,
        priority: UILayoutPriority? = nil,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        self.fixed(width: size.width, height: size.height, priority: priority, action: action)
        return self
    }

    @discardableResult @inline(__always)
    func fixed(
        height: CGFloat,
        priority: UILayoutPriority? = nil,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        self.heightAnchor
            .constraint(equalToConstant: height)
            //.with { $0.name = .height }
            .with {
                if let priority = priority {
                    $0.priority = priority
                }
            }
            .activate()
            .with { action($0) }
        return self
    }
}

extension Array where Element == NSLayoutConstraint {
    @discardableResult @inline(__always)
    func with(priority: UILayoutPriority) -> Self {
        self.forEach {
            $0.priority = priority
        }
        return self
    }
}

extension NSLayoutConstraint {
    @discardableResult @inline(__always)
    func with(priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }

    @discardableResult @inline(__always)
    func activate() -> Self {
        self.isActive = true
        return self
    }

    @discardableResult @inline(__always)
    func deActivate() -> Self {
        self.isActive = false
        return self
    }
}

extension UIView {
    @discardableResult @inline(__always)
    func useAutoLayout(_ value: Bool = true) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = value.inverted
        return self
    }

    @discardableResult @inline(__always)
    func add(to superView: UIView) -> Self {
        with {
            superView.addSubview($0)
        }
    }

    @discardableResult @inline(__always)
    func insert(into superView: UIView, at index: Int) -> Self {
        with {
            superView.insertSubview($0, at: index)
        }
    }

    @discardableResult @inline(__always)
    func add(arrangedTo stackView: UIStackView) -> Self {
        with {
            stackView.addArrangedSubview($0)
        }
    }

    @discardableResult @inline(__always)
    func insert(arrangedTo stackView: UIStackView, at index: Int) -> Self {
        with {
            stackView.insertArrangedSubview($0, at: index)
        }
    }

    @discardableResult @inline(__always)
    func fillHParent(
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        position: CGFloat = .zero,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        fillParent(
            safe: safe,
            horizontal: true,
            vertical: false,
            scale: .init(width: scale, height: 1),
            extraSize: .init(width: extraSize, height: 0),
            position: .init(x: position, y: 0),
            action: action
        )
    }

    @discardableResult @inline(__always)
    func fillVParent(
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        position: CGFloat = .zero,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        fillParent(
            safe: safe,
            horizontal: false,
            vertical: true,
            scale: .init(width: 1, height: scale),
            extraSize: .init(width: 0, height: extraSize),
            position: .init(x: 0, y: position),
            action: action
        )
    }

    @discardableResult @inline(__always)
    func fillParent(
        safe: Bool = false,
        horizontal: Bool = true,
        vertical: Bool = true,
        scale: CGSize = .init(width: 1, height: 1),
        extraSize: CGSize = .zero,
        position: CGPoint = .zero,
        flip: Bool = false,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.fill(
                into: p,
                safe: safe,
                horizontal: horizontal,
                vertical: vertical,
                scale: scale,
                extraSize: extraSize,
                position: position,
                flip: flip,
                action: action
            )
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func sameSizeOfParent(
        safe: Bool = false,
        horizontal: Bool = true,
        vertical: Bool = true,
        scale: CGSize = .init(width: 1, height: 1),
        extraSize: CGSize = .zero,
        action: ([NSLayoutConstraint]) -> () = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.sameSize(
                of: p,
                safe: safe,
                horizontal: horizontal,
                vertical: vertical,
                scale: scale,
                extraSize: extraSize,
                action: action
            )
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func sameSize(
        of view: ILayoutGuide,
        safe: Bool = false,
        horizontal: Bool = true,
        vertical: Bool = true,
        scale: CGSize = .init(width: 1, height: 1),
        extraSize: CGSize = .zero,
        action: ([NSLayoutConstraint]) -> () = { _ in }
    ) -> Self {
        let g: ILayoutGuide = view.layoutGuide(safe: safe)

        var array = [NSLayoutConstraint]()
        if horizontal {
            array.append(
                self.widthAnchor.constraint(
                    equalTo: g.widthAnchor,
                    multiplier: scale.width,
                    constant: extraSize.width
                )
                //.with { $0.name = .width }

                .activate()
            )
        }
        if vertical {
            array.append(
                self.heightAnchor.constraint(
                    equalTo: g.heightAnchor,
                    multiplier: scale.height,
                    constant: extraSize.height
                )
                //.with { $0.name = .height }

                .activate()
            )
        }
        action(array)
        return self
    }

    @discardableResult @inline(__always)
    func sameWidth(
        of view: ILayoutGuide,
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        action: (NSLayoutConstraint) -> () = { _ in }
    ) -> Self {
        let g: ILayoutGuide = view.layoutGuide(safe: safe)

        action(
            self.widthAnchor.constraint(
                equalTo: g.widthAnchor,
                multiplier: scale,
                constant: extraSize
            )
            //.with { $0.name = .width }
            .activate()
        )
        return self
    }

    @discardableResult @inline(__always)
    func aspect(
        safe: Bool = false,
        ratio: CGFloat,
        extraSize: CGFloat = .zero,
        action: (NSLayoutConstraint) -> () = { _ in }
    ) -> Self {
        let g: ILayoutGuide = self.layoutGuide(safe: safe)

        action(
            g.widthAnchor.constraint(
                equalTo: g.heightAnchor,
                multiplier: ratio,
                constant: extraSize
            ).activate()
        )
        return self
    }

    @discardableResult @inline(__always)
    func sameWidthOfParent(
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        action: (NSLayoutConstraint) -> () = { _ in }
    ) -> Self {
        guard let p = self.superview else {
            fatalError("super view is nil")
        }

        let g: ILayoutGuide = p.layoutGuide(safe: safe)

        action(
            self.widthAnchor.constraint(
                equalTo: g.widthAnchor,
                multiplier: scale,
                constant: extraSize
            )
            //.with { $0.name = .width }
            .activate()
        )
        return self
    }

    @discardableResult @inline(__always)
    func sameHeightOfParent(
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        action: (NSLayoutConstraint) -> () = { _ in }
    ) -> Self {
        guard let p = self.superview else {
            fatalError("super view is nil")
        }

        let g: ILayoutGuide = p.layoutGuide(safe: safe)

        action(
            self.heightAnchor.constraint(
                equalTo: g.heightAnchor,
                multiplier: scale,
                constant: extraSize
            )
            //.with { $0.name = .height }

            .activate()
        )
        return self
    }

    @discardableResult @inline(__always)
    func sameHeight(
        of view: ILayoutGuide,
        safe: Bool = false,
        scale: CGFloat = .one,
        extraSize: CGFloat = .zero,
        action: (NSLayoutConstraint) -> () = { _ in }
    ) -> Self {
        let g: ILayoutGuide = view.layoutGuide(safe: safe)

        action(
            self.heightAnchor.constraint(
                equalTo: g.heightAnchor,
                multiplier: scale,
                constant: extraSize
            )
            //.with { $0.name = .height }

            .activate()
        )
        return self
    }

    @discardableResult @inline(__always)
    func centerParent(
        safe: Bool = false,
        horizontal: Bool = true,
        vertical: Bool = true,
        position: CGPoint = .zero,
        action: ActionOf<[NSLayoutConstraint]> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.center(
                into: p,
                safe: safe,
                horizontal: horizontal,
                vertical: vertical,
                position: position,
                action: action
            )
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func centerHParent(
        safe: Bool = false,
        position: CGFloat = .zero,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.centerH(
                into: p,
                safe: safe,
                position: .init(x: position, y: 0),
                action: action
            )
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func centerVParent(
        safe: Bool = false,
        position: CGFloat = .zero,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.centerV(
                into: p,
                safe: safe,
                position: .init(x: 0, y: position),
                action: action
            )
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func trailingOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.trailing(
                to: p,
                safe: safe,
                value,
                action: action
            )
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func topOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.top(to: p, safe: safe, value, action: action)
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func bottomOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.bottom(to: p, safe: safe, value, action: action)
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func leadingOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.leading(to: p, safe: safe, value, action: action)
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func trailingToLeadingOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.trailingToLeading(of: p, safe: safe, value, action: action)
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func leadingToTrailingOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: ActionOf<NSLayoutConstraint> = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.leadingToTrailing(of: p, safe: safe, value, action: action)
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func bottomToTopOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: (NSLayoutConstraint) -> () = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.bottomToTop(of: p, safe: safe, value, action: action)
        }
        fatalError("super view is nil")
    }

    @discardableResult @inline(__always)
    func topToBottomOfParent(
        safe: Bool = false,
        _ value: CGFloat = 0,
        action: (NSLayoutConstraint) -> () = { _ in }
    ) -> Self {
        if let p = self.superview {
            return self.topToBottom(of: p, safe: safe, value, action: action)
        }
        fatalError("super view is nil")
    }
}

// for debugging purpose only
fileprivate class SpacerView: UIView {}
public extension UIView {
    var isSpacerView: Bool {
        self is SpacerView
    }
}

extension UIView {
    @discardableResult @inline(__always)
    func with(transform: CGAffineTransform) -> Self {
        with {
            $0.transform = transform
        }
    }

    @discardableResult @inline(__always)
    func withHugging(priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        with {
            $0.setContentHuggingPriority(priority, for: axis)
        }
    }

    @discardableResult @inline(__always)
    func withCompression(priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        with {
            $0.setContentCompressionResistancePriority(priority, for: axis)
        }
    }

    static func spacer(width: CGFloat, action: ActionOf2<UIView, NSLayoutConstraint> = { _, _ in }) -> UIView {
        return SpacerView().with { view in
            view.useAutoLayout()
            view.fixed(width: width) {
                action(view, $0)
            }
        }
    }

    static func spacer(action: ActionOf<UIView> = { _ in }) -> UIView {
        return SpacerView().with { view in
            view.useAutoLayout()
            action(view)
        }
    }

    static func spacer(height: CGFloat, action: ActionOf2<UIView, NSLayoutConstraint> = { _, _ in }) -> UIView {
        return SpacerView().with { view in
            view.useAutoLayout()
            view.fixed(height: height) {
                action(view, $0)
            }
        }
    }

    static func vSpacer(_ height: CGFloat, action: ActionOf2<UIView, NSLayoutConstraint> = { _, _ in }) -> UIView {
        .spacer(height: height, action: action)
    }

    static func hSpacer(_ width: CGFloat, action: ActionOf2<UIView, NSLayoutConstraint> = { _, _ in }) -> UIView {
        .spacer(width: width, action: action)
    }

    static func stack(
        _ views: UIView...,
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        action: ActionOf<UIStackView> = { _ in }
    ) -> BaseUIStackView {
        .stack(
            views,
            axis: axis,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution,
            action: action
        )
    }

    static func stack(
        _ views: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        action: ActionOf<UIStackView> = { _ in }
    ) -> BaseUIStackView {
        BaseUIStackView(arrangedSubviews: views)
            .useAutoLayout()
            .with {
                $0.axis = axis
                $0.distribution = distribution
                $0.alignment = alignment
                $0.spacing = spacing
            }
            .with(action)
    }

    static func hStack(
        _ views: UIView...,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        action: ActionOf<UIStackView> = { _ in }
    ) -> BaseUIStackView {
        .hStack(
            views,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution,
            action: action
        )
    }

    static func hStack(
        _ views: [UIView],
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        action: ActionOf<UIStackView> = { _ in }
    ) -> BaseUIStackView {
        .stack(
            views,
            axis: .horizontal,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution,
            action: action
        )
    }

    static func vStack(
        _ views: UIView...,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        action: ActionOf<UIStackView> = { _ in }
    ) -> BaseUIStackView {
        .vStack(
            views,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution,
            action: action
        )
    }

    static func vStack(
        _ views: [UIView],
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        action: ActionOf<UIStackView> = { _ in }
    ) -> BaseUIStackView {
        .stack(
            views,
            axis: .vertical,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution,
            action: action
        )
    }
}

open class BaseUIStackView: UIStackView, IPassthroughView {
    open var isPassthrough: Bool = false

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if isPassthrough {
            return view == self ? nil : view
        }
        return view
    }
}
