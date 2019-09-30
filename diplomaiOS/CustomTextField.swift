//
//  CustomTextField.swift
//  diplomaiOS
//
//  Created by GM on 9/30/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    open override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
    }
}
