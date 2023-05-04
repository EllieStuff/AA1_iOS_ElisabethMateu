//
//  View.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 4/5/23.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
