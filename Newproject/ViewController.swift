//
//  ViewController.swift
//  Newproject
//
//  Created by Yulya on 23.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let button = UIButton()
    let button1 = UIButton()
    let username = UITextField()
    let password = UITextField()
    
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUpLayoutOfTextField()
        setUpLayoutOfButton()
    }
    
    
    func setUpLayoutOfTextField() {
        self.view.addSubview(self.username)
        self.username.translatesAutoresizingMaskIntoConstraints = false
        self.username.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 180).isActive = true
        self.username.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        self.username.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        self.username.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.username.layer.cornerRadius = 20
        self.username.backgroundColor = .systemMint
        self.username.placeholder = "Username"
        
        
        self.view.addSubview(self.password)
        self.password.translatesAutoresizingMaskIntoConstraints = false
        self.password.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 20).isActive = true
        self.password.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        self.password.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        self.password.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.password.layer.cornerRadius = 20
        self.password.backgroundColor = .systemMint
        self.password.placeholder = "Password"
        self.password.textColor = #colorLiteral(red: 0.5931178927, green: 0.0217062626, blue: 0.07970813662, alpha: 1)
    }
    
    
    func setUpLayoutOfButton() {
        self.button.addTarget(self, action: #selector(loginButton), for: .touchUpInside)
        self.view.addSubview(self.button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 60).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 220).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.button.layer.cornerRadius = 20
        self.button.backgroundColor = .systemMint
        self.button.setTitle("Login", for: .normal)
        
        self.button1.addTarget(self, action: #selector(registerButton), for: .touchUpInside)
        self.view.addSubview(self.button1)
        self.button1.translatesAutoresizingMaskIntoConstraints = false
        self.button1.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 60).isActive = true
        self.button1.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        self.button1.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -220).isActive = true
        self.button1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.button1.layer.cornerRadius = 20
        self.button1.backgroundColor = .systemMint
        self.button1.setTitle("Register", for: .normal)
    }
    
    
    @objc func registerButton() {
        
        var params: [String: String] = [:]
        
        params["username"] = self.username.text
        params["password"] = self.password.text
        
        NetworkManager.networkItem.register(param: params) { authToken in
            if let error = authToken.error {
                let vc = UIAlertController(title: "error", message: error, preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "ok", style: .cancel))
                DispatchQueue.main.async {
                    self.present(vc, animated: true)
                }
            } else if let token = authToken.result {
                self.token = token
                UserDefaults.standard.set(token, forKey: "token")
                debugPrint(token)
            }
            DispatchQueue.main.async {
                let vc = MainViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            //            NetworkManager.networkItem.setToken(authToken)
        }
    }
    //        let username = username.text
    //        UserDefaults.standard.set(username, forKey: "name")
    //
    //        let password = password.text
    //        UserDefaults.standard.set(password, forKey: "password")
    //
    //        if let name = UserDefaults.standard.string(forKey: "password") {
    //            print(name)
    
    
    @objc func loginButton() {
        var params: [String: Any] = [:]
        
        params["username"] = self.username.text
        params["password"] = self.password.text
        
        NetworkManager.networkItem.login(param: params) { authToken in
            if let error = authToken.error {
                let vc = UIAlertController(title: "error", message: error, preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "ok", style: .cancel))
                DispatchQueue.main.async {
                    self.present(vc, animated: true)
                }
            } else if let token = authToken.result {
                self.token = token
                UserDefaults.standard.set(token, forKey: "token")
                debugPrint(token)
            }
            DispatchQueue.main.async {
                let vc = MainViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
