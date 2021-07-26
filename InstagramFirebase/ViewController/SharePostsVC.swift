//
//  SharePostsVC.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/28/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class SharePostsVC: UIViewController {
    
    var SelectedImage: UIImage?  {
        didSet {
            self.HeaderImage.image = SelectedImage
        }
    }
    
    let HeaderImage: UIImageView = {
        let image           = UIImageView()
        image.contentMode   = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let CaptionView: UITextView = {
        let text  = UITextView()
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let CaptionLabel: UILabel = {
        let label  = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Write your caption"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ConfigureNavBar()
        Configure()
    }
    func ConfigureNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handlerShare))
    }
    @objc func handlerShare(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let image = SelectedImage else { return }
        guard let UploadData = image.jpegData(compressionQuality: 0.5) else { return }
       // User_id
        let filename = NSUUID().uuidString
       // Values of Storage
       let storageRef = Storage.storage().reference()
       let storageProfileRef = storageRef.child("Posts").child(filename)
        
        storageProfileRef.putData(UploadData, metadata: nil) { (metaData, error) in
            if error != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                 print("Failed to Save post image: ")
                return
                }
        storageProfileRef.downloadURL { (url, error) in
            guard let imageURL = url?.absoluteString else { return }
             print("Successfully to save post image: ", imageURL)
            self.SaveDataInDatabase(imageURL: imageURL)
        }
      }
    }
    
    func SaveDataInDatabase(imageURL: String){
        guard let image = SelectedImage else { return}
        guard let Caption = CaptionView.text, Caption.count > 0  else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let Values = ["imageURL": imageURL, "Caption": Caption, "Image_Width": image.size.width, "Image_Height": image.size.height, "Creation_Date": Date().timeIntervalSince1970] as [String : Any]
        let userPostRef = Database.database().reference().child("Posts").child(uid)
        let ref = userPostRef.childByAutoId()
        ref.updateChildValues(Values, withCompletionBlock: { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save Posts in DB: ", error.localizedDescription)
                return
            }
            print("Successfully to save posts in DB")
            self.dismiss(animated: true)
          })
        }
    
    func Configure(){
        let padding: CGFloat = 20
        view.addSubview(HeaderImage)
        HeaderImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: padding, paddingBottom: 0, paddingLeft: padding, paddingRight: padding, width: 0, height: (view.frame.height / 2))
        
        view.addSubview(CaptionLabel)
        CaptionLabel.anchor(top: HeaderImage.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: padding, paddingBottom: 0, paddingLeft: padding, paddingRight: padding, width: 0, height: 0)
        
        view.addSubview(CaptionView)
        CaptionView.anchor(top: CaptionLabel.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingBottom: -padding, paddingLeft: padding, paddingRight: padding, width: 0, height: 0)
    }
}
