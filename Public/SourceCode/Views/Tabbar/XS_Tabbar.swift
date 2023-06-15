//
//  XS_Tabbar.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/15.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == XS_Tabbar.State.Name, ViewAction == XS_Tabbar.Action {
    var binding: Binding<ViewState> {
        binding(
            send: ViewAction.setSelection
        )
    }
}

extension XS_Tabbar.State {
    var navTitle: String { selection.rawValue }
    enum Name: String {
        case Files
        case Status
        case Branches
        case Commits
        case Search
    }
}

struct XS_Tabbar: ReducerProtocol {
    struct State: Equatable {
        var selection: Name = .Files
    }
    
    enum Action {
        case setSelection(State.Name)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .setSelection(selection):
            state.selection = selection
            return .none
        }
    }
}
