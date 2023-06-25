//
//  XS_GitCommit.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import Foundation

extension GTRepository {
    func commitAll() throws {
        let index = try index()
        try index.addAll()
        let tree = try index.writeTree()
        
        let commit = try currentBranch().targetCommit()
        let diff = try GTDiff(oldTree: commit.parents[0].tree, withNewTree: commit.tree, in: self)
        diff.numberOfDeltas(with: .added)
        diff.enumerateDeltas { delta, isStop in
            print(delta.type.rawValue)
        }
    }
}

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
