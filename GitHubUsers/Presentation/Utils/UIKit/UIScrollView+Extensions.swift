//
//  UIScrollView+Extensions.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import UIKit
extension UIScrollView {
    private var lastOffset: CGFloat {
        get { objcGet(defaultValue: 0) }
        set { objcSetCopy(newValue) }
    }

    func shouldFetchNextPage(threshould page: CGFloat) -> Bool {
        let offset = self.contentOffset.y
        let diff = offset - lastOffset
        lastOffset = offset
        if diff <= 0 { return false }
        let size = self.contentSize.height
        let page = self.bounds.height
        let remPages = (size - offset) / page
        print("remPages:\(remPages), offset: \(offset), dir: \(diff)")
        return remPages <= page
    }
}

extension UIView {
    func addToVerticalScrollView(
        makeBouncing: Bool = true,
        action: ActionOf<UIScrollView> = { _ in }
    ) -> CustomUIScrollView {
        CustomUIScrollView()
            .useAutoLayout()
            .with { v in
                v.panGestureRecognizer.with {
                    $0.delegate = v
                    $0.requiresExclusiveTouchType = false
                }
                self
                    .useAutoLayout()
                    .add(to: v)
                    .fillHorizontal(into: v.frameLayoutGuide)
                    .fill(into: v.contentLayoutGuide)

                v.keyboardDismissMode = .interactive
                if makeBouncing {
                    v.bounces = true
                    v.alwaysBounceVertical = true
                }
                action(v)
            }
    }
}

class CustomUIScrollView: UIScrollView, UIGestureRecognizerDelegate {
    class CustomCollectionView: UICollectionView, UIGestureRecognizerDelegate {
        open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}
