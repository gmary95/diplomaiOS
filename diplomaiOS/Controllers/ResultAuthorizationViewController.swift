//
//  ResultAuthorizationViewController.swift
//  diplomaiOS
//
//  Created by GM on 10/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import UIKit

class ResultAuthorizationViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultMessageLabel: UILabel!
    
    var isSuccess = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isSuccess {
            imageView.image = UIImage(named: "ic_failed")
            resultMessageLabel.text = "Your authorization is failed!"
            resultMessageLabel.textColor = .red
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
