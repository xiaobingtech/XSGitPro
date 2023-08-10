//
//  XS_Activity.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import Foundation
import ComposableArchitecture

struct XS_Activity: Reducer {
    struct State: Equatable {
        var isShow: Bool = false
        var ids: [UUID] = []
    }
    enum Action {
        case show
        case hide
        case showId(UUID)
        case hideId(UUID)
    }
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .show:
            state.isShow = true
            return .none
        case .hide:
            state.isShow = false
            return .none
        case let .showId(id):
            state.isShow = true
            state.ids.append(id)
            return .none
        case let .hideId(id):
            state.ids.removeAll { $0 == id }
            state.isShow = !state.ids.isEmpty
            return .none
        }
    }
}
