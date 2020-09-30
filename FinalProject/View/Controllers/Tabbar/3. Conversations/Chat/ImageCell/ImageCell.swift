//
//  ImageCell.swift
//  FinalProject
//
//  Created by NXH on 9/30/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

final class ImageCell: UITableViewCell {

    // MARK: - @IBOutlet
    @IBOutlet private weak var leftImage: UIImageView!
    @IBOutlet private weak var rightImage: UIImageView!
    
    var viewModel: ImageMessageCellViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateView() {
        guard let viewModel = viewModel else { return }
        if viewModel.isOwner {
            do {
                let data = try Data(contentsOf: viewModel.url)
                rightImage.image = UIImage(data: data)
                leftImage.isHidden = true
            } catch {
                
            }
        }
    }
}
