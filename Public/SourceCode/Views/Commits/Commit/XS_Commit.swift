//
//  XS_Commit.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/21.
//

import Foundation
import ComposableArchitecture

struct XS_Commit: Reducer {
    struct State: Equatable {
        let commit: GTCommit
    }
    enum Action {
    }
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
    }
}
