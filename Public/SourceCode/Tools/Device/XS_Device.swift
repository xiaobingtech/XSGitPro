//
//  XS_Device.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/8/11.
//

import UIKit

extension UIDevice {
    static var isPad: Bool {
        current.userInterfaceIdiom == .pad
    }
}
