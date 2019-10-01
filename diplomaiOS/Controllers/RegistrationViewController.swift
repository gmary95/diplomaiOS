//
//  ViewController.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 9/8/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func authorizationAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthorizationNavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        let resultController = vc.topViewController as! ResultAuthorizationViewController
        resultController.isSuccess = false
        self.present(vc, animated: true, completion: nil)
    }
    
}

