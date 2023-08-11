//
//  XS_PadCodeView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/8/11.
//

import SwiftUI
import ComposableArchitecture

struct XS_PadCodeView: View {
    private let store: StoreOf<XS_PadCode> = XS_PadCode.store
    var body: some View {
        HStack(spacing: 0) {
            WithViewStore(store, observe: \.showWidth) { vs in
                XS_NavView()
                    .frame(width: vs.state)
            }
            WithViewStore(store, observe: \.isShow) { vs in
                if vs.state {
                    Divider()
                    Image(systemName: "equal.square")
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    vs.send(.onChanged(value.location.x))
                                }
                                .onEnded { _ in
                                    vs.send(.onEnded)
                                }
                        )
                        .padding()
                        .frame(width: 0)
                        .zIndex(10)
                    _ContentView(store: store)
                }
            }
        }
    }
}

private struct _ContentView: View {
    let store: StoreOf<XS_PadCode>
    var body: some View {
        WithViewStore(store, observe: \.code) { vs in
            if let code = vs.state {
                NavigationStack {
                    CodeView(file: code.file, directory: code.dire)
                        .navigationTitle(code.file.name)
                }
                
            } else {
                Text("未选择展示文件")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#if DEBUG
struct XS_PadCodeView_Previews: PreviewProvider {
    static var previews: some View {
        XS_PadCodeView()
    }
}
#endif
