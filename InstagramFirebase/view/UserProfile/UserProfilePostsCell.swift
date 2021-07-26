//
//  UserProfilePostsCell.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/1/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class UserProfilePostsCell: UICollectionViewCell {
    var post: Post? {
        didSet{
            guard let imageurl = post?.imageURL else { return }
            PostImage.LoadImage(urlString: imageurl)
        }
    }
    
    let PostImage: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func ConfigureImage() {
        addSubview(PostImage)
        PostImage.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
}
