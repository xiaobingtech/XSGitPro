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
        _list
            .navigationTitle("所有仓库")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        ViewStore(store).send(.onAdd)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(store: store.scopeClone) { store in
                XS_CloneView(store: store)
            }
    }
    private var _list: some View {
        WithViewStore(store, observe: \.list) { vs in
            ScrollView {
                VStackLayout(spacing: 0) {
                    ForEach(vs.state) { item in
                        VStack(alignment: .leading) {
                            Text(item.fileName)
                            if let name = item.branchName {
                                Text(name)
                                    .font(.footnote)
                            }
                            Divider()
                        }
                        .padding(.leading)
                        .xsDelete {
                            vs.send(.delete(item), animation: .default)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
            }
        }
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
