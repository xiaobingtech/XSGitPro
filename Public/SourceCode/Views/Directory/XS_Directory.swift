//
//  XS_Directory.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation
import ComposableArchitecture

extension Store where State == XS_Directory.State, Action == XS_Directory.Action {
    var scopeClone: Store<PresentationState<XS_Clone.State>, PresentationAction<XS_Clone.Action>> {
        scope(state: \.$clone, action: Action.clone)
    }
}

struct XS_Directory: ReducerProtocol {
    struct State: Equatable {
        var list: [XS_GitDirectory] = XS_Git.shared.directorys
        @PresentationState var clone: XS_Clone.State?
    }
    enum Action {
        case delete(XS_GitDirectory)
        case update
        case onAdd
        case clone(PresentationAction<XS_Clone.Action>)
        case set
    }
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
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
            case .onAdd:
                state.clone = .init()
                return .none
                
            case .clone(.presented(.delegate(.clone))):
                state.list = XS_Git.shared.directorys
                return .none
            case .clone:
                return .none
            case .set:
                return .none
            }
        }
        .ifLet(\.$clone, action: /Action.clone) { XS_Clone() }
    }
}
