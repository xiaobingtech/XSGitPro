//
//  XS_NavView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import SwiftUI
import ComposableArchitecture

extension View {
    func xsFilesNav() -> some View {
        modifier(_NavFilesView())
    }
}

struct XS_NavView: View {
    private let store: StoreOf<XS_Nav> = navStore
    var body: some View {
        WithViewStore(store, observe: \.path) { vs in
            NavigationStack(path: vs.binding) {
                XS_DirectoryView()
                    .modifier(_NavDestination())
            }
        }
    }
}

private struct _NavFilesView: ViewModifier {
    private let store: StoreOf<XS_Nav> = navStore
    func body(content: Content) -> some View {
        WithViewStore(store, observe: \.files) { vs in
            NavigationStack(path: vs.binding) {
                content.modifier(_NavDestination())
            }
        }
    }
}
private struct _NavDestination: ViewModifier {
    func body(content: Content) -> some View {
        content.navigationDestination(for: XS_NavPathItem.self) { item in
            switch item {
            case let .tabbar(value):
                XS_TabbarView(
                    directory: value,
                    store: tabStore
                )
            case let .files(files, key, title):
                XS_FilesView(
                    store: .init(initialState: .init(files: files, key: key)) {
                        XS_Files()
                    }
                )
                .navigationTitle(title)
            case let .commit(value):
                XS_CommitView(
                    store: .init(initialState: .init(commit: value)) {
                        XS_Commit()
                    }
                )
            case let .code(file):
                CodeView(file: file)
                    .navigationTitle(file.name)
            default: EmptyView()
            }
        }
    }
}
#if DEBUG
extension View {
    var debugNav: some View {
        WithViewStore(navStore, observe: \.path) { vs in
            NavigationStack(path: vs.binding) {
                self.modifier(_NavDestination())
            }
        }
        .xsMask(maskStore)
        .tint(.black)
    }
}
struct XS_NavView_Previews: PreviewProvider {
    static var previews: some View {
        XS_NavView()
    }
}
#endif
