//
//  SearchVC.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/5/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    let CellId = "CellId"
    var users = [User]()
    var filterdUsers = [User]()
    var Searching = false
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "  Enter username"
        search.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        search.delegate = self
        return search
    }()
    
    override func viewDidLoad() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: CellId)
        collectionView.keyboardDismissMode = .onDrag
        FetchUser()
        ConfigureSearchBar()
    }
    
    func ConfigureSearchBar(){
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filterdUsers = users
        }else{
        filterdUsers = self.users.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
       }
        self.collectionView.reloadData()
    }
    
    func FetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let UserDICS = snapshot.value as? [String: Any] else { return }
            UserDICS.forEach { (key, value) in
                // to hide your account from search list
                if key == uid { return }
                guard let UserDIC = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: UserDIC)
                self.users.append(user)
            }
            self.users.sort { (user1, user2) -> Bool in
                let sort = user1.username.compare(user2.username) == .orderedAscending
                return sort
            }
            self.filterdUsers = self.users
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to load Values: ", error.localizedDescription)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let useri = filterdUsers[indexPath.item]
        let userprofile = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userprofile.userId = useri.uid
        navigationController?.pushViewController(userprofile, animated: true)

    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterdUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! SearchCell
        cell.backgroundColor = .systemBackground
        cell.user = filterdUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
