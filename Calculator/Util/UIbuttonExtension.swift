//
//  UIbuttonExtension.swift
//  Calculator
//
//  Created by Marina Andrés Aragón on 7/3/23.
//

import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton {
    
    //BORDE REDONDO
    func round() {
        layer.cornerRadius = bounds.height/2
        clipsToBounds = true
    }
    //Brillo
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) {(completion) in
            UIView.animate(withDuration: 0.1,  animations: {
                self.alpha = 1
            })
        }
    }
    func selectedOperation(_ selected: Bool) {
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal)
    }
}

