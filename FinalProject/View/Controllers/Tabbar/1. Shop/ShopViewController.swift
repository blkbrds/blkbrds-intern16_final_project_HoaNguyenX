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
    @IBOutlet private weak var clothesCollectionView: UICollectionView!
    @IBOutlet private weak var shoesCollectionView: UICollectionView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    private var viewModelClothes: ShopViewModel = ShopViewModel()
    private var viewModelShoes: ShopViewModel = ShopViewModel()
    private var collectionRefreshControl: UIRefreshControl = UIRefreshControl()
    private var isReloadShoes: Bool = true
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUISegment()
        configProductsCollectionView()
        loadApiClothes()
        refresh()
    }
    
    // MARK: - Private Functions
    private func configUISegment() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let font = UIFont.systemFont(ofSize: 21)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    private func configProductsCollectionView() {
        let nib = UINib(nibName: "ProductCell", bundle: .main)
        clothesCollectionView.register(nib, forCellWithReuseIdentifier: "ClothesCell")
        clothesCollectionView.delegate = self
        clothesCollectionView.dataSource = self
        clothesCollectionView.backgroundColor = .none
        clothesCollectionView.showsVerticalScrollIndicator = false
        
        shoesCollectionView.register(nib, forCellWithReuseIdentifier: "ShoesCell")
        shoesCollectionView.delegate = self
        shoesCollectionView.dataSource = self
        shoesCollectionView.backgroundColor = .none
        shoesCollectionView.showsVerticalScrollIndicator = false
    }

    private func loadApiClothes() {
        viewModelClothes.getClothes { (done) in
            if done {
                DispatchQueue.main.async {
                    self.clothesCollectionView.reloadData()
                }
            }
        }
    }
    
    private func loadApiShoes() {
        viewModelShoes.getShoes { (done) in
            if done {
                DispatchQueue.main.async {
                    self.shoesCollectionView.reloadData()
                }
            }
        }
    }
    
    private func refresh() {
      collectionRefreshControl.tintColor = .black
      let tableViewAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
      collectionRefreshControl.attributedTitle = NSAttributedString(string: "Refesh", attributes: tableViewAttributes)
      collectionRefreshControl.addTarget(self, action: #selector(refreshControl), for: .valueChanged)
      clothesCollectionView.addSubview(collectionRefreshControl)
    }
    
    // MARK: - Objc Funcions
    @objc private func refreshControl() {
        loadApiClothes()
        collectionRefreshControl.endRefreshing()
    }
    
    // MARK: - @IBActions
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            scrollView.setContentOffset(CGPoint(x: clothesCollectionView.x, y: clothesCollectionView.y), animated: true)
        case 1:
            scrollView.setContentOffset(CGPoint(x: shoesCollectionView.x, y: shoesCollectionView.y), animated: true)
            if isReloadShoes {
                loadApiShoes()
                isReloadShoes = false
            }
        default:
            break
        }
    }
}

// MARK: - extension
extension ShopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clothesCollectionView {
            return viewModelClothes.numberOfItems(inSection: 0)
        }
        return viewModelShoes.numberOfItems(inSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let clothesCell = clothesCollectionView.dequeueReusableCell(withReuseIdentifier: "ClothesCell", for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            clothesCell.viewModel = viewModelClothes.getProductCell(atIndexPath: indexPath)
            return clothesCell
        case 1:
            guard let shoesCell = shoesCollectionView.dequeueReusableCell(withReuseIdentifier: "ShoesCell", for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            shoesCell.viewModel = viewModelShoes.getProductCell(atIndexPath: indexPath)
            return shoesCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ShopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let midSpace: CGFloat = 10
        let heightDescription: CGFloat = 30
        let width: CGFloat = (collectionView.width / 2) - (midSpace / 2)
        let height: CGFloat = width + heightDescription
        return CGSize(width: width, height: height)
    }
}
