//
//  SingUPVC.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/23/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class SignUPVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(handlerPhoto), for: .touchUpInside)
        return button
    }()
    
let LogInButton: UIButton = {
    let button = UIButton(type: .system)
    let attributeTitle = NSMutableAttributedString(string: "Already have an account  ",
                                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    button.setAttributedTitle(attributeTitle, for: .normal)
    // .Normal
    attributeTitle.append(NSAttributedString(string: "Log In",
                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
    button.setAttributedTitle(attributeTitle, for: .normal)
    button.addTarget(self, action: #selector(handlerShowSignIn), for: .touchUpInside)
    return button
}()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let EditedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
              plusButton.setImage(EditedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let OriginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
              plusButton.setImage(OriginalImage.withRenderingMode(.alwaysOriginal), for: .normal)

         }
            plusButton.layer.cornerRadius  = plusButton.frame.width/2
            plusButton.layer.masksToBounds = true
            plusButton.layer.borderWidth   = 3
            plusButton.layer.borderColor  = UIColor.black.cgColor
            dismiss(animated: true, completion: nil)
    }

    @objc func handlerShowSignIn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handlerPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleTextField(){
        let isFormVaild = emailTF.text?.count ?? 0 > 0 && UsernameTF.text?.count ?? 0 > 0 && PasswordTF.text?.count ?? 7 > 7
        if isFormVaild {
            signUpbutton.isEnabled = true
            signUpbutton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpbutton.isEnabled = false
            signUpbutton.backgroundColor =  UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handlerSignUP(){
        // TextField
        guard let email         = emailTF.text  else { return }
        guard let username      = UsernameTF.text else { return }
        guard let password      = PasswordTF.text  else { return }
        
        // Database Variables
        let storageDatabase = Database.database().reference()
        let storageProfile = storageDatabase.child("Users")
        
        // download data scope
        guard let image = self.plusButton.imageView?.image else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        // Create User in firebase
       Auth.auth().createUser(withEmail: email, password: password) { (UserData, error) in
        if error != nil {
            print("Failed to Create user : ", error?.localizedDescription ?? "")
            return
        }
            print("Successfully to create user : ", UserData ?? "gr")
        // User_id
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // Values of Storage
        let storageRef = Storage.storage().reference()
        let storageProfileRef = storageRef.child("Profile_Images").child(uid)
        
        storageProfileRef.putData(uploadData, metadata: metadata) { (StorageMetadata, error) in
            if error != nil {
                print("Failed to Save Image")
            }

        storageProfileRef.downloadURL { (url, error) in
            guard let ProfileImageURL = url?.absoluteString else { return }
               print("Successfully to upload image", ProfileImageURL)
            // Values of user
            let DictValues = ["username": username, "ProfileImageURL": ProfileImageURL]
            let Values = [uid: DictValues]
           // Database FUNC.
        storageProfile.updateChildValues(Values, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("Failed to save user info in db", error.localizedDescription)
               return
            }
               print("Successfully to save user info in db")
            // to open window directly 
            guard let mainTabBarController = UIApplication.shared.windows[0].rootViewController as? MainTabBarController else { return }
            mainTabBarController.SetupVC()
            self.dismiss(animated: true, completion: nil)
         })

            }
        }
      }
    }

    let emailTF         = TextField(placeholder: "  E_Mail")
    let UsernameTF      = TextField(placeholder: "  Username")
    let PasswordTF      = TextField(placeholder: "  Password")
    let signUpbutton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handlerSignUP), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        Configure()
        ConfigureImage()
        ConfigureStackView()
        ConfigureLogInButton()
    }
    
    func Configure(){
        emailTF.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        UsernameTF.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        PasswordTF.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        PasswordTF.isSecureTextEntry = true
    }
    func ConfigureImage(){
        view.addSubview(plusButton)
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil , left: nil, right: nil, paddingTop: 30, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 180, height: 180)
    }
    
    func ConfigureStackView(){
        let stackView = UIStackView(arrangedSubviews: [emailTF, UsernameTF, PasswordTF, signUpbutton])
        stackView.distribution   = .fillEqually
        stackView.axis           = .vertical
        stackView.spacing        = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: plusButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 220)
    }
    
    func ConfigureLogInButton(){
        view.addSubview(LogInButton)
        LogInButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 30, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
    }
}
