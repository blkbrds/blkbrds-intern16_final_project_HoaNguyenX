//
//  SenderCell.swift
//  FinalProject
//
//  Created by NXH on 9/28/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

final class SenderCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var maskSender: UIView!
    @IBOutlet  weak var sms: UILabel!
    @IBOutlet private weak var viewContainerTextLabel: UIView!
    
    var viewModel: SenderCellViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    // MARK: - Private Functions
    private func configUI() {
        viewContainerTextLabel.cornerRadius = height / 5
    }
    
    private func updateView() {
        sms.text = viewModel?.body
    }
}
