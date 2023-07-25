//
//  XS_Files.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/14.
//

import Foundation
import ComposableArchitecture

struct XS_Files: ReducerProtocol {
    struct State: Equatable {
        var files: [String:XS_GitFolder]
        var key: String
        var directory: XS_GitDirectory
    }
    enum Action {
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    }
}
