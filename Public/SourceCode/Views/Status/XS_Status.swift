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
    var scopePull: Store<PresentationState<XS_OnPull.State>, PresentationAction<XS_OnPull.Action>> {
        scope(state: \.$pull, action: Action.pull)
    }
    var scopePush: Store<PresentationState<XS_OnPush.State>, PresentationAction<XS_OnPush.Action>> {
        scope(state: \.$push, action: Action.push)
    }
}

struct XS_Status: Reducer {
    struct State: Equatable {
        let repo: GTRepository
        @PresentationState var commit: XS_OnCommit.State?
        @PresentationState var pull: XS_OnPull.State?
        @PresentationState var push: XS_OnPush.State?
    }
    enum Action {
        case onCommit
        case commit(PresentationAction<XS_OnCommit.Action>)
        case onPull
        case pull(PresentationAction<XS_OnPull.Action>)
        case onPush
        case push(PresentationAction<XS_OnPush.Action>)
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onCommit:
                state.commit = .init(repo: state.repo)
                return .none
            case .commit:
                return .none
            case .onPull:
                state.pull = .init(repo: state.repo)
                return .none
            case .pull:
                return .none
            case .onPush:
                state.push = .init(repo: state.repo)
                return .none
            case .push:
                return .none
            }
        }
        .ifLet(\.$commit, action: /Action.commit) { XS_OnCommit() }
        .ifLet(\.$pull, action: /Action.pull) { XS_OnPull() }
        .ifLet(\.$push, action: /Action.push) { XS_OnPush() }
    }
}
