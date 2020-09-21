//
//  UILabelExt.swift
//  FinalProject
//
//  Created by MBA0176 on 4/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

extension UILabel {

    func spaceLine(alignment: NSTextAlignment = .left, lineSpacing: CGFloat = 8) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        guard let text = text else { return }
        attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
    }

    func setFontAttributedText(_ str: String, font: UIFont = UIFont.boldSystemFont(ofSize: 14)) {
        guard str.isEmpty == false,
            let text = attributedText,
            let range = text.string.range(of: str, options: .caseInsensitive) else { return }

        let attr = NSMutableAttributedString(attributedString: text)
        let start = text.string.distance(from: text.string.startIndex, to: range.lowerBound)
        let length = text.string.distance(from: range.lowerBound, to: range.upperBound)
        attr.addAttributes([NSAttributedString.Key.font: font],
                           range: NSRange(location: start, length: length))
        attributedText = attr
    }
}
