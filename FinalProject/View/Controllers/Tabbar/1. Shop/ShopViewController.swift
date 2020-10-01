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
    private var collectionClothesRefreshControl: UIRefreshControl = UIRefreshControl()
    private var collectionShoesRefreshControl: UIRefreshControl = UIRefreshControl()
    private var isReloadShoes: Bool = true
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUISegment()
        configProductsCollectionView()
        refreshClothes()
        refreshShoes()
        loadApiClothes()
        getViewer()
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
        viewModelClothes.getClothes { result in
            switch result {
            case .success:
                self.viewModelClothes.products.shuffle()
                DispatchQueue.main.async {
                    self.clothesCollectionView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    private func loadApiShoes() {
        viewModelShoes.getShoes { result in
            switch result {
            case .success:
                self.viewModelShoes.products.shuffle()
                DispatchQueue.main.async {
                    self.shoesCollectionView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    private func getViewer() {
        viewModelClothes.getViewer { _ in
        }
    }
    
    private func refreshClothes() {
        collectionClothesRefreshControl.tintColor = .red
        let tableViewAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        collectionClothesRefreshControl.attributedTitle = NSAttributedString(string: "Refesh", attributes: tableViewAttributes)
        collectionClothesRefreshControl.addTarget(self, action: #selector(refreshClothesControl), for: .valueChanged)
        clothesCollectionView.addSubview(collectionClothesRefreshControl)
    }
    
    private func refreshShoes() {
        collectionShoesRefreshControl.tintColor = .red
        let tableViewAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        collectionShoesRefreshControl.attributedTitle = NSAttributedString(string: "Refesh", attributes: tableViewAttributes)
        collectionShoesRefreshControl.addTarget(self, action: #selector(refreshShoesControl), for: .valueChanged)
        shoesCollectionView.addSubview(collectionShoesRefreshControl)
    }
    
    // MARK: - Objc Funcions
    @objc private func refreshClothesControl() {
        loadApiClothes()
        collectionClothesRefreshControl.endRefreshing()
    }
    
    @objc private func refreshShoesControl() {
        loadApiShoes()
        collectionShoesRefreshControl.endRefreshing()
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
        if collectionView.tag == 1 {
            return viewModelClothes.numberOfItems(inSection: 0)
        }
        return viewModelShoes.numberOfItems(inSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            guard let clothesCell = clothesCollectionView.dequeueReusableCell(withReuseIdentifier: "ClothesCell", for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            clothesCell.viewModel = viewModelClothes.getProductCell(atIndexPath: indexPath)
            return clothesCell
        case 2:
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
        let vc = ChatViewController()
        vc.viewModel.idReceiver = FirebaseKey.adminID
        guard let viewer = viewModelClothes.viewer?.id else { return }
        vc.viewModel.idSender = viewer
        switch collectionView.tag {
        case 1:
            guard let clothes = viewModelClothes.products[safe: indexPath.row]?.description else { return }
            vc.viewModel.postMessageToFirebase(body: MessageKey.maskSendToViewer + clothes)
        case 2:
            guard let shoes = viewModelShoes.products[safe: indexPath.row]?.description else { return }
            vc.viewModel.postMessageToFirebase(body: MessageKey.maskSendToViewer + shoes)
        default:
            break
        }
        navigationController?.pushViewController(vc)
    }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let midSpace: CGFloat = 10
        let heightDescription: CGFloat = 30
        let width: CGFloat = (collectionView.width / 2) - (midSpace)
        let height: CGFloat = width + heightDescription
        return CGSize(width: width, height: height)
    }
}
