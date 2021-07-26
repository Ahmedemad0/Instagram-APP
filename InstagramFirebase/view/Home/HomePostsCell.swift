//
//  HomePostsCell.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/2/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class HomePostsCell: UICollectionViewCell {
    var post: Post?{
        didSet{
            // to get post image
            guard let imageUrl = post?.imageURL else { return }
            PostImage.LoadImage(urlString: imageUrl)
            // to get username of user that who shared this post
            usernameLabel.text = post?.user.username
            // to get imageProfie of user that who shared this post
            guard let UserProfileImage = post?.user.ProfileImageURL else { return }
            UserPhoto.LoadImage(urlString: UserProfileImage)
            // To get caption of this post
            SetupCaption()
        }
    }
    let PostImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    let UserPhoto: CustomImageView = {
        let image = CustomImageView()
        image.layer.cornerRadius = 40/2
        image.contentMode        = .scaleAspectFill
        image.clipsToBounds      = true
        return image
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let optionButton: UIButton = {
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let lovebutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "likeIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let Commentbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "commentIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let Sendbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "sendIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let bookmarksbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "bookmarksIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let Caption: UILabel = {
        let label = UILabel()

        label.numberOfLines = 0
        return label
    }()
    fileprivate func SetupCaption(){
        guard let post = post else { return }
        let creationTime = post.Creation_Date.TimeAgoDisplay()
        let attributeText = NSMutableAttributedString(string:"\(post.user.username)  ",
                                                       attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        // .Normal
        attributeText.append(NSAttributedString(string: post.Caption,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributeText.append(NSAttributedString(string: "\n\n \(creationTime)",
                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))

        self.Caption.attributedText = attributeText
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        Configure()
        ConfigureActionsButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func Configure(){
        addSubview(UserPhoto)
        UserPhoto.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, bottom: nil, left: UserPhoto.rightAnchor, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        addSubview(optionButton)
        optionButton.anchor(top: topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 44, height: 0)
        addSubview(PostImage)
        PostImage.anchor(top: UserPhoto.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        PostImage.heightAnchor.constraint(equalTo: widthAnchor , multiplier: 1).isActive = true
        
    }
    
    func ConfigureActionsButton(){
        let stackView = UIStackView(arrangedSubviews: [lovebutton, Commentbutton, Sendbutton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(PostImage)
        addSubview(stackView)
        stackView.anchor(top: PostImage.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 12, paddingBottom: 0, paddingLeft: 4, paddingRight: 0, width: 120, height: 30)
        addSubview(bookmarksbutton)
        bookmarksbutton.anchor(top: PostImage.bottomAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 30, height: 30)
        addSubview(Caption)
        Caption.anchor(top: stackView.bottomAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
    }
}
