//
//  ErrorHandlingAssistant.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 25/5/2023.
//

import Foundation
import UIKit

class ErrorHandlingAssistant {
    
    // Handles Firebase error codes
    func displayError(error: NSError?) -> UIAlertController {
        var alert: UIAlertController;
        switch error!.code {
        case 17007:
            alert = defineAlert(alertTitle: "User Already Exists", alertMessage: "A user with this email address already exists!");
            break;
        case 17008:
            alert = defineAlert(alertTitle: "Invalid Email", alertMessage: "Invalid email entered!");
            break;
        case 17009:
            alert = defineAlert(alertTitle: "Missing Password", alertMessage: "Please enter a password!");
            break;
        case 17011:
            alert = defineAlert(alertTitle: "Invalid User", alertMessage: "No user record found, please check email and password!");
            break;
        default:
            alert = defineAlert(alertTitle: "Default Error", alertMessage: "Error Occured!");
            print("Error code:", error!.code, "Error:", error!.localizedDescription);
            break;
        }
        return alert;
    }
    
    // Creates alerts directly for use in local validation and Firebase errors
    func defineAlert(alertTitle: String, alertMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Dismiss Alert Action"), style: .default, handler: { _ in
        NSLog("The alert has been dismissed.")
        }));
        return alert;
    }
}
