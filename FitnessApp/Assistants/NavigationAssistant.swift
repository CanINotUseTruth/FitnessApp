//
//  NavigationAssitant.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 24/5/2023.
//

import Foundation
import UIKit

class NavigationAssistant:UIViewController {
    
    func moveToViewNoBack(viewController: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let nextViewController = storyboard.instantiateViewController(identifier: viewController);
        nextViewController.navigationItem.hidesBackButton = true;
        return nextViewController;
    }
    
}
