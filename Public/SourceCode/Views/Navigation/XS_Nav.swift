//
//  XS_Nav.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == [XS_NavPathItem], ViewAction == XS_Nav.Action {
    var binding: Binding<ViewState> {
        binding(
            send: ViewAction.setPath
        )
    }
}

enum XS_NavPathItem: Equatable, Hashable {
    case tabbar(XS_GitDirectory)
    case files([String:XS_GitFolder], String, String, XS_GitDirectory)
    case commit(GTCommit)
    case code(XS_GitFile, XS_GitDirectory)
}

struct XS_Nav: Reducer {
    struct State: Equatable {
        var path: [XS_NavPathItem] = []
        var files: [XS_NavPathItem] = []
    }
    enum Action {
        case setPath([XS_NavPathItem])
        case setFiles([XS_NavPathItem])
    }
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .setPath(value):
            state.path = value
            if value.isEmpty {
                state.files.removeAll()
            }
            return .none
        case let .setFiles(value):
            state.files = value
            return .none
        }
    }
}
