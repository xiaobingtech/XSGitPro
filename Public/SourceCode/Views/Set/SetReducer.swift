//
//  XS_Clone.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/8.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == String, ViewAction == XS_Clone.Action {
    
}

struct SetReducer: Reducer {
    struct State: Equatable {
        
    }
    enum Action {
        case onCancel
    }
    @Dependency(\.dismiss) var dismiss
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onCancel:
            return .run { send in
                await self.dismiss()
            }
        }
    }
}
