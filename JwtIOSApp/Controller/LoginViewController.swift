//
//  LoginViewController.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile & Ripudaman Singh on 2024-04-04.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: - LOGIN BUTTON
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        //CALLING LOGIN FUNCTION
        UserManager.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let loginResponse):
                print("Login successful.")
                DispatchQueue.main.async {
                    self.showSuccessAlert(firstName: loginResponse.user.firstName, lastName: loginResponse.user.lastName)
                }                   case .failure(let error):
                print("Login failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorAlert()
                }
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        showSingUpVC()
    }
    
    //NAVIGATE TO SIGN UP
    func showSingUpVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? RegisterViewController {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    //ALERT & NAVIGATE TO BOOKLISTVC
    func showSuccessAlert(firstName: String, lastName: String) {
        let welcomeMessage = "Welcome, \(firstName) \(lastName)!"
        let successAlert = UIAlertController(title: "Login Successful", message: welcomeMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let bookListViewController = storyboard.instantiateViewController(withIdentifier: "BookListViewController") as? BookListViewController {
                bookListViewController.modalPresentationStyle = .fullScreen
                self.present(bookListViewController, animated: true, completion: nil)
            }
        }
        successAlert.addAction(action)
        
        self.present(successAlert, animated: true, completion: nil)
    }
    

    func showErrorAlert() {
        let errorAlert = UIAlertController(title: "Login Failed", message: "User not found", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
}
