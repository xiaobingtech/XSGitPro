//
//  XS_GitDirectory.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import Foundation

extension URL {
    var fileName: String {
        var name = lastPathComponent
        let ext = pathExtension
        if !ext.isEmpty {
            name.removeLast(ext.count + 1)
        }
        return name
    }
    static var clonesDir: URL? {
        #if DEBUG
        let fm = FileManager.default
        let url = URL(fileURLWithPath: "/Users/hanyz/Desktop/DEMO/Git/GitClones/")
        if fm.fileExists(atPath: url.relativePath) {
            return url
        } else {
            return fm
                .urls(for: .documentDirectory, in: .userDomainMask)
                .last
        }
        #else
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .last
        #endif
    }
    static func localURL(_ name: String) -> URL? {
        clonesDir?.appending(component: name, directoryHint: .isDirectory)
    }
}

extension XS_Git {
    var directorys: [XS_GitDirectory] {
        let fileManager = FileManager.default
        guard let clonesDir = URL.clonesDir else { return [] }
        do {
            let array = try fileManager.contentsOfDirectory(atPath: clonesDir.relativePath)
            return array.compactMap { fileName in
                let folderURL = clonesDir.appendingPathComponent(fileName, isDirectory: true)
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                    debugPrint("文件夹: \(fileName)")
                    do {
                        let repo = try GTRepository(url: folderURL)
                        return XS_GitDirectory(
                            fileName: fileName,
                            localURL: folderURL,
                            repo: repo
                        )
                    } catch {
                        debugPrint(error)
                        return nil
                    }
                } else {
                    return nil
                }
            }
        } catch {
            debugPrint(error)
            return []
        }
    }
}

struct XS_GitDirectory: Equatable, Identifiable, Hashable {
    var id: String { fileName }
    let fileName: String
    let localURL: URL
    let repo: GTRepository
    var branchName: String? {
        do {
            let branch = try repo.currentBranch()
            return branch.name
        } catch {
            debugPrint(error)
            return nil
        }
    }
    var entries: [GTIndexEntry] {
        do {
            return try repo.index().entries
        } catch {
            debugPrint(error)
            return []
        }
    }
}
