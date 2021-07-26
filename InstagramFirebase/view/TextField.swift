//
//  TextField.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/16/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        Configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String){
        super.init(frame: .zero)
        self.placeholder = placeholder
        Configure()
    }
    
    func Configure(){
        backgroundColor         = UIColor(white: 0, alpha: 0.07)
        layer.cornerRadius      = 5
        layer.borderWidth       = 2
        layer.borderColor       = UIColor.systemGray4.cgColor
    }
    
}
