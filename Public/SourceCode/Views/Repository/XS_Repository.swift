//
//  XS_Repository.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation
import ComposableArchitecture

struct XS_Repository: ReducerProtocol {
    struct State: Equatable {
        var directory: XS_GitDirectory
        var array: [XS_GitFile]
    }
    enum Action {
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        }
    }
}
