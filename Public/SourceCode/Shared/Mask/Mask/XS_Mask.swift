//
//  XS_Mask.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import Foundation
import ComposableArchitecture

extension Store where State == XS_Mask.State, Action == XS_Mask.Action {
    var scopeActivity: StoreOf<XS_Activity> {
        scope(state: \.activity, action: Action.activity)
    }
    var scopeToast: StoreOf<XS_Toast> {
        scope(state: \.toast, action: Action.toast)
    }
}

extension XS_Mask.State {
    var isMask: Bool { activity.isShow }
}

struct XS_Mask: Reducer {
    struct State: Equatable {
        var activity: XS_Activity.State = .init()
        var toast: XS_Toast.State = .init()
    }
    enum Action {
        case activity(XS_Activity.Action)
        case toast(XS_Toast.Action)
    }
    var body: some Reducer<State, Action> {
        Scope(state: \.activity, action: /Action.activity, child: XS_Activity.init)
        Scope(state: \.toast, action: /Action.toast, child: XS_Toast.init)
    }
}
