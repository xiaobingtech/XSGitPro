//
//  String.swift
//  XSGitPro
//
//  Created by 范小兵 on 2023/8/21.
//

import Foundation

extension String {
    /// 国际化
    var i18n: String {
        NSLocalizedString(self, comment: "")
    }
}
