//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/27/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    var imageCell: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        Configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Configure(){
        addSubview(imageCell)
        imageCell.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
}
