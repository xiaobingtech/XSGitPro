//
//  XS_GitClone.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/8.
//

import Foundation
import ComposableArchitecture

extension XS_Git {
    func clone(_ urlPath: String, progress: @escaping (git_transfer_progress) -> Void) -> GTRepository? {
        guard let url = URL(string: urlPath), let localURL = URL.localURL(url.fileName) else {
            DispatchQueue.main.async {
                ViewStore(maskStore.scopeToast)
                    .send(.showToast(msg: "链接错误!"))
            }
            return nil
        }
        if FileManager.default.fileExists(atPath: localURL.relativePath) {
            DispatchQueue.main.async {
                ViewStore(maskStore.scopeToast)
                    .send(.showToast(msg: "文件目录重名!"))
            }
            return nil
        }
        do {
            _repo = try GTRepository.clone(from: url, toWorkingDirectory: localURL) { pro, stop in
                progress(pro.pointee)
            }
            return _repo
        } catch {
            debugPrint(error)
            DispatchQueue.main.async {
                ViewStore(maskStore.scopeToast)
                    .send(.showToast(msg: "克隆失败!"))
            }
            return nil
        }
    }
}
