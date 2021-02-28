//
//  ViewController.swift
//  Lesson8
//
//  Created by Артём Сарана on 07.02.2021.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    @IBAction func logout(_ segue: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
        } catch {
            self.show(error: error)
        }
    }
    
    @IBAction func logInAction(_ sender: UIButton) {
        guard
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text
        else {
            let error = AppError.loginError(message: "Login/password is incorrect")
            self.show(error: error)
            return
        }
        
        Auth.auth().signIn(withEmail: email,
                           password: password) { [weak self] (res, err) in
            guard let self = self else { return }
//            self.signIn(error: err)
            if let error = err {
                self.show(error: error)
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Register",
                                        message: "Enter your email and password",
                                        preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "Enter your email"
        }
        alertVC.addTextField { textField in
            textField.placeholder = "Enter your password"
            textField.isSecureTextEntry = true
            textField.textContentType = .password
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard
                let email = alertVC.textFields?[0].text,
                let password = alertVC.textFields?[1].text,
                !email.isEmpty,
                !password.isEmpty
            else {
                let error = AppError.loginError(message: "Login/password is incorrect")
                self.show(error: error)
                return
            }
            
            Auth.auth().createUser(withEmail: email,
                                   password: password) { [weak self] (res, err) in
                guard let self = self else { return }
                if let error = err {
                    self.show(error: error)
                } else {
                    Auth.auth().signIn(withEmail: email,
                                       password: password) { [weak self] (res, err) in
                        guard let self = self else { return }
//                        self.signIn(error: err)
                        if let error = err {
                            self.show(error: error)
                        }
                    }
                }
            }
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveAction)
        present(alertVC, animated: true)
    }
    
//    func signIn(error: Error? = nil) {
//        if let error = error {
//            self.show(error: error)
//        } else {
//            self.performSegue(withIdentifier: "loginSuccees", sender: nil)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGesture)
        
        handle = Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            guard let self = self else { return }
            if user != nil {
                self.performSegue(withIdentifier: "loginSuccees", sender: nil)
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
}

