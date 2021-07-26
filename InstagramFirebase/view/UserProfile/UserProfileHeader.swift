//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/23/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase
class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet{
            guard let ProfileImage = user?.ProfileImageURL else { return }
            UserProfileImage.LoadImage(urlString: ProfileImage)
            usernameLabel.text = user?.username
            ConfigureEditFollowButton()
        }
    }
    
    let UserProfileImage: CustomImageView = {
        let image = CustomImageView(image: #imageLiteral(resourceName: "userAvatar"))
        image.tintColor = UIColor(white: 0, alpha: 0.1)
        return image
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "gridIcon"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "listIcon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let bookmarksButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "bookmarksIcon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    lazy var FollowEditProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        button.titleLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditFollowButton), for: .touchUpInside)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label  = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let postsLabel: UILabel = {
       let label            = UILabel()
       let attributeTitle = NSMutableAttributedString(string: "10\n ",
                                                           attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        label.attributedText = attributeTitle
        // .Normal
        attributeTitle.append(NSAttributedString(string: "Posts",
                                                 attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]))
        label.attributedText = attributeTitle
        label.numberOfLines = 0
        label.font          = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
       let label            = UILabel()
        let attributeTitle = NSMutableAttributedString(string: "10\n ",
                                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
         label.attributedText = attributeTitle
         // .Normal
         attributeTitle.append(NSAttributedString(string: "Followers",
                                                  attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]))
         label.attributedText = attributeTitle
        label.numberOfLines = 0
        label.font          = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
       let label            = UILabel()
        let attributeTitle = NSMutableAttributedString(string: "10\n ",
                                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
         label.attributedText = attributeTitle
         // .Normal
         attributeTitle.append(NSAttributedString(string: "Following",
                                                  attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]))
        label.attributedText = attributeTitle
        label.numberOfLines = 0
        label.font          = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    func ConfigureEditFollowButton(){
        guard let CurrentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        if userId == CurrentUserId {
            FollowEditProfileButton.setTitle("Edit Profile", for: .normal)
        }else{
            // Check follow or unfollow
            Database.database().reference().child("Following").child(CurrentUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int , isFollowing == 1 {
                    self.FollowEditProfileButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.FollowStyle()
                }
            }) { (error) in
                print("Failed to check follow user: ", error.localizedDescription)
            }
        }
    }

    @objc func handleEditFollowButton(){
        
        guard let CurrentUser = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        let Values = [userId: 1]
        if FollowEditProfileButton.titleLabel?.text == "Unfollow" {
            // Unfollow
            let ref = Database.database().reference().child("Following").child(CurrentUser).child(userId)
            ref.removeValue { (error, ref) in
                if let error = error {
                    print("Failed to unfollow this user: ", error.localizedDescription)
                    return
                }
                print("Successfully to unfollow this user: ", self.user?.username ?? "")
                self.FollowStyle()
            }
            
        }else{
            // follow
        let ref = Database.database().reference().child("Following").child(CurrentUser)
        ref.updateChildValues(Values) { (error, ref) in
            if let error = error {
                print("Fialed to follow this User: ", error.localizedDescription)
                return
            }
            print("Successfully to follow this user : " , self.user?.username ?? "")
            self.FollowEditProfileButton.setTitle("Unfollow", for: .normal)
            self.FollowEditProfileButton.setTitleColor(.black, for: .normal)
            self.FollowEditProfileButton.backgroundColor = .white
        }
      }
    }
    func FollowStyle(){
        FollowEditProfileButton.setTitle("Follow", for: .normal)
        FollowEditProfileButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        FollowEditProfileButton.setTitleColor(.white, for: .normal)
        FollowEditProfileButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        ConfigureProfile()
        ConfigureToolbar()
        FollowlabelStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func FollowlabelStackView(){
        let stackView          = UIStackView(arrangedSubviews: [postsLabel, followingLabel, followersLabel])
        stackView.axis         = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, bottom: nil, left: UserProfileImage.rightAnchor, right: rightAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 50)
        
        addSubview(FollowEditProfileButton)
        FollowEditProfileButton.anchor(top: stackView.bottomAnchor, bottom: nil, left: stackView.leftAnchor, right: stackView.rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 34)
    }
    
    fileprivate func ConfigureToolbar() {
        
        let topDivderView = UIView()
        topDivderView.backgroundColor = UIColor.lightGray
        let bottomDivderView = UIView()
        bottomDivderView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarksButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(topDivderView)
        addSubview(bottomDivderView)
        stackView.anchor(top: usernameLabel.bottomAnchor, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 50)
        
        topDivderView.anchor(top: stackView.topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDivderView.anchor(top: stackView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    func ConfigureProfile(){
         addSubview(UserProfileImage)
        UserProfileImage.anchor(top: topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 80, height: 80)
        UserProfileImage.layer.cornerRadius = 80 / 2
        UserProfileImage.clipsToBounds = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: UserProfileImage.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
        

    }
    
}
