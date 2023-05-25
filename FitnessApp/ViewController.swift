//
//  ViewController.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 2/5/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let navigationAssistant = NavigationAssistant();

    @IBOutlet weak var FromLeftStackViewConstraint: NSLayoutConstraint!;
    @IBOutlet weak var FromRightStackViewConstraint: NSLayoutConstraint!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let authenticatedUser = try? AuthenticationManager.shared.getAuthenticatedUser();
        if(authenticatedUser != nil) {
            show(navigationAssistant.moveToViewNoBack(viewController: "RootViewController"), sender: self);
        }
    }
}
