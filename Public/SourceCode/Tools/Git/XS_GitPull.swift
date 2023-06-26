//
//  XS_GitPull.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import Foundation

extension GTRepository {
    func pull123() throws {
        let current = try currentBranch()
        let remoteBranch = try lookUpBranch(withName: "origin/main", type: .remote, success: nil)
        try current.updateTrackingBranch(remoteBranch)
        
        let provider = GTCredentialProvider { _,_,_ in
            try? GTCredential(userName: "hanyzjob@163.com", password: "")
        }
        
        let remotes = try configuration().remotes
        
        let set = try pull(current, from: remotes!.first!, progress: { progress, stop in
            debugPrint("\(progress.pointee.received_objects)/\(progress.pointee.total_objects)")
        })
        print(set)
        
        
//        let remote = try GTRemote(name: remoteBranch.remoteName ?? "_", in: remoteBranch.repository)
//        let pr = GTCredentialProvider { _,_,_  in nil }
//        let fe = GTFetchPruneOption.yes
//        let ta = GTRemoteDownloadTagsAll
//
//
//        try pull(remoteBranch, from: remote, withOptions: [GTRepositoryRemoteOptionsCredentialProvider : pr, GTRepositoryRemoteOptionsFetchPrune : fe, GTRepositoryRemoteOptionsDownloadTags: ta])
//
        ///`GTRepositoryRemoteOptionsCredentialProvider`
        ///`GTRepositoryRemoteOptionsFetchPrune`
        ///`GTRepositoryRemoteOptionsDownloadTags`
    }
}

extension XS_Git {
    func pull(_ repo: GTRepository, branch: GTBranch, remote: GTRemote, provider: GTCredentialProvider? = nil, progress: @escaping (git_transfer_progress) -> Void) throws{
        var options: [AnyHashable:Any]?
        if let provider = provider {
            options = [GTRepositoryRemoteOptionsCredentialProvider : provider]
        }
        try repo.pull(branch, from: remote, withOptions: options) { pro, stop in
            progress(pro.pointee)
        }
    }
}
