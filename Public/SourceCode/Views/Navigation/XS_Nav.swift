//
//  XS_Nav.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == XS_Nav.State, ViewAction == XS_Nav.Action {
    var binding: Binding<[XS_NavPathItem]> {
        binding(
            get: \.path,
            send: ViewAction.setPath
        )
    }
}
extension ViewStore where ViewState == [XS_NavPathItem], ViewAction == XS_Nav.Action {
    var binding: Binding<[XS_NavPathItem]> {
        binding(
            send: ViewAction.setPath
        )
    }
}

enum XS_NavPathItem: Equatable, Hashable {
    case files([String:[XS_GitFile]], String, String)
}

struct XS_Nav: ReducerProtocol {
    struct State: Equatable {
        var path: [XS_NavPathItem] = []
    }
    enum Action {
        case setPath([XS_NavPathItem])
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .setPath(value):
            state.path = value
            return .none
        }
    }
}
