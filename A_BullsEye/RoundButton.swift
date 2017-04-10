//
//  RoundButton.swift
//  A_BullsEye
//
//  Created by Kam Lotfull on 10.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
