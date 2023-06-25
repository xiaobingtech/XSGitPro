//
//  XS_Status.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import Foundation
import ComposableArchitecture

extension Store where State == XS_Status.State, Action == XS_Status.Action {
    var scopeCommit: Store<PresentationState<XS_OnCommit.State>, PresentationAction<XS_OnCommit.Action>> {
        scope(state: \.$commit, action: Action.commit)
    }
}

struct XS_Status: ReducerProtocol {
    struct State: Equatable {
        let repo: GTRepository
        @PresentationState var commit: XS_OnCommit.State?
    }
    enum Action {
        case onCommit
        case commit(PresentationAction<XS_OnCommit.Action>)
    }
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .onCommit:
                state.commit = .init(repo: state.repo)
                return .none
            case .commit:
                return .none
            }
        }
        .ifLet(\.$commit, action: /Action.commit) { XS_OnCommit() }
    }
}
