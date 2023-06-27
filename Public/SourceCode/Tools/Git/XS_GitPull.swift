//
//  XS_GitPull.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import Foundation

extension XS_Git {
    func pull(_ repo: GTRepository, branch: GTBranch, remote: GTRemote, provider: GTCredentialProvider? = nil, progress: @escaping (git_transfer_progress) -> Void) throws {
        var options: [AnyHashable:Any] = [
            GTRepositoryRemoteOptionsFetchPrune : GTFetchPruneOption.yes,
            GTRepositoryRemoteOptionsDownloadTags : GTRemoteDownloadTagsAll
        ]
        if let provider = provider {
            options[GTRepositoryRemoteOptionsCredentialProvider] = provider
        }
        let pullBranch: GTBranch
        if branch.branchType == .local {
            pullBranch = branch
        } else {
            let currentBranch = try repo.currentBranch()
            try currentBranch.updateTrackingBranch(branch)
            pullBranch = currentBranch
        }
        try repo.pull(pullBranch, from: remote, withOptions: options) { pro, stop in
            progress(pro.pointee)
        }
    }
}
