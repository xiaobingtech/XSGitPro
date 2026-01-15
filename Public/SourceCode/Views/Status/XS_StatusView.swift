//
//  XS_StatusView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import SwiftUI
import ComposableArchitecture

struct XS_StatusView: View {
    let store: StoreOf<XS_Status>
    var body: some View {
        VStack {
            Button("Commit".i18n) {
                store.send(.onCommit)
            }
            Button("Pull".i18n) {
                store.send(.onPull)
            }
            Button("Push".i18n) {
                store.send(.onPush)
            }
        }
        .sheet(store: store.scopeCommit) { store in
            XS_OnCommitView(store: store)
        }
        .sheet(store: store.scopePull) { store in
            XS_OnPullView(store: store)
        }
        .sheet(store: store.scopePush) { store in
            XS_OnPushView(store: store)
        }
    }
}

#if DEBUG
struct XS_StatusView_Previews: PreviewProvider {
    static var previews: some View {
        XS_StatusView(
            store: .init(initialState: .init(repo: XS_Git.shared.directorys.last!.repo)) {
                XS_Status()
            }
        ).debugNav
    }
}
#endif
