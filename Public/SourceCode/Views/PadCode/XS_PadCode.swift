//
//  XS_PadCode.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/8/11.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension XS_PadCode.State {
    struct Code: Equatable {
        let file: XS_GitFile
        let dire: XS_GitDirectory
    }
    var showWidth: Double {
        isShow ? width : .infinity
    }
}

struct XS_PadCode: Reducer {
    static let store: StoreOf<XS_PadCode> = .init(initialState: .init()) { XS_PadCode() }
    static func setShow(isShow: Bool) {
        DispatchQueue.main.async {
            ViewStore(store) { _ in 0 }
                .send(.setShow(isShow))
        }
    }
    static func setCode(code: State.Code?) {
        DispatchQueue.main.async {
            ViewStore(store) { _ in 0 }
                .send(.setCode(code))
        }
    }
    static var maxWidth: Double {
        (UIScreen.main.bounds.size.width - 100)
    }
    
    struct State: Equatable {
        var code: Code?
        var width: Double
        var isShow: Bool = false
        init() {
            @AppStorage("XS_PadCode_Width") var data: Double?
            width = min(data ?? 400, XS_PadCode.maxWidth)
        }
    }
    enum Action {
        case onChanged(Double)
        case onEnded
        case setShow(Bool)
        case setCode(State.Code?)
    }
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .setCode(value):
            state.code = value
            return .none
        case let .setShow(value):
            state.isShow = value
            return .none
        case let .onChanged(value):
            state.width += value
            return .none
        case .onEnded:
            state.width = max(min(state.width, XS_PadCode.maxWidth), 100)
            @AppStorage("XS_PadCode_Width") var data: Double?
            data = state.width
            return .none
        }
    }
}
