//
//  XS_GitClone.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/8.
//

import Foundation
import ComposableArchitecture

extension XS_Git {
    @discardableResult
    func clone(_ urlPath: String, provider: GTCredentialProvider? = nil, progress: @escaping (git_transfer_progress) -> Void) throws -> GTRepository {
        guard let url = URL(string: urlPath), let localURL = URL.localURL(url.fileName) else {
            throw NSError(domain: "链接错误!", code: -1001)
        }
        if FileManager.default.fileExists(atPath: localURL.relativePath) {
            throw NSError(domain: "文件目录重名!", code: -1001)
        }
        var options: [AnyHashable : Any]?
        if let provider = provider {
            options = [GTRepositoryCloneOptionsCredentialProvider:provider]
        }
        return try GTRepository.clone(from: url, toWorkingDirectory: localURL, options: options) { pro, stop in
            progress(pro.pointee)
        }
    }
    
}
