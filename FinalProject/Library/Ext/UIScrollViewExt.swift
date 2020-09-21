//
//  UIScrollViewExt.swift
//  FinalProject
//
//  Created by MBA0176 on 4/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit.UIScrollView

private struct ScrollViewKey {
    static var lastContentOffSetY = "lastContentOffSetY"
}

extension UIScrollView {

    enum Direction {
        case none
        case up(constant: CGFloat)
        case down(constant: CGFloat)
    }

    var scrollDirection: Direction {
        defer { lastContentOffSetY = contentOffset.y }
        guard let lastContentOffSetY = lastContentOffSetY else { return .none }
        let scrollDiff = contentOffset.y - lastContentOffSetY
        if scrollDiff > 0 {
            return .down(constant: scrollDiff)
        }
        if scrollDiff < 0 {
            return .up(constant: scrollDiff)
        }
        return .none
    }

    var lastContentOffSetY: CGFloat? {
        set {
            objc_setAssociatedObject(self, &ScrollViewKey.lastContentOffSetY, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.lastContentOffSetY) as? CGFloat
        }
    }

    func killScroll() {
        setContentOffset(contentOffset, animated: false)
    }

    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollRectToVisible(CGRect(x: self.contentSize.width - 1,
                                            y: self.contentSize.height - 1,
                                            width: 1,
                                            height: 1), animated: true)
        }
    }

    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y - 100, width: 1, height: self.frame.height), animated: animated)
        }
    }
}
