//
//  Extentions.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/4/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat)-> UIColor{
       return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

    }
}

extension Date {
    func TimeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 30 * day
        
        let qoutient: Int
        let unit: String
        if secondsAgo < minute {
            qoutient = secondsAgo
            unit = "second"
        }else if secondsAgo < hour {
            qoutient = secondsAgo / minute
            unit = "min"
        }else if secondsAgo < day {
            qoutient = secondsAgo / hour
            unit = "hour"
        }else if secondsAgo < week {
            qoutient = secondsAgo / day
            unit = "day"
        }else if secondsAgo < month {
            qoutient = secondsAgo / week
            unit = "week"
        }else {
            qoutient = secondsAgo / month
            unit = "month"
        }
        let time = "\(qoutient) \(unit)\(qoutient == 1 ? "" : "s") ago"
        return time
    }
}

