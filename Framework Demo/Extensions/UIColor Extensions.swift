//
//  UIColor Extensions.swift
//  Framework Demo
//
//  Created by James Coleman on 01/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
    convenience init(_ rgb: Int, a: CGFloat = 1.0) {
        let red = (rgb >> 16) & 0xFF
        let green = (rgb >> 8) & 0xFF
        let blue = rgb & 0xFF
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        let floatRed = CGFloat(red)
        let floatGreen = CGFloat(green)
        let floatBlue = CGFloat(blue)
        
        self.init(
            red: floatRed / 255,
            green: floatGreen / 255,
            blue: floatBlue / 255,
            alpha: a
        )
    }
}
