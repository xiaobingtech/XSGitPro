//
//  XS_GitFile.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation

extension XS_Git {
    func files(_ repo: GTRepository) -> [String:XS_GitFolder] {
        do {
            let index = try repo.index()
            var dic: [String:XS_GitFolder] = [:]
            for entry in index.entries {
                let path = entry.path.components(separatedBy: "/")
                for index in 0..<path.count {
                    let name = path[index]
                    let key = path.prefix(index).joined(separator: "/")
                    if dic[key] == nil { dic[key] = XS_GitFolder() }
                    if index == path.count-1 {
                        dic[key]?.addFile(key, name: name, entry: entry)
                    } else {
                        dic[key]?.addFolder(key, name: name)
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

struct XS_GitFolder: Equatable, Hashable {
    var folders: [XS_GitFile] = []
    var files: [XS_GitFile] = []
    
    var list: [XS_GitFile] { folders + files }
    var count: Int { folders.count + files.count }
    
    private func add(_ array: inout [XS_GitFile], key: String, name: String, entry: GTIndexEntry? = nil) {
        let id = key.isEmpty ? name : key + "/" + name
        if array.contains(where: { $0.id == id }) { return }
        array.append(.init(id: id, name: name, entry: entry))
    }
    mutating func addFolder(_ key: String, name: String) {
        add(&folders, key: key, name: name)
    }
    mutating func addFile(_ key: String, name: String, entry: GTIndexEntry) {
        add(&files, key: key, name: name, entry: entry)
    }
}

struct XS_GitFile: Equatable, Identifiable, Hashable {
    let id: String
    let name: String
    let entry: GTIndexEntry?
}
