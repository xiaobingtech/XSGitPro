//
//  XS_Set.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/8/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct XS_Set: Reducer {
    struct State: Equatable {

    }
    enum Action {
        case onCancel
        case delegate(Delegate)
        enum Delegate {
//            case clone
        }
    }
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onCancel:
            return .run { send in
                await self.dismiss()
            }
        case .delegate:
            return .none
        }
    }
}
