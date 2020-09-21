//
//  UIGestureRecognizerExt.swift
//  FinalProject
//
//  Created by MBA0176 on 4/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

extension UIGestureRecognizer {
    func findIdAttributedWithTextViewTarget(attrName: String, complete: (_ index: Int) -> Void) {
        guard let textView = self.view as? UITextView else {
            return
        }
        let layoutManager = textView.layoutManager
        var location: CGPoint = self.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        let charIndex = layoutManager.characterIndex(for: location,
                                                     in: textView.textContainer,
                                                     fractionOfDistanceBetweenInsertionPoints: nil)
        if charIndex < textView.textStorage.length {
            if let value = textView.attributedText?.attribute(NSAttributedString.Key(rawValue: attrName), at: charIndex, effectiveRange: nil) as? String {
                if let index = Int(value) {
                    complete(index)
                }
            }
        }
    }
}
