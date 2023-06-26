//
//  XS_GitPush.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/26.
//

import Foundation

extension XS_Git {
    func push(_ repo: GTRepository, branch: GTBranch? = nil, remote: GTRemote, provider: GTCredentialProvider? = nil, progress: @escaping (_ current: UInt32, _ total: UInt32, _ size: Int) -> Void) throws {
        var options: [AnyHashable:Any] = [
            GTRepositoryRemoteOptionsPushNotes : NSNumber(booleanLiteral: true)
        ]
        if let provider = provider {
            options = [GTRepositoryRemoteOptionsCredentialProvider : provider]
        }
        let currentBranch = try repo.currentBranch()
        if let branch = branch {
            try currentBranch.updateTrackingBranch(branch)
        }
        try repo.push(currentBranch, to: remote, withOptions: options) { current, total, size, stop in
            progress(current, total, size)
        }
    }
}
