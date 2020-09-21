//
//  UINavigationItemExt.swift
//  FinalProject
//
//  Created by MBA0176 on 4/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func setLeftBarButton(title: String = "", target: Any, action: Selector) {
        let naviBarBtn = UIBarButtonItem(title: title, style: .done, target: target, action: action)
        setLeftBarButton(naviBarBtn, animated: true)
    }

    func setLeftBarButton(image: UIImage?, target: Any, action: Selector) {
        guard let image = image else { return }
        let naviBarBtn = UIBarButtonItem(image: image, target: target, action: action)
        setLeftBarButton(naviBarBtn, animated: true)
    }

    func setRightBarButton(title: String = "", target: Any, action: Selector) {
        let naviBarBtn = UIBarButtonItem(title: title, style: .done, target: target, action: action)
        setRightBarButton(naviBarBtn, animated: true)
    }

    func setRightBarButton(image: UIImage?, target: Any, action: Selector) {
        guard let image = image else { return }
        let naviBarBtn = UIBarButtonItem(image: image, target: target, action: action)
        setRightBarButton(naviBarBtn, animated: true)
    }

    func setRightButtons(target: Any, data: [(image: UIImage?, action: Selector)]) {
        let buttonItems: [UIBarButtonItem] = data.map {
            var imageButton = #imageLiteral(resourceName: "placeholde-image")
            if let image = $0 { imageButton = image }
            return UIBarButtonItem(image: imageButton, target: target, action: $1)
        }
        setRightBarButtonItems(buttonItems, animated: true)
    }
}

extension UIBarButtonItem {
    convenience init(image: UIImage, target: Any, action: Selector) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(target, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        self.init(customView: button)
    }
}
