//
//  XS_ToastView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import SwiftUI
import ComposableArchitecture

struct XS_ToastView: View {
    let store: StoreOf<XS_Toast>
    var body: some View {
        WithViewStore(store, observe: { ($0.text, $0.alignment) }, removeDuplicates: ==) { vs in
            VStack {
                if let text = vs.0, !text.isEmpty {
                    Text(text)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .padding()
                        .transition(
                            .scale(scale: 0.5)
                            .combined(with: .opacity)
                            .animation(.spring())
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: vs.1)
            .animation(.default, value: vs.1)
        }
    }
}
#if DEBUG
struct XS_ToastView_Previews: PreviewProvider {
    static var previews: some View {
        XS_ToastView(
            store: .init(
                initialState: .init(text: "12345")
            ) {
                XS_Toast()
            }
        )
    }
}
#endif
