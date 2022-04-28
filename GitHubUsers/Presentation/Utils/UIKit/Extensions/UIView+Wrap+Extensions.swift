//
//  UIView+Wrap+Extensions.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import UIKit

 extension UIView {
    @discardableResult
    @inline(__always)
    func wrap(
        safe: Bool = false,
        all: CGFloat,
        constraintsAction: ([NSLayoutConstraint]) -> () = { _ in }
    ) -> BaseUIView {
        self.wrap(safe: safe, horizontal: all, vertical: all, constraintsAction: constraintsAction)
    }

    @discardableResult
    @inline(__always)
    func wrap(
        safe: Bool = false,
        horizontal: CGFloat,
        vertical: CGFloat,
        constraintsAction: ([NSLayoutConstraint]) -> () = { _ in }
    ) -> BaseUIView {
        self.wrap(safe: safe, leading: horizontal, trailing: horizontal, top: vertical, bottom: vertical, constraintsAction: constraintsAction)
    }

    @discardableResult
    @inline(__always)
    func wrap(
        safe: Bool = false,
        horizontal: CGFloat,
        constraintsAction: ([NSLayoutConstraint]) -> () = { _ in }
    ) -> BaseUIView {
        wrap(safe: safe, horizontal: horizontal, vertical: 0, constraintsAction: constraintsAction)
    }

    @discardableResult
    @inline(__always)
    func wrap(
        safe: Bool = false,
        vertical: CGFloat,
        constraintsAction: ([NSLayoutConstraint]) -> () = { _ in }
    ) -> BaseUIView {
        wrap(safe: safe, horizontal: 0, vertical: vertical, constraintsAction: constraintsAction)
    }

  

    @discardableResult
    @inline(__always)
    func wrap(
        safe: Bool = false,
        leading: CGFloat = 0,
        trailing: CGFloat = 0,
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        constraintsAction: ([NSLayoutConstraint]) -> () = { _ in }
    ) -> BaseUIView {
        var list = [NSLayoutConstraint]()
        let wrapper = BaseUIView()
            //.with { $0.stringTag = wrappTag }
            .useAutoLayout()
            .with {
                self
                    .useAutoLayout()
                    .add(to: $0)
                    .trailingOfParent(safe: safe, trailing) {
                        list.append($0)
                        //$0.stringTag = ConstraintNames.trailing.rawValue
                        //$0.name = .trailing
                    }
                    .leadingOfParent(safe: safe, leading) {
                        list.append($0)
                        //$0.stringTag = ConstraintNames.leading.rawValue
                        //$0.name = .leading
                    }
                    .topOfParent(safe: safe, top) {
                        list.append($0)
                        //$0.stringTag = ConstraintNames.top.rawValue
                        //$0.name = .top
                    }
                    .bottomOfParent(safe: safe, bottom) {
                        list.append($0)
                        //$0.stringTag = ConstraintNames.bottom.rawValue
                        //$0.name = .bottom
                    }
            }
        constraintsAction(list)
        return wrapper
    }
}
