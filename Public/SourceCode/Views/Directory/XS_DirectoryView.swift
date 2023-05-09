//
//  XS_DirectoryView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import SwiftUI
import ComposableArchitecture

struct XS_DirectoryView: View {
    private let store: StoreOf<XS_Directory> = rootStore.scopeDirectory
    var body: some View {
        VStack {
            _clone
            _list
        }
        .navigationTitle("仓库")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                WithViewStore(store, observe: \.progess) { vs in
                    if let progess = vs.state {
                        HStack {
                            Text(progess.text)
                            _Progess(progess: progess.progess)
                        }
                        .frame(height: 50)
                    } else {
                        _navItem
                    }
                }
            }
        }
    }
    private var _clone: some View {
        WithViewStore(store, observe: \.text) { vs in
            if vs.state != nil {
                TextField("http://example.com/object.git", text: vs.binding)
                    .padding(5)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(Capsule())
                    .padding()
            }
        }
    }
    private var _list: some View {
        WithViewStore(store, observe: \.list) { vs in
            List(vs.state) { item in
                if item.repo == nil {
                    HStack {
                        Text(item.fileName)
                        Spacer(minLength: 0)
                        Text("无效仓库")
                            .font(.footnote)
                    }
                    .foregroundColor(.gray)
                } else {
                    NavigationLink(value: XS_NavPathItem.repository(item, XS_Git.shared.files(item.repo), "", 0)) {
                        Text(item.fileName)
                    }
                }
            }
        }
    }
    private var _navItem: some View {
        WithViewStore(store, observe: \.text) { vs in
            if vs.state == nil {
                Button {
                    vs.send(.onAdd)
                } label: {
                    Image(systemName: "plus")
                }
            } else {
                HStack {
                    Button {
                        vs.send(.onDismiss)
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    }
                    Spacer(minLength: 20)
                    Button {
                        vs.send(.onSure)
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
}
private struct _Progess: View {
    var progess: Double
    var body: some View {
        let width: Double = 60
        ZStack(alignment: .leading) {
            Color.gray
            Color.green
                .frame(width: progess*width)
        }
        .frame(width: width, height: 5)
        .clipShape(Capsule())
    }
}
#if DEBUG
struct XS_DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        XS_DirectoryView()
            .debugNav
    }
}
#endif
