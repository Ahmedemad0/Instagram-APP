//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Ahmed on 10/4/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    var ImageCache = [String: UIImage]()
    var LastUrlUsedToLoad: String?
    func LoadImage(urlString: String){
        LastUrlUsedToLoad = urlString
        if let CachedImage = ImageCache[urlString]{
            self.image = CachedImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to download image: ", error.localizedDescription)
                return
            }
            if url.absoluteString != self.LastUrlUsedToLoad {
                return
            }
            guard let imageData = data else { return }
            let PhotoImage = UIImage(data: imageData)
            self.ImageCache[url.absoluteString] = PhotoImage
            DispatchQueue.main.async {
                self.image = PhotoImage
            }
        }.resume()
    }
}

