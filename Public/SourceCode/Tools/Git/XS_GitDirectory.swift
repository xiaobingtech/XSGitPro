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
        URL(fileURLWithPath: "/Users/hanyz/Desktop/GitDemo")
            .appendingPathComponent("GitClones", conformingTo: .directory)
        #else
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .last?
            .appending(component: "GitClones", directoryHint: .isDirectory)
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
                        return XS_GitDirectory(
                            fileName: fileName,
                            localURL: folderURL
                        )
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
    var repo: GTRepository?
}
