//
//  XS_GitFile.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation

extension XS_Git {
    func files(_ repo: GTRepository?) -> [XS_GitFile] {
        guard let repo = repo else { return [] }
        do {
            let index = try repo.index()
            return index.entries.compactMap {
                XS_GitFile(
                    path: $0.path.components(separatedBy: "/"),
                    entry: $0
                )
            }
        } catch {
            debugPrint(error)
            return []
        }
    }
    func files(_ items: [XS_GitFile], title: String, index: Int) -> [XS_GitFile] {
        items.filter {
            if $0.path.count > index {
                if title.isEmpty || $0.path[index - 1] == title {
                    return true
                }
            }
            return false
        }
    }
}

struct XS_GitFile: Equatable, Identifiable, Hashable {
    var id: String { entry.path }
    var path: [String]
    var entry: GTIndexEntry
}
