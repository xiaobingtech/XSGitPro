//
//  XS_Git.swift
//  XSTool_Git
//
//  Created by 韩云智 on 2023/1/4.
//

import Foundation

enum XS_GitErrorCode: Int {
    case invalid = 20001 //无效仓库
    case fileName = 20002 //文件夹已存在
}
extension NSError {
    static func xs_gitError(_ code: XS_GitErrorCode, domain: String = "") -> NSError {
        NSError(domain: domain, code: code.rawValue)
    }
}

class A {
    var git: XS_Git2!
    func branch() {
        do {
            git = try XS_Git2.repository(URL.localURL("Files")!)
//            try git.branch()
            try git.pull()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    func demo() {
        let gitUrl = URL(string: "https://github.com/VirtualLion/Flies.git")!
        do {
            let git = try XS_Git2.clone(gitUrl, fileName: "Files") { current, total in
                debugPrint("%d/%d", current, total)
            } finish: { result in
                switch result {
                case .success(_):
                    debugPrint("成功")
                case .failure(_):
                    debugPrint("报错")
                }
            }
        } catch {
            
        }
    }
    
    func auth() {
//        let auth = GTCredentialProvider { (type, url, username) -> GTCredential? in
//                        let cred = try? GTCredential(userName: username, publicKeyString: publicKey, privateKeyString: privateKey, passphrase: passphrase)
//                        return cred
//         }
//        var options = [String : Any]()
//        options[GTRepositoryCloneOptionsCredentialProvider] = auth
//        options[GTRepositoryRemoteOptionsCredentialProvider] = auth
//        //Then call fetch or clone using these options:
//        GTRepository.clone(from: url, toWorkingDirectory: path, options: options)
    }
    
    func test() {
        
        let url = URL(string: "https://github.com/yxh265/ExCodable.git")!
        
        let fileManager = FileManager.default
        let appDocsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last
        guard let localURL = URL(string: url.lastPathComponent, relativeTo: appDocsDir) else { return }
        debugPrint(localURL.path)
        
        do {
            let repo: GTRepository
            if fileManager.fileExists(atPath: localURL.path) {
                repo = try GTRepository(url: localURL)
            } else {
                repo = try GTRepository.clone(from: url, toWorkingDirectory: localURL, options: [GTRepositoryCloneOptionsTransportFlags : true], transferProgressBlock: { progress, stop in
                    debugPrint("%d/%d", progress.pointee.received_objects, progress.pointee.total_objects)
                })
            }
            
            let head = try repo.headReference()
            
            if let targetOID = head.targetOID {
                let commit = try repo.lookUpObject(by: targetOID) as! GTCommit
                debugPrint("Last commit message: \(commit.messageSummary)")
            }

        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
}

class XS_Git2: GTRepository {
    
    static func repository(_ localURL: URL) throws -> XS_Git2 {
        try XS_Git2(url: localURL)
    }
    
    static func clone(
        _ url: URL,
        fileName: String,
        progress: @escaping (_ current: Int, _ total: Int) -> Void,
        finish: @escaping (Result<Int, Error>) -> Void
    ) throws -> XS_Git2 {
        guard let localURL = URL.localURL(fileName) else { throw NSError() }
        if FileManager.default.fileExists(atPath: localURL.path) {
            throw NSError.xs_gitError(.fileName, domain: "文件夹已存在")
        }
        return try XS_Git2.clone(
            from: url,
            toWorkingDirectory: localURL,
            options: [GTRepositoryCloneOptionsTransportFlags : true]
        ) { pro, stop in
            if stop.pointee.boolValue {
                if pro.pointee.local_objects == pro.pointee.total_objects {
                    finish(.success(Int(pro.pointee.local_objects)))
                } else {
                    finish(.failure(NSError()))
                }
            } else {
                progress(Int(pro.pointee.received_objects), Int(pro.pointee.total_objects))
            }
        }
    }
    
    func branch() throws {
//        let current = try currentBranch()
//        print("\(current.name ?? ""): \(current.isHEAD)")
//
//        let branches = try remoteBranches()
//        let branch1 = branches[1]
//        let branch = try branch1.reloadedBranch()
////        try branch.updateTrackingBranch(branch1)
//        try checkoutReference(branch.reference, options: nil)
//
//
//        let currentBranch2 = try currentBranch()
//        print("\(currentBranch2.name ?? ""): \(currentBranch2.isHEAD)")
//        let head = try headReference()
//        if let targetOID = head.targetOID {
//            let commit = try lookUpObject(by: targetOID) as! GTCommit
//            debugPrint("Last commit message: \(commit.messageSummary)")
            
//            checkoutReference(lookUpBranch(withName: "orgin", type: .local, success: nil).reference, options: .init(strategy: .safe))
//            index().addAll()
//            let tree = try index().writeTree()
//            let new = try createCommit(with: tree, message: "11111", parents: nil, updatingReferenceNamed: nil)
//        }
        
        let branch = try currentBranch()
        let last = try branch.targetCommit()
        let index = try index()
        try index.addAll()
        try index.write()
        let tree = try index.writeTree()
        let new = try createCommit(
            with: tree,
            message: "2222",
            parents: [last],
            updatingReferenceNamed: branch.reference.name
        )
    }
    
    func commit() throws {
        let head = try headReference()
        if let targetOID = head.targetOID {
            let commit = try lookUpObject(by: targetOID) as! GTCommit
            
        }
        
    }
    
    static func push() {
    }
    
    func pull() throws {
        let current = try currentBranch()
        let remoteBranch = try lookUpBranch(withName: "origin/main", type: .remote, success: nil)
        try current.updateTrackingBranch(remoteBranch)
        
        let provider = GTCredentialProvider { _,_,_ in
            try? GTCredential(userName: "hanyzjob@163.com", password: "")
        }
        
        let remotes = try configuration().remotes
        
        let set = try pull(current, from: remotes!.first!, progress: { progress, stop in
            debugPrint("\(progress.pointee.received_objects)/\(progress.pointee.total_objects)")
        })
        print(set)
        
        
//        let remote = try GTRemote(name: remoteBranch.remoteName ?? "_", in: remoteBranch.repository)
//        let pr = GTCredentialProvider { _,_,_  in nil }
//        let fe = GTFetchPruneOption.yes
//        let ta = GTRemoteDownloadTagsAll
//
//
//        try pull(remoteBranch, from: remote, withOptions: [GTRepositoryRemoteOptionsCredentialProvider : pr, GTRepositoryRemoteOptionsFetchPrune : fe, GTRepositoryRemoteOptionsDownloadTags: ta])
//
        ///`GTRepositoryRemoteOptionsCredentialProvider`
        ///`GTRepositoryRemoteOptionsFetchPrune`
        ///`GTRepositoryRemoteOptionsDownloadTags`
    }
    
    func test() {
        
        let url = URL(string: "https://github.com/yxh265/ExCodable.git")!
        
        let fileManager = FileManager.default
        let appDocsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last
        guard let localURL = URL(string: url.lastPathComponent, relativeTo: appDocsDir) else { return }
        debugPrint(localURL.path)
        
        do {
            let repo: GTRepository
            if fileManager.fileExists(atPath: localURL.path) {
                repo = try GTRepository(url: localURL)
            } else {
                repo = try GTRepository.clone(from: url, toWorkingDirectory: localURL, options: [GTRepositoryCloneOptionsTransportFlags : true], transferProgressBlock: { progress, stop in
                    debugPrint("%d/%d", progress.pointee.received_objects, progress.pointee.total_objects)
                })
            }
            
            let head = try repo.headReference()
            
            if let targetOID = head.targetOID {
                let commit = try repo.lookUpObject(by: targetOID) as! GTCommit
                debugPrint("Last commit message: \(commit.messageSummary)")
            }

        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
}
