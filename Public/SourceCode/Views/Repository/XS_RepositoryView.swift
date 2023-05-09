//
//  XS_RepositoryView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import SwiftUI
import ComposableArchitecture

struct XS_RepositoryView: View {
    let store: StoreOf<XS_Repository>
    var index: Int
    private func filter(_ array: [XS_GitFile]) -> [XS_GitFile] {
        var titles: [String] = []
        return array.filter {
            let title = $0.path[index]
            if titles.contains(title) {
                return false
            } else {
                titles.append(title)
                return true
            }
        }
    }
    var body: some View {
        WithViewStore(store) { $0 } content: { vs in
            List(filter(vs.array)) { item in
                let title = item.path[index]
                NavigationLink(
                    value: XS_NavPathItem.repository(vs.directory, vs.array, title, index+1)
                ) {
                    HStack {
                        if item.path.count > index+1 {
                            Image(systemName: "folder")
                        }
                        Text(title)
                    }
                    
                }
            }
        }
    }
}
#if DEBUG
struct XS_RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        XS_RepositoryView(
            store: .init(
                initialState: .init(
                    directory: XS_GitDirectory(
                        fileName: "Files",
                        localURL: URL(fileURLWithPath: "/Users/hanyz/Desktop/GitDemo/GitClones/Files")
                    ),
                    array: []
                ),
                reducer: XS_Repository()
            ),
            index: 0
        )
        .debugNav
    }
}
#endif
