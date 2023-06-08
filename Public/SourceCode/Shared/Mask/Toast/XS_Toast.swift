//
//  XS_Toast.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct XS_Toast: ReducerProtocol {
    struct State: Equatable {
        var id: UUID?
        var text: String?
        var alignment: Alignment = .bottom
    }
    enum Action {
        case showToast(msg: String, time: Double = 2, alignment: Alignment = .bottom)
        case hideToast
        case _hideToast(UUID)
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .showToast(msg, time, alignment):
            if msg.isEmpty {
                return .none
            }
            let id = UUID()
            state.id = id
            state.text = msg
            state.alignment = alignment
            return .task {
                try await Task.sleep(seconds: time)
                return ._hideToast(id)
            }
        case .hideToast:
            _hideToast(state: &state)
            return .none
        case let ._hideToast(id):
            if id == state.id {
                _hideToast(state: &state)
            }
            return .none
        }
    }
    private func _hideToast(state: inout State) {
        state.id = nil
        state.text = nil
    }
}
