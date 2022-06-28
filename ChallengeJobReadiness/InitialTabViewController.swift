//
//  InitialTabViewController.swift
//  ChallengeJobReadiness
//
//  Created by Guilherme Wilhelm Magnabosco on 27/06/22.
//

import UIKit

final class InitialTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        tabBar.backgroundColor = .white
    }
    
    func setupViewControllers() {
        let homeTab = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let homeNavigationViewController = UINavigationController(rootViewController: homeTab)
        homeNavigationViewController.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let favoritesTab = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
        let favoritesNavigationViewController = UINavigationController(rootViewController: favoritesTab)
        favoritesNavigationViewController.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart"))
        
        let purchasesTab = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
        let purchasesNavigationViewController = UINavigationController(rootViewController: purchasesTab)
        purchasesNavigationViewController.tabBarItem = UITabBarItem(title: "Mís Compras", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag"))
        
        let notificationsTab = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
        let notificationsNavigationViewController = UINavigationController(rootViewController: notificationsTab)
        notificationsNavigationViewController.tabBarItem = UITabBarItem(title: "Notificaciones", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell"))
        
        let moreTab = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
        let moreNavigationViewController = UINavigationController(rootViewController: moreTab)
        moreNavigationViewController.tabBarItem = UITabBarItem(title: "Más", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet"))
                
        viewControllers = [homeNavigationViewController, favoritesNavigationViewController, purchasesNavigationViewController, notificationsNavigationViewController, moreNavigationViewController] //purchasesNavigationViewController, notificationsViewController, moreViewController]
    }

}
