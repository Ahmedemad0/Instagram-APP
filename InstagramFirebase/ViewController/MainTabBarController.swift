//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/23/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase
class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
    // select viewController from tabBar to turn on or not
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorVC(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            navController.modalPresentationStyle = .fullScreen
            present(navController , animated: true)
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // to choose what VC show if user is login or out
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
            let loginController = LogInVC()
            let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
            return
        }
        SetupVC()
        ConfigureImageInsets()
        
    }
    // edged between icons in tabBar
    func ConfigureImageInsets(){
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: 1, right: 0)
        }
    }
    
    func SetupVC(){
        // homeVC
        let homeNavController = TemplateNavController(unselectedImage: #imageLiteral(resourceName: "homeIcon"), selectedImage: #imageLiteral(resourceName: "homeSelectedIcon"), rootViewController: HomeVC(collectionViewLayout: UICollectionViewFlowLayout()))
        // searchVC
        let SearchNavController = TemplateNavController(unselectedImage: #imageLiteral(resourceName: "searchIcon"), selectedImage: #imageLiteral(resourceName: "searchIcon"), rootViewController: SearchVC(collectionViewLayout: UICollectionViewFlowLayout()))
        // Plus VC
        let PlusNavController = TemplateNavController(unselectedImage: #imageLiteral(resourceName: "plusIcon"), selectedImage: #imageLiteral(resourceName: "plusIcon"), rootViewController: PhotoSelectorVC())
        // like VC
        let likeNavController = TemplateNavController(unselectedImage: #imageLiteral(resourceName: "likeIcon"), selectedImage: #imageLiteral(resourceName: "likeSelectedIcon"), rootViewController: UIViewController())
        // user profile VC
        let layout = UICollectionViewFlowLayout()
        let UserProfile = UserProfileController(collectionViewLayout: layout)
        let UserNavController = UINavigationController(rootViewController: UserProfile)
        UserNavController.tabBarItem.image = #imageLiteral(resourceName: "profileIcon")
        UserNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profileIconSelected")
        tabBar.tintColor = .black
        // Controller in tabBar
        viewControllers = [homeNavController, SearchNavController, PlusNavController, likeNavController, UserNavController]
    }
   // Template to Call controller
    fileprivate func TemplateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController())-> UINavigationController {
        let viewController = rootViewController
        let navController  = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image         = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
