//
//  HomeVC.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/2/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var Posts = [Post]()
    let CellId = "CellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomePostsCell.self, forCellWithReuseIdentifier: CellId)
        FetchPosts()
        FetchFollowingPosts()
        ConfigureNavBar()
//        Database.FetchUserWithUID(uid: "2MyXqmbPyJeX3JmeDCTKorkWhVQ2") { (user) in
//            self.FetchpostWithUser(user: user)
//        }
    }
    func ConfigureNavBar(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "instaLogo"))
    }
    
    fileprivate func FetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return}
        // to get the user who shared the post
        Database.FetchUserWithUID(uid: uid) { (user) in
            self.FetchpostWithUser(user: user)
        }
    }
    fileprivate func FetchpostWithUser(user: User){
            // to get this post from database
        let ref = Database.database().reference().child("Posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let PostsDICS = snapshot.value as? [String: Any] else { return }
            // loop to get post of posts in database
            PostsDICS.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
            // fetch this post
            let post = Post(user: user,dictionary: dictionary)
                self.Posts.append(post)
            }
            self.Posts.sort { (post1, post2) -> Bool in
                let newestPost = post1.Creation_Date.compare(post2.Creation_Date) == .orderedDescending
                return newestPost
            }
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to load Values: ", error.localizedDescription)
        }

    }
    
    fileprivate func FetchFollowingPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // to fetch user ids
        Database.database().reference().child("Following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followingIdsDIC = snapshot.value as? [String: Any] else { return }
            followingIdsDIC.forEach { (key , value) in
                // to fetch following posts
                Database.FetchUserWithUID(uid: key) { (user) in
                    self.FetchpostWithUser(user: user)
                }
            }
        }) { (error) in
            print("Failed to fetch user ids : ", error.localizedDescription)
        }

    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! HomePostsCell
        cell.post = Posts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height: CGFloat = 56
        height += width
        height += 150
        return CGSize(width: width, height: height)
    }
}
