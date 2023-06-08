//
//  XS_Directory.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation
import ComposableArchitecture

struct XS_Directory: ReducerProtocol {
    struct State: Equatable {
        var list: [XS_GitDirectory] = XS_Git.shared.directorys
    }
    enum Action {
        case delete(XS_GitDirectory)
        case update
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .delete(value):
            do {
                try FileManager.default.removeItem(at: value.localURL)
                state.list.removeAll { $0 == value }
            } catch {
                debugPrint(error)
                DispatchQueue.main.async {
                    ViewStore(maskStore.scopeToast)
                        .send(.showToast(msg: error.localizedDescription))
                }
            }
            return .none
        case .update:
            state.list = XS_Git.shared.directorys
            return .none
        }
    }
}
