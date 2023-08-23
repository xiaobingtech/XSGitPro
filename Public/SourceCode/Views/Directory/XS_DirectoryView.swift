//
//  XS_DirectoryView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import SwiftUI
import ComposableArchitecture

struct XS_DirectoryView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let store: StoreOf<XS_Directory> = rootStore.scopeDirectory
    @State private var deleteId: UUID?
    var body: some View {
        _list
            .onAppear {
                if UIDevice.isPad {
                    XS_PadCode.setShow(isShow: false)
                    XS_PadCode.setCode(code: nil)
                }
            }
            .navigationTitle("所有仓库")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.onSet)
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.defaultText)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        store.send(.onAdd)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.defaultText)
                    }
                }
            }
            .sheet(store: store.scopeClone) { store in
                XS_CloneView(store: store)
            }
            .sheet(store: store.scopeSet) { store in
                XS_SetView(store: store)
            }
    }
    private var _list: some View {
        WithViewStore(store, observe: \.list) { vs in
            ScrollView {
                VStackLayout(spacing: 0) {
                    ForEach(vs.state) { item in
                        NavigationLink(value: XS_NavPathItem.tabbar(item)) {
                            VStack(spacing: 0) {
                                VStack(alignment: .leading) {
                                    Text(item.fileName)
                                    if let name = item.branchName {
                                        Text(name)
                                            .font(.footnote)
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                                Divider()
                            }
                            .foregroundColor(.defaultText)
                            .background(Color.defaultBackground)
                            .padding(.leading)
                            .xsDelete($deleteId) {
                                vs.send(.delete(item), animation: .default)
                            }
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
