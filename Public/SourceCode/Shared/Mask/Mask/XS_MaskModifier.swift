//
//  XS_MaskModifier.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import SwiftUI
import ComposableArchitecture

extension View {
    func xsMask(_ store: StoreOf<XS_Mask>) -> ModifiedContent<Self, XS_MaskModifier> {
        modifier(XS_MaskModifier(store: store))
    }
}

struct XS_MaskModifier: ViewModifier {
    let store: StoreOf<XS_Mask>
    func body(content: Content) -> some View {
        ZStack {
            WithViewStore(store, observe: \.isMask) { vs in
                content.disabled(vs.state)
                if vs.state {
                    Color.black.opacity(0.3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity.animation(.easeInOut))
                }
                XS_ActivityView(store: store.scopeActivity)
                XS_ToastView(store: store.scopeToast)
            }
        }
    }
}
#if DEBUG
struct XS_MaskModifier_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<XS_Mask> = .init(
            initialState: .init()
        ) {
            XS_Mask()
        }
        let vs = ViewStore(store) { _ in 0 }
        return VStack {
            HStack {
                Button("显示1") {
                    vs.send(.toast(.showToast(msg: "1234", alignment: .center)))
                }
                Button("显示2") {
                    vs.send(.toast(.showToast(msg: "background(Color.white)background(Color.white)background(Color.white)")))
                }
                Button("隐藏") {
                    vs.send(.toast(.hideToast))
                }
            }
            Button("Loading") {
                vs.send(.activity(.show))
                Task {
                    try await Task.sleep(seconds: 3)
                    vs.send(.activity(.hide))
                }
            }
        }
        .buttonStyle(.bordered)
        .xsMask(store)
    }
}
#endif
