//
//  LoginViewController.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 24/5/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    let navigationAssistant = NavigationAssistant();
    let errorHandlingAssistant = ErrorHandlingAssistant();
    let validationAssistant = ValidationAssistant();

    @IBOutlet weak var LoginEmailTextField: UITextField!;
    @IBOutlet weak var LoginPasswordTextField: UITextField!;
    @IBOutlet weak var LoginButton: UIButton!;
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }
    
    func login() {
        let validationError = validationAssistant.loginValidation(emailTextField: LoginEmailTextField, passwordTextField: LoginPasswordTextField);
        
        if(validationError.title != "No Error") {
            self.present(validationError, animated: true, completion: nil);
            return;
        }
        
        Task {
            do {
                // Pass user to RootViewController
                let returnedUser = try await AuthenticationManager.shared.getUser(email: LoginEmailTextField.text!, password: LoginPasswordTextField.text!);
                show(navigationAssistant.moveToViewNoBack(viewController: "RootViewController"), sender: self);
            } catch {
                // Create helper class for Authentication Error handling
                let error = error as NSError?;
                let alert = errorHandlingAssistant.displayError(error: error);
                self.present(alert, animated: true, completion: nil);
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
