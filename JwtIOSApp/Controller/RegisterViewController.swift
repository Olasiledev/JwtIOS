//
//  RegisterViewController.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile & Ripudaman Singh on 2024-04-04.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        guard let firstName = firstNameField.text, !firstName.isEmpty,
              let lastName = lastNameField.text, !lastName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            
            displayAlert(title: "Error", message: "Please fill in all fields.", completion: nil)
            return
        }
        
        // Creating user
        UserManager.createUser(firstName: firstName, lastName: lastName, email: email, password: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.displayAlert(title: "Success", message: "Account created successfully.") {
                        self.showLoginVC()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.displayAlert(title: "Error", message: "Failed to create account: \(error.localizedDescription)", completion: nil)
                }
            }
        }
    }
    
    @IBAction func backToLogin(_ sender: UIButton) {
        showLoginVC()
    }
    
    func showLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - ALERT
    func displayAlert(title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
