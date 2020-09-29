//
//  TabbarViewController.swift
//  FinalProject
//
//  Created by NXH on 9/21/20.
//  Copyright © 2020 MBA0176. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    // MARK: - Properties
    private var homeNavi: UINavigationController = UINavigationController(rootViewController: ShopViewController())
    private var mapNavi: UINavigationController = UINavigationController(rootViewController: FriendsViewController())
    private var favoritesNavi: UINavigationController = UINavigationController(rootViewController: ConversationsViewController())
    private var profileNavi: UINavigationController = UINavigationController(rootViewController: ProfileViewController())
    private var value: Int = 0
        
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
<<<<<<< Updated upstream
        advanceCustomTabbar()
=======
        customTabbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
>>>>>>> Stashed changes
    }
        
    // MARK: - Private functions
    private func configTabbar() {
<<<<<<< Updated upstream
        let tabbarItems: [UIViewController] = [homeNavi, mapNavi, favoritesNavi, profileNavi]
        homeNavi.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "icons8-shop-50"), selectedImage: UIImage(named: "icons8-shopSelected-50")?.withRenderingMode(.alwaysOriginal))
        mapNavi.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "icons8-friend-50"), selectedImage: UIImage(named: "icons8-friendSelected-50")?.withRenderingMode(.alwaysOriginal))
        favoritesNavi.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "icons8-conversation-50"), selectedImage: UIImage(named: "icons8-conversationSelect-50")?.withRenderingMode(.alwaysOriginal))
        profileNavi.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "icons8-profile-50"), selectedImage: UIImage(named: "icons8-profileSelect-50")?.withRenderingMode(.alwaysOriginal))
        viewControllers = tabbarItems
    }
        
    private func advanceCustomTabbar() {
        tabBar.barTintColor = .yellow
        tabBar.isTranslucent = false
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .blue
        for index in 0..<tabBar.subviews.count {
            tabBar.subviews[index].layer.cornerRadius = 10
            tabBar.subviews[index].layer.borderWidth = 1
            tabBar.subviews[index].layer.borderColor = UIColor.red.cgColor
        }
=======
        let tabbarItems: [UIViewController] = [shopNavi, friendsNavi, conversationsNavi, profileNavi]
        shopNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.shop, image: UIImage(named: TabbarItemsKey.Image.shop), tag: 1)
        friendsNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.friends, image: UIImage(named: TabbarItemsKey.Image.friends), tag: 2)
        conversationsNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.conversations, image: UIImage(named: TabbarItemsKey.Image.conversations), tag: 3)
        profileNavi.tabBarItem = UITabBarItem(title: TabbarItemsKey.Name.profile, image: UIImage(named: TabbarItemsKey.Image.profile), tag: 4)
        viewControllers = tabbarItems
    }
    
    private func customTabbar() {
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor(hexString: "E74C3C")
        tabBar.unselectedItemTintColor = UIColor(hexString: "CCCCCC")
>>>>>>> Stashed changes
    }
}

// MARK: - UITabBarControllerDelegate
extension TabbarViewController: UITabBarControllerDelegate {
        
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.2, 1.4, 1.6, 1.8, 2.0, 1.8, 1.6, 1.4, 1.2]
            bounceAnimation.duration = TimeInterval(0.4)
            return bounceAnimation
            }()
        guard let index = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > index + 1, let imageView = tabBar.subviews[index + 1].subviews.compactMap({ $0 as? UIImageView }).first else { return }
            imageView.layer.add(bounceAnimation, forKey: nil)
        }
    }
