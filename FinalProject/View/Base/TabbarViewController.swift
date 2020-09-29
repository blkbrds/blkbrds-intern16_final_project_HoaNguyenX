//
//  TabbarViewController.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

final class TabbarViewController: UITabBarController {
    
    // MARK: - Properties
    private var shopNavi: UINavigationController = UINavigationController(rootViewController: ShopViewController())
    private var friendsNavi: UINavigationController = UINavigationController(rootViewController: FriendsViewController())
    private var conversationsNavi: UINavigationController = UINavigationController(rootViewController: ConversationsViewController())
    private var profileNavi: UINavigationController = UINavigationController(rootViewController: ProfileViewController())
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
        customTabbar()
        configNavi()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
    }
    
    // MARK: - Private functions
    private func configTabbar() {
        let tabbarItems: [UIViewController] = [shopNavi, friendsNavi, conversationsNavi, profileNavi]
        shopNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.shop, image: UIImage(named: TabbarItemsKey.Image.shop), tag: 1)
        friendsNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.shop, image: UIImage(named: TabbarItemsKey.Image.friends), tag: 2)
        conversationsNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.conversations, image: UIImage(named: TabbarItemsKey.Image.conversations), tag: 3)
        profileNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.profile, image: UIImage(named: TabbarItemsKey.Image.profile), tag: 4)
        viewControllers = tabbarItems
    }
    
    private func customTabbar() {
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor(hexString: "E74C3C")
        tabBar.unselectedItemTintColor = UIColor(hexString: "CCCCCC")
    }
    
    private func configNavi() {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - UITabBarControllerDelegate
extension TabbarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let bounceAnimation: CAKeyframeAnimation = {
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.1, 1.2, 1.3, 1.2, 1.1]
            bounceAnimation.duration = TimeInterval(0.2)
            return bounceAnimation
        }()
        guard let index = tabBar.items?.firstIndex(of: item),
            tabBar.subviews.count > index + 1,
            let imageView = tabBar.subviews[index + 1].subviews.compactMap({ $0 as? UIImageView }).first else { return }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}
