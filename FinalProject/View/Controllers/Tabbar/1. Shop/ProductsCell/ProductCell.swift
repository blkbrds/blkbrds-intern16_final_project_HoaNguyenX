//
//  CollectionViewCell.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

final class ProductCell: UICollectionViewCell {

// MARK: - @IBOutlet
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var descriptionLable: UILabel!

// MARK: - Properties
    var viewModel: ProductCellViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

// MARK: - Private Functions
    private func configCell() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    private func updateView() {
        guard let product = viewModel?.product else {
            return
        }
        productImage.image = UIImage(named: product.image)
        descriptionLable.text = product.description
    }
}
