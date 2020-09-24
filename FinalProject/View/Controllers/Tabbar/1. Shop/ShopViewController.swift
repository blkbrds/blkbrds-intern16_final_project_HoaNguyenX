//
//  ShopViewController.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

final class ShopViewController: ViewController {
    
// MARK: - @IBOutlet
    @IBOutlet private weak var segment: UISegmentedControl!
    @IBOutlet private weak var productCollectionView: UICollectionView!
    
// MARK: - @Properties
    private var viewModel: ShopViewModel = ShopViewModel()

// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUISegment()
        configProductCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
// MARK: - Private Functions
    private func configUISegment() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let font = UIFont.systemFont(ofSize: 21)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    private func configProductCollectionView() {
        let nib = UINib(nibName: "ProductCell", bundle: .main)
        productCollectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.backgroundColor = .none
        productCollectionView.showsVerticalScrollIndicator = false
    }
    
// MARK: - @ IBActions
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // work after handle API
            break
        case 1:
            // work after handle API
            break
        default:
            break
        }
    }
}

// MARK: - extension
extension ShopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension ShopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // work after
    }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let midSpace: CGFloat = 10
        let width: CGFloat = (collectionView.width / 2) - (midSpace / 2)
        let height: CGFloat = width + 30
        return CGSize(width: width, height: height)
    }
}
