//
//  XS_SetView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/8/23.
//

import SwiftUI
import ComposableArchitecture

struct XS_SetView: View {
    let store: StoreOf<XS_Set>
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                store.send(.onCancel)
            }
    }
}

#if DEBUG
struct XS_SetView_Previews: PreviewProvider {
    static var previews: some View {
        XS_SetView(
            store: .init(initialState: .init()) {
                XS_Set()
            }
        )
    }
}
#endif
