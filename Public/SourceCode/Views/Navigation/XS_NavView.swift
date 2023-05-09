//
//  XS_NavView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import SwiftUI
import ComposableArchitecture

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
private struct _NavDestination: ViewModifier {
    func body(content: Content) -> some View {
        content.navigationDestination(for: XS_NavPathItem.self) { item in
            switch item {
            case let .repository(directory, array, title, index):
                XS_RepositoryView(
                    store: .init(
                        initialState: .init(
                            directory: directory,
                            array: XS_Git.shared.files(array, title: title, index: index)
                        ),
                        reducer: XS_Repository()
                    ),
                    index: index
                )
                .navigationTitle(title.isEmpty ? directory.fileName : title)
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
