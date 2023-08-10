//
//  XS_ActivityView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import SwiftUI
import ComposableArchitecture

struct XS_ActivityView: View {
    let store: StoreOf<XS_Activity>
    var body: some View {
        WithViewStore(store, observe: \.isShow) { vs in
            if vs.state {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 80, height: 80)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
                    .transition(
                        .scale(scale: 0.5)
                        .combined(with: .opacity)
                        .animation(.spring())
                    )
            }
        }
    }
}
#if DEBUG
struct XS_ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        XS_ActivityView(
            store: .init(
                initialState: .init(isShow: true)
            ) {
                XS_Activity()
            }
        )
    }
}
#endif
