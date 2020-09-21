//
//  UIViewExt.swift
//  FinalProject
//
//  Created by MBA0176 on 4/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

extension UIView {

    public class func loadNib<T: UIView>() -> T {
        let name = String(describing: self)
        let bundle = Bundle(for: T.self)
        guard let xib = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Cannot load nib named `\(name)`")
        }
        return xib
    }

    var selected: Bool? {
        get {
            return objc_getAssociatedObject(self, "selected") as? Bool
        }
        set {
            removeSubViewWithTag(tags: 98, 99, 100)
            if let selected = newValue, selected {
                backgroundColor = .clear

                // Border
                let borderView = UIView(frame: bounds)
                borderView.borderColor = .white
                borderView.borderWidth = 1
                borderView.cornerRadius = 10
                borderView.tag = 99
                addSubview(borderView)

                // Image
                let centerPoint = CGPoint(x: width, y: 0)
                let imageView = UIImageView(image: #imageLiteral(resourceName: "ic-checked"))
                imageView.size = CGSize(width: 28, height: 28)
                imageView.tag = 100
                addSubview(imageView)
                imageView.center = centerPoint
            } else {
                let borderView = UIView(frame: bounds)
                borderView.tag = 98
                borderView.borderColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
                borderView.borderWidth = 0.5
                borderView.cornerRadius = 10
                addSubview(borderView)
            }
            objc_setAssociatedObject(self, "selected", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func removeSubViewWithTag(tags: Int...) {
        tags.forEach { (tag) in
            guard let subView = viewWithTag(tag) else { return }
            subView.removeFromSuperview()
        }
    }

    func borderView(width: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func setBackgroundGradient(topColor: UIColor, bottomColor: UIColor, frame: CGRect? = nil) {

        let gradientBackgroundColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]

        gradientLayer.frame = bounds
        if let frame = frame {
            gradientLayer.frame = frame
        }
        layer.insertSublayer(gradientLayer, at: 0)
    }

    enum BorderPostition {
        case top
        case left
        case bottom
        case right
    }

    func border(_ pos: BorderPostition, color: UIColor = UIColor.black, width: CGFloat = 0.5, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        let rect: CGRect = {
            switch pos {
            case .top: return CGRect(x: 0, y: 0, width: frame.width, height: width)
            case .left: return CGRect(x: 0, y: 0, width: width, height: frame.height)
            case .bottom:
                let origin = CGPoint(x: insets.left, y: frame.height - width)
                let size = CGSize(width: frame.width - (insets.left + insets.right), height: width)
                return CGRect(origin: origin, size: size)
            case .right: return CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
            }
        }()
        let border = UIView(frame: rect)
        border.tag = 99 // Mask for remove
        border.backgroundColor = color
        border.autoresizingMask = {
            switch pos {
            case .top: return [.flexibleWidth, .flexibleBottomMargin]
            case .left: return [.flexibleHeight, .flexibleRightMargin]
            case .bottom: return [.flexibleWidth, .flexibleTopMargin]
            case .right: return [.flexibleHeight, .flexibleLeftMargin]
            }
        }()
        addSubview(border)
    }

    public func border(color: UIColor, width: CGFloat) {
        borderColor = color
        borderWidth = width
    }

    struct AnchorOptions: OptionSet {
        let rawValue: Int
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        static let top = UIView.AnchorOptions(rawValue: 1 << 0)
        static let leading = UIView.AnchorOptions(rawValue: 1 << 1)
        static let trailing = UIView.AnchorOptions(rawValue: 1 << 2)
        static let bottom = UIView.AnchorOptions(rawValue: 1 << 3)
        static let all: UIView.AnchorOptions = [.top, .leading, .trailing, .bottom]
    }
    func anchorToSuperView(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        anchor(toView: superview, insets: insets)
    }
    func anchor(toView view: UIView?, insets: UIEdgeInsets = .zero, anchorOptions options: AnchorOptions = .all) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if options.contains(.top) {
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        }
        if options.contains(.leading) {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        }
        if options.contains(.trailing) {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        }
        if options.contains(.bottom) {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
        }
    }
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    func anchorToSuperViewLeading(with constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.leadingAnchor,
                                 constant: constant).isActive = true
    }
    func anchorToSuperViewTrailing(with constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: superview.trailingAnchor,
                                  constant: constant).isActive = true
    }
    func anchorToSuperViewTrailing(lessThanOrEqual constant: CGFloat) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor,
                                  constant: constant).isActive = true
    }
    func anchorToSuperViewTop(with constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor,
                             constant: constant).isActive = true
    }
    func anchorToSuperViewTop(greaterThanOrEqual constant: CGFloat) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor,
                             constant: constant).isActive = true
    }
    func anchorToSuperViewBottom(with constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: superview.bottomAnchor,
                                constant: constant).isActive = true
    }
    func anchorToSuperViewBottom(lessThanOrEqual constant: CGFloat) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(lessThanOrEqualTo: superview.topAnchor,
                                constant: constant).isActive = true
    }
    func heightAnchor(_ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    func widthAnchor(_ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    func centerVerticallyToSuperView(_ constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: constant).isActive = true
    }
    func centerHorrizontallyToSuperView(_ constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: constant).isActive = true
    }
    func removeMultiTouch() {
        subviews.forEach {
            $0.isExclusiveTouch = true
            $0.removeMultiTouch()
        }
    }

}
