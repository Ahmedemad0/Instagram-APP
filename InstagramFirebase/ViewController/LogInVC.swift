//
//  SignOutVC.swift
//  InstagramFirebase
//
//  Created by Ahmed on 9/24/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import UIKit
import Firebase
class LogInVC: UIViewController {
    let emailTF     = TextField(placeholder: "  E_Mail")
    let passwordTF  = TextField(placeholder: "  Passsword")
    let logInButton = Button(type: .system)
    
    let LogoContinerView: UIView = {
        let view = UIView()
         view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "instaLogo"))
        logoImage.contentMode = .scaleAspectFill
        view.addSubview(logoImage)
        logoImage.anchor(top: nil, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 250, height: 100)
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    let SignUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "Don't have an account?  ",
                                                           attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        button.setAttributedTitle(attributeTitle, for: .normal)
        // .Normal
        attributeTitle.append(NSAttributedString(string: "Sign UP",
                                                 attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handlerShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleTextField(){
        let isFormVaild = emailTF.text?.count ?? 0 > 0  && passwordTF.text?.count ?? 7 > 7
        if isFormVaild {
            logInButton.isEnabled = true
            logInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            logInButton.isEnabled = false
            logInButton.backgroundColor =  UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handlerLogIn(){
        guard let email       = emailTF.text else { return }
        guard let password    = passwordTF.text else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to Log In with this email: ", error.localizedDescription)
                return
            }
           guard let uid = Auth.auth().currentUser?.uid else { return }
               print("Successfully to Log In : ", uid)
            // to open window directly 
            guard let mainTabBarController = UIApplication.shared.windows[0].rootViewController as? MainTabBarController else { return }
            mainTabBarController.SetupVC()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handlerShowSignUp(){
            let signUpController = SignUPVC()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        ConfigureSignUp()
        ConfigureLogoContinerView()
        ConfigureTF()
        ConfigureStackView()
    }
    
    func ConfigureTF(){
        logInButton.setTitle("Log In", for: .normal)
        logInButton.isEnabled = false
        emailTF.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        logInButton.addTarget(self, action: #selector(handlerLogIn), for: .touchUpInside)
        passwordTF.isSecureTextEntry = true
    }
    
    func ConfigureStackView(){
        let stackView           = UIStackView(arrangedSubviews: [emailTF, passwordTF, logInButton])
        stackView.axis          = .vertical
        stackView.distribution  = .fillEqually
        stackView.spacing       = 10
        view.addSubview(stackView)
        stackView.anchor(top: LogoContinerView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 170)
    }
    
    func ConfigureSignUp(){
        view.addSubview(SignUpButton)
        SignUpButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 30, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func ConfigureLogoContinerView(){
        view.addSubview(LogoContinerView)
        LogoContinerView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.width, height: 200)
    }
}
