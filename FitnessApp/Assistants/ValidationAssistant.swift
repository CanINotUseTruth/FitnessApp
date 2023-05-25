//
//  ValidationAssistant.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 25/5/2023.
//

import Foundation
import UIKit

class ValidationAssistant {
    let errorHandlingAssistant = ErrorHandlingAssistant();
        
    // Login Specific validation rules
    func loginValidation(emailTextField: UITextField, passwordTextField: UITextField) -> UIAlertController {
        let alert = mutualValidation(emailTextField: emailTextField, passwordTextField: passwordTextField);
        if(alert.title != "No Error") { return alert };
        
        // Returned if there is no error and checked in Controller if needed to display.
        return UIAlertController(title: "No Error", message: "No Error", preferredStyle: .alert);
    }
    
    //Signup Specific validation rules
    func signUpValidation(emailTextField: UITextField, passwordTextField: UITextField, confirmPasswordTextField: UITextField) -> UIAlertController {
        let alert = mutualValidation(emailTextField: emailTextField, passwordTextField: passwordTextField);
        if(alert.title != "No Error") { return alert };
        
        // Checks formatting of password meets requirements
        if(!passwordCorrectFormat(passwordText: passwordTextField.text!)) {
            return errorHandlingAssistant.defineAlert(alertTitle: "Invalid Password", alertMessage: "Password does not meet minimum requirements!");
        }
        
        // Password and confirmation match
        if(!passwordConfirmMatch(passwordText: passwordTextField.text!, confirmationText: confirmPasswordTextField.text!)) {
            return errorHandlingAssistant.defineAlert(alertTitle: "Passwords Don't Match", alertMessage: "The password and confirmation must match!");
        }
        
        // Returned if there is no error and checked in Controller if needed to display.
        return UIAlertController(title: "No Error", message: "No Error", preferredStyle: .alert);
    }
    
    // Validation rules that are shared between Signup and Login
    func mutualValidation(emailTextField: UITextField, passwordTextField: UITextField) -> UIAlertController {
        guard emailTextField.hasText else {
            return errorHandlingAssistant.defineAlert(alertTitle: "Missing Email", alertMessage: "Please enter an email address!");
        }
        
        // Returned if there is no error and checked in specific function if needed to return.
        return UIAlertController(title: "No Error", message: "No Error", preferredStyle: .alert);
    }
    
    // Checks formatting of password meets requirements
    func passwordCorrectFormat(passwordText: String) -> Bool {
        var formatted:Bool = true;
        // Check each requirement and update the formatted boolean
        if(!passwordContainsSymbol(passwordText: passwordText)) { formatted = false };
        if(!passwordContainsUppercase(passwordText: passwordText)) { formatted = false };
        if(!passwordContainsLowercase(passwordText: passwordText)) { formatted = false };
        if(!passwordContainsNumber(passwordText: passwordText)) { formatted = false };
        return formatted;
    }
    
    func passwordContainsSymbol(passwordText: String) -> Bool {
        let fullCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
        return passwordText.rangeOfCharacter(from: fullCharacterSet.inverted) != nil;
    }
    
    func passwordContainsUppercase(passwordText: String) -> Bool {
        let uppercaseCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
        return passwordText.rangeOfCharacter(from: uppercaseCharacterSet) != nil;
    }
    
    func passwordContainsLowercase(passwordText: String) -> Bool {
        let lowercaseCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz");
        return passwordText.rangeOfCharacter(from: lowercaseCharacterSet) != nil;
    }
    
    func passwordContainsNumber(passwordText: String) -> Bool {
        let numericCharacterSet = CharacterSet(charactersIn: "0123456789");
        return passwordText.rangeOfCharacter(from: numericCharacterSet) != nil;
    }
    
    func passwordConfirmMatch(passwordText: String, confirmationText: String) -> Bool {
        if(passwordText == "" || confirmationText == "") { return false }
        return passwordText == confirmationText;
    }
    
    func checkPasswordLength(passwordText: String) -> Bool {
        return passwordText.utf16.count >= 8;
    }
    
}
