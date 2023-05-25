//
//  SignUpViewController.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 24/5/2023.
//

import UIKit
import FirebaseAuth

// TODO - Password format checker display, 8 chars, 1 symbol, 1 capital, 1 lowercase

class SignUpViewController: UIViewController {
    
    let navigationAssistant = NavigationAssistant();
    let errorHandlingAssistant = ErrorHandlingAssistant();
    let validationAssistant = ValidationAssistant();
    
    // User Interactable Outlets
    @IBOutlet weak var SignUpEmailTextField: UITextField!
    @IBOutlet weak var SignUpPasswordTextField: UITextField!
    @IBOutlet weak var SignUpConfirmPasswordTextField: UITextField!
    @IBOutlet weak var SignUpCompleteButton: UIButton!
    
    // Confirmation Labels
    @IBOutlet weak var LengthConfirmLabel: UILabel!
    @IBOutlet weak var UppercaseConfirmLabel: UILabel!
    @IBOutlet weak var LowercaseConfirmLabel: UILabel!
    @IBOutlet weak var NumberConfirmLabel: UILabel!
    @IBOutlet weak var SymbolConfirmLabel: UILabel!
    @IBOutlet weak var MatchConfirmLabel: UILabel!
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        signUp();
    }
    
    func signUp() {
        let validationError = validationAssistant.signUpValidation(emailTextField: SignUpEmailTextField, passwordTextField: SignUpPasswordTextField, confirmPasswordTextField: SignUpConfirmPasswordTextField);
        
        if(validationError.title != "No Error") {
            self.present(validationError, animated: true, completion: nil);
            return;
        }
        
        Task {
            do {
                // Pass user to RootViewController
                let returnedUser = try await AuthenticationManager.shared.createUser(email: SignUpEmailTextField.text!, password: SignUpPasswordTextField.text!);
                show(navigationAssistant.moveToViewNoBack(viewController: "RootViewController"), sender: self);
            } catch {
                let error = error as NSError?;
                let alert = errorHandlingAssistant.displayError(error: error);
                self.present(alert, animated: true, completion: nil);
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        SignUpPasswordTextField.addTarget(self, action: #selector(passwordFieldChanged(_:)), for: .editingChanged);
        SignUpConfirmPasswordTextField.addTarget(self, action: #selector(confirmFieldChanged(_:)), for: .editingChanged);
    }
    
    @objc private func passwordFieldChanged(_ textField: UITextField) {
        // Password length label updater
        if(validationAssistant.checkPasswordLength(passwordText: SignUpPasswordTextField.text!)) {
            LengthConfirmLabel.textColor = UIColor.green;
        } else {
            LengthConfirmLabel.textColor = UIColor.red;
        }
        
        // Uppercase label updater
        if(validationAssistant.passwordContainsUppercase(passwordText: SignUpPasswordTextField.text!)) {
            UppercaseConfirmLabel.textColor = UIColor.green;
        } else {
            UppercaseConfirmLabel.textColor = UIColor.red;
        }
        
        // Lowercase label updater
        if(validationAssistant.passwordContainsLowercase(passwordText: SignUpPasswordTextField.text!)) {
            LowercaseConfirmLabel.textColor = UIColor.green;
        } else {
            LowercaseConfirmLabel.textColor = UIColor.red;
        }
        
        // Number label updater
        if(validationAssistant.passwordContainsNumber(passwordText: SignUpPasswordTextField.text!)) {
            NumberConfirmLabel.textColor = UIColor.green;
        } else {
            NumberConfirmLabel.textColor = UIColor.red;
        }
        
        // Symbol label updater
        if(validationAssistant.passwordContainsSymbol(passwordText: SignUpPasswordTextField.text!)) {
            SymbolConfirmLabel.textColor = UIColor.green;
        } else {
            SymbolConfirmLabel.textColor = UIColor.red;
        }
        
        // Password match label updater
        if(validationAssistant.passwordConfirmMatch(passwordText: SignUpPasswordTextField.text!, confirmationText: SignUpConfirmPasswordTextField.text!)) {
            MatchConfirmLabel.textColor = UIColor.green;
        } else {
            MatchConfirmLabel.textColor = UIColor.red;
        }
    }
    
    @objc private func confirmFieldChanged(_ textField: UITextField) {
        // Password match label updater
        if(validationAssistant.passwordConfirmMatch(passwordText: SignUpPasswordTextField.text!, confirmationText: SignUpConfirmPasswordTextField.text!)) {
            MatchConfirmLabel.textColor = UIColor.green;
        } else {
            MatchConfirmLabel.textColor = UIColor.red;
        }
    }
}
