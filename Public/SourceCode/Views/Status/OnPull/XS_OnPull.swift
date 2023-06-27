//
//  XS_OnPull.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == String, ViewAction == XS_OnPull.Action {
    var bindingUsername: Binding<String> {
        binding(send: ViewAction.setUsername)
    }
    var bindingPassword: Binding<String> {
        binding(send: ViewAction.setPassword)
    }
}

extension XS_OnPull.State {
    var remoteNames: [String] {
        do {
            return try repo.remoteNames()
        } catch {
            debugPrint(error.localizedDescription)
            return []
        }
    }
    var currentBranchs: [GTBranch] {
        remoteBranchs.filter { $0.remoteName == remote?.name }
    }
    var remoteBranchs: [GTBranch] {
        do {
            return try repo.remoteBranches()
        } catch {
            debugPrint(error.localizedDescription)
            return []
        }
    }
    var disabled: Bool {
        remote == nil || branch == nil
    }
}

struct XS_OnPull: ReducerProtocol {
    struct State: Equatable {
        let repo: GTRepository
        var remote: GTRemote?
        var branch: GTBranch?
        var username: String = ""
        var password: String = ""
        var showType: ShowType = .default
        enum ShowType: Equatable {
            case `default`
            case wait
            case pull(String, String)
            case error(String)
        }
        init(repo: GTRepository) {
            self.repo = repo
            do {
                let branch = try repo.currentBranch()
                if let remoteBranch = branch.trackingBranchWithError(NSErrorPointer(nilLiteral: ()), success: nil), let remoteName = remoteBranch.remoteName {
                    self.remote = try GTRemote(name: remoteName, in: repo)
                    self.branch = remoteBranch
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    enum Action {
        case onCancel
        case onPull
        case delegate(Delegate)
        enum Delegate {
            case pull
        }
        case setRemote(String)
        case setBranch(GTBranch)
        case setUsername(String)
        case setPassword(String)
        case setShowType(State.ShowType)
    }
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onCancel:
            return .run { send in
                await self.dismiss()
            }
        case .onPull:
            guard let remote = state.remote, let branch = state.branch else { return .none }
            return .run { [repo = state.repo, username = state.username, password = state.password] send in
                await send(.setShowType(.wait))
                do {
                    var provider: GTCredentialProvider?
                    if !username.isEmpty, !password.isEmpty {
                        provider = GTCredentialProvider { type, url, name in
                            try? GTCredential(userName: username, password: password)
                        }
                    }
                    try XS_Git.shared.pull(repo, branch: branch, remote: remote, provider: provider) { pro in
                        let progess = String(format: "%.1f", Double(pro.received_objects)*100/Double(pro.total_objects))
                        var kb = Double(pro.received_bytes)/1024.0
                        let unit: String
                        if kb < 1024 {
                            unit = "KB"
                        } else if kb < 1048576 {
                            unit = "MB"
                            kb /= 1024.0
                        } else {
                            unit = "GB"
                            kb /= 1048576.0
                        }
                        let size = String(format: "%.2f ", kb) + unit
                        DispatchQueue.main.async {
                            send(.setShowType(.pull(progess, size)))
                        }
                    }
                    
                    await send(.delegate(.pull))
                    await self.dismiss()
                    await send(.setShowType(.default))
                } catch {
                    debugPrint(error.localizedDescription)
                    let err = error as NSError
                    if err.code == -1001 {
                        await send(.setShowType(.error(err.domain)))
                    } else if err.code == -16 {
                        await send(.setShowType(.error("需要授权!")))
                    } else {
                        await send(.setShowType(.error("Pull失败!")))
                    }
                }
            }
        case .delegate:
            return .none
        case let .setRemote(value):
            if value == state.remote?.name { return .none }
            do {
                let remote = try GTRemote(name: value, in: state.repo)
                let branches = try state.repo.remoteBranches()
                state.remote = remote
                state.branch = branches.first  { $0.remoteName == remote.name }
            } catch {
                debugPrint(error.localizedDescription)
                state.remote = nil
                state.branch = nil
            }
            return .none
        case let .setBranch(value):
            state.branch = value
            return .none
        case let .setUsername(value):
            state.username = value
            return .none
        case let .setPassword(value):
            state.password = value
            return .none
        case let .setShowType(value):
            state.showType = value
            return .none
        }
    }
}
