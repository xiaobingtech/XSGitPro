//
//  UIColor.swift
//  XSGitPro
//
//  Created by 范小兵 on 2023/7/26.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return light
            case .dark:
                return dark
            @unknown default:
                return light
            }
        }
    }
}

extension Color {
    // 再定义一个颜色
    static let defaultBackground = Color(light: .white, dark: .black)
    static let defaultText = Color(light: .black, dark: .white)
 
    init(light: Color, dark: Color) {
        self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}
