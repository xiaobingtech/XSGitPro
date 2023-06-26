//
//  XS_GitCommit.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import Foundation

extension XS_Git {
    func addAll(_ repo: GTRepository) throws -> GTDiff {
        let index = try repo.index()
        try index.addAll()
        let branch = try repo.currentBranch()
        let commit = try branch.targetCommit()
        return try GTDiff(indexFrom: commit.tree, in: repo)
    }
    @discardableResult
    func commit(_ repo: GTRepository, message: String) throws -> GTCommit {
        let branch = try repo.currentBranch()
        let last = try branch.targetCommit()
        let index = try repo.index()
        try index.write()
        let tree = try index.writeTree()
        return try repo.createCommit(
            with: tree,
            message: message,
            parents: [last],
            updatingReferenceNamed: branch.reference.name
        )
    }
}
