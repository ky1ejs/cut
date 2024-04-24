//
//  UIViewExtensions.swift
//  Cut
//
//  Created by Kyle Satti on 4/20/24.
//

import UIKit

extension UIView {
    func disableAutoresizing() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
