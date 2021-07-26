//
//  Button.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/16/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        Configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Configure(){
        layer.cornerRadius = 5
        backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        setTitleColor(.white, for: .normal)
        
    }
    
}
