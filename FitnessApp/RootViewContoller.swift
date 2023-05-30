//
//  RootViewContoller.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 24/5/2023.
//

import UIKit

class RootViewController: UIViewController {
    
    let navigationAssistant = NavigationAssistant();

    @IBAction func LogOutButtonPressed(_ sender: UIButton) {
        try? AuthenticationManager.shared.signOut();
        show(navigationAssistant.moveToViewNoBack(viewController: "MainViewController"), sender: self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
