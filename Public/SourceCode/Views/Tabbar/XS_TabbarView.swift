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
                _status._tabItem(.Status)
                _branches._tabItem(.Branches)
                _commits._tabItem(.Commits)
                _search._tabItem(.Search)
            }
        }
        .onAppear {
            if UIDevice.isPad {
                XS_PadCode.setShow(isShow: true)
            }
        }
        .navigationTitle(directory.fileName)
    }
    private var _search: some View {
        XS_SearchView(
            store: .init(initialState: .init(directory.entries, directory: directory)) {
                XS_Search()
            },
            directory: directory
        )
    }
    private var _commits: some View {
        XS_CommitsView(
            store: .init(initialState: .init(repo: directory.repo)) {
                XS_Commits()
            }
        )
    }
    private var _branches: some View {
        XS_BranchesView(
            store: .init(initialState: .init(repo: directory.repo)) {
                XS_Branches()
            }
        )
    }
    private var _status: some View {
        XS_StatusView(
            store: .init(initialState: .init(repo: directory.repo)) {
                XS_Status()
            }
        )
    }
    private var _files: some View {
        XS_FilesView(
            store: .init(initialState: .init(files: XS_Git.shared.files(directory.repo), key: "", directory: directory)) {
                XS_Files()
            }
        )
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
                Label(name.rawValue, systemImage: name.systemImage)
            }
            .tag(name)
    }
}
private struct _NavModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
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
