//
//  XS_Root.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import Foundation
import ComposableArchitecture

let rootStore: StoreOf<XS_Root> = .init(
    initialState: .init(),
    reducer: XS_Root()
)
let maskStore: StoreOf<XS_Mask> = .init(
    initialState: .init(),
    reducer: XS_Mask()
)
let navStore: StoreOf<XS_Nav> = .init(
    initialState: .init(),
    reducer: XS_Nav()
)
let tabStore: StoreOf<XS_Tabbar> = .init(initialState: .init()) {
    XS_Tabbar()
}

extension Store where State == XS_Root.State, Action == XS_Root.Action {
    var scopeDirectory: StoreOf<XS_Directory> {
        scope(state: \.directory, action: Action.directory)
    }
}

struct XS_Root: ReducerProtocol {
    struct State: Equatable {
        var directory: XS_Directory.State = .init()
    }
    enum Action {
        case directory(XS_Directory.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.directory, action: /Action.directory, child: XS_Directory.init)
    }
}
