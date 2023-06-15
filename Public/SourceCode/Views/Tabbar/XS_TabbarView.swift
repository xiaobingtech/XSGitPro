//
//  XS_TabbarView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/15.
//

import SwiftUI
import ComposableArchitecture

struct XS_TabbarView: View {
    let directory: XS_GitDirectory
    let store: StoreOf<XS_Tabbar>
    var body: some View {
        WithViewStore(store, observe: \.selection) { vs in
            TabView(selection: vs.binding) {
                _files._tabItem(.Files)
                Text("Status")
                    ._tabItem(.Status)
                Text("Branches")
                    ._tabItem(.Branches)
                Text("Commits")
                    ._tabItem(.Commits)
                Text("Search")
                    ._tabItem(.Search)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationTitle(directory.fileName)
    }
    private var _files: some View {
        XS_FilesView(
            store: .init(initialState: .init(files: XS_Git.shared.files(directory.repo), key: "")) {
                XS_Files()
            }
        )
        .navigationTitle(directory.fileName)
    }
}

private extension View {
    func _tabItem(_ name: XS_Tabbar.State.Name) -> ModifiedContent<Self, _TabItemModifier> {
        modifier(_TabItemModifier(name: name))
    }
    func _nav() -> ModifiedContent<Self, _NavModifier> {
        modifier(_NavModifier())
    }
}
private struct _TabItemModifier: ViewModifier {
    let name: XS_Tabbar.State.Name
    func body(content: Content) -> some View {
        content
            ._nav()
            .tabItem {
                Text(name.rawValue)
            }
            .tag(name)
    }
}
private struct _NavModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    func body(content: Content) -> some View {
        NavigationView {
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("所有仓库")
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}

#if DEBUG
struct XS_TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        XS_TabbarView(
            directory: XS_Git.shared.directorys.first!,
            store: .init(initialState: .init()) {
                XS_Tabbar()
            }
        )
        .debugNav
    }
}
#endif
