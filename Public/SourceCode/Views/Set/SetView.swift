//
//  XS_CloneView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/8.
//

import SwiftUI
import ComposableArchitecture

struct SetView: View {
    let store: StoreOf<XS_Clone>
    var body: some View {
        NavigationStack {
            VStack {
                WithViewStore(store, observe: \.showType) { vs in
                    
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel".i18n) {
                        ViewStore(store) { _ in 0 } .send(.onCancel)
                    }
                }
            }
            .navigationTitle("Set".i18n)
        }
    }
}

#if DEBUG
struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(
            store: .init(initialState: .init()) {
                XS_Clone()
            }
        )
    }
}
#endif
