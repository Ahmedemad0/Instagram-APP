//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/23/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let CellId = "CellId"
    var userId: String?
    var Posts = [Post]()
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        FetchUserData()
        ConfigureLogoutButton()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(UserProfilePostsCell.self, forCellWithReuseIdentifier: CellId)
    }
    
    fileprivate func FetchPosts(){
        guard let uid = user?.uid else { return}
                let ref = Database.database().reference().child("Posts").child(uid)
                ref.queryOrdered(byChild: "Creation_Date").observe(.childAdded, with: { (snapshot) in
                    guard let PostsDIC = snapshot.value as? [String: Any] else { return }
                    guard let user = self.user else { return}
                    let post = Post(user: user, dictionary: PostsDIC)
                        self.Posts.insert(post, at: 0)
                    self.collectionView.reloadData()
                }) { (error) in
                    print("Failed to load Values: ", error.localizedDescription)
          }
        }
    
    fileprivate func ConfigureLogoutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gearIcon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handlerLogOut))
    }
    
    @objc func handlerLogOut(){
        let alertMessage = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertMessage.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LogInVC()
                let navController   = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            } catch let signOutError{
                print("Failed to sign out :", signOutError)
            }           
        }))
        alertMessage.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertMessage, animated: true)
    }
    
    // to make a header of CollectionView
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    // to make a size to header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    // Number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Posts.count
    }
    // cell details
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! UserProfilePostsCell
        cell.post = Posts[indexPath.item]
        return cell
    }
    // size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3) / 3
        return CGSize(width: width, height: width)
    }
    // for Spacing Vertical
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // For spacing Horizental
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // to get User data
   fileprivate func FetchUserData(){
        // to get user id
     let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
     Database.FetchUserWithUID(uid: uid) { (user) in
        self.user = user
        self.navigationItem.title = self.user?.username
        self.collectionView.reloadData()
        self.FetchPosts()

     }
    }
}
