//
//  XS_Git.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import Foundation

class XS_Git {
    static let shared = XS_Git()
    private init() {}
    
    var _repo: GTRepository?
}
