//
//  UITableViewExt.swift
//  FinalProject
//
//  Created by MBA0176 on 4/24/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

extension UITableView {

    /// Register UITableViewHeaderFooterView with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and HeaderFooter class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewHeaderFooterView type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    public func register<T: UITableViewHeaderFooterView>(nibWithHeaderFooterClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forHeaderFooterViewReuseIdentifier: identifier)
    }

    func makeIndicatorView() -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = .white
        indicatorView.frame.size = CGSize(width: 50, height: 50)
        return indicatorView
    }
}
