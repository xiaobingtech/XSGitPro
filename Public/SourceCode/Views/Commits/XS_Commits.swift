//
//  XS_Commits.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/17.
//

import Foundation
import ComposableArchitecture

extension XS_Commits.State {
    var commits: [GTCommit] {
        do {
            let branch = try repo.currentBranch()
            let commit = try branch.targetCommit()
            return getCommits(commit)
        } catch {
            debugPrint(error.localizedDescription)
            return []
        }
    }
    private func getCommits(_ commit: GTCommit) -> [GTCommit] {
        var all = [commit]
        insertCommits(&all, parents: commit.parents)
        return all
    }
    private func insertCommits(_ all: inout [GTCommit], parents: [GTCommit]) {
        switch parents.count {
        case 0: break
        case 1:
            let commit = parents[0]
            all.append(commit)
            insertCommits(&all, parents: commit.parents)
        default:
            var parents = parents.sorted { $0.commitDate >= $1.commitDate }
            let commit = parents.removeFirst()
            all.append(commit)
            parents += commit.parents
            let new = parents.reduce(into: [GTCommit]()) { result, element in
                if !result.contains(where: { $0.sha == element.sha }) {
                    result.append(element)
                }
            }
            insertCommits(&all, parents: new)
        }
    }
}

extension GTCommit {
    var dateStr: String {
        let cale = Calendar.current
        let fm = DateFormatter()
        if cale.compare(commitDate, to: Date(), toGranularity: .year) == .orderedSame {
            fm.dateFormat = "MM.dd"
        } else {
            fm.dateFormat = "yyyy.MM.dd"
        }
        return fm.string(from: commitDate)
    }
}

struct XS_Commits: Reducer {
    struct State: Equatable {
        let repo: GTRepository
    }
    enum Action {
    }
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
    }
}
