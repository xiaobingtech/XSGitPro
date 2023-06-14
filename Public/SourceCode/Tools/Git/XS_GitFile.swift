//
//  XS_GitFile.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation

extension XS_Git {
    func files(_ repo: GTRepository) -> [String:[XS_GitFile]] {
        do {
            let index = try repo.index()
            var dic: [String:[XS_GitFile]] = [:]
            for entry in index.entries {
                let path = entry.path.components(separatedBy: "/")
                for index in 0..<path.count {
                    let name = path[index]
                    let key = path.prefix(index).joined(separator: "/")
                    if dic[key] == nil { dic[key] = [] }
                    let id = key.isEmpty ? name : key + "/" + name
                    if !dic[key]!.contains(where: { $0.id == id }) {
                        dic[key]?.append(XS_GitFile(id: id, name: name, entry: index == path.count-1 ? entry : nil))
                    }
                }
            }
            return dic
        } catch {
            debugPrint(error)
            return [:]
        }
    }
}

struct XS_GitFile: Equatable, Identifiable, Hashable {
    let id: String
    let name: String
    let entry: GTIndexEntry?
}
