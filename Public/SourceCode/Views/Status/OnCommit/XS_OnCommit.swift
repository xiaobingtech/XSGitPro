//
//  XS_OnCommit.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == String, ViewAction == XS_OnCommit.Action {
    var binding: Binding<ViewState> {
        binding(send: ViewAction.setText)
    }
}

extension XS_OnCommit.State {
    var files: [GTDiffDelta] {
        []
    }
}

struct XS_OnCommit: ReducerProtocol {
    struct State: Equatable {
        let repo: GTRepository
        let deltas: [GTDiffDelta]
        let isError: Bool
        let str: String
        var text: String = ""
        init(repo: GTRepository) {
            self.repo = repo
            do {
                let diff = try XS_Git.shared.addAll(repo)
                var arr: [GTDiffDelta] = []
                var conflicted: [GTDiffDelta] = []
                diff.enumerateDeltas { delta, stop in
                    switch delta.type {
                    case .unmodified, .ignored:
                        break
                    case .conflicted:
                        conflicted.append(delta)
                    default:
                        arr.append(delta)
                    }
                }
                if conflicted.isEmpty {
                    deltas = arr
                    isError = false
                    str = "\(deltas.count)"
                } else {
                    deltas = conflicted + arr
                    isError = true
                    str = "冲突文件 \(conflicted.count) 个"
                }
            } catch {
                debugPrint(error.localizedDescription)
                isError = true
                str = "未知错误"
                deltas = []
            }
        }
    }
    enum Action {
        case onCancel
        case onCommit
        case delegate(Delegate)
        enum Delegate {
            case commit
        }
        case setText(String)
    }
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onCancel:
            return .run { send in
                await self.dismiss()
            }
        case .onCommit:
            return .run { [repo = state.repo, message = state.text] send in
                do {
                    try XS_Git.shared.commit(repo, message: message)
                    await self.dismiss()
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        case .delegate:
            return .none
        case let .setText(value):
            state.text = value
            return .none
        }
    }
}
