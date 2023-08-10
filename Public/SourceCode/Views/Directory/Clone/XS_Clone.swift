//
//  XS_Clone.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/8.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == String, ViewAction == XS_Clone.Action {
    var binding: Binding<String> {
        binding(send: ViewAction.setText)
    }
    var bindingUsername: Binding<String> {
        binding(send: ViewAction.setUsername)
    }
    var bindingPassword: Binding<String> {
        binding(send: ViewAction.setPassword)
    }
}

struct XS_Clone: Reducer {
    struct State: Equatable {
        var text: String = ""
        var username: String = ""
        var password: String = ""
        var showType: ShowType = .default
        enum ShowType: Equatable {
            case `default`
            case wait
            case clone(String, String)
            case error(String)
        }
    }
    enum Action {
        case onCancel
        case onClone
        case delegate(Delegate)
        enum Delegate {
            case clone
        }
        case setText(String)
        case setUsername(String)
        case setPassword(String)
        case setShowType(State.ShowType)
    }
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onCancel:
            return .run { send in
                await self.dismiss()
            }
        case .onClone:
            if state.text.isEmpty { return .none }
            return .run { [text = state.text, username = state.username, password = state.password] send in
                await send(.setShowType(.wait))
                do {
                    var provider: GTCredentialProvider?
                    if !username.isEmpty, !password.isEmpty {
                        provider = GTCredentialProvider { type, url, name in
                            try? GTCredential(userName: username, password: password)
                        }
                    }
                    try XS_Git.shared.clone(text, provider: provider) { pro in
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
                            send(.setShowType(.clone(progess, size)))
                        }
                    }
                    await send(.delegate(.clone))
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
                        await send(.setShowType(.error("CLONE失败!")))
                    }
                }
            }
        case .delegate:
            return .none
        case let .setText(value):
            state.text = value
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
