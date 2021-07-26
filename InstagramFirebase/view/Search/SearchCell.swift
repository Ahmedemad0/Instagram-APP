//
//  SearchCell.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/5/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    var user: User?{
        didSet{
            guard let url = user?.ProfileImageURL else { return }
            UserProfileImageView.LoadImage(urlString: url)
            UsernameLabel.text = user?.username
        }
    }
    let UserProfileImageView: CustomImageView = {
        let image                = CustomImageView()
        image.layer.cornerRadius = 50/2
        image.contentMode        = .scaleAspectFill
        image.clipsToBounds      = true
        return image
    }()

    let UsernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func ConfigureCell(){
        addSubview(UserProfileImageView)
           UserProfileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 50, height: 50)
        UserProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(UsernameLabel)
        UsernameLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: UserProfileImageView.rightAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        addSubview(line)
        line.anchor(top: nil, bottom: bottomAnchor, left: UsernameLabel.leftAnchor, right: UsernameLabel.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
}
