//
//  XS_CommitsView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/17.
//

import SwiftUI
import ComposableArchitecture

struct XS_CommitsView: View {
    let store: StoreOf<XS_Commits>
    var body: some View {
        _list
            .navigationTitle("Commits")
    }
    private var _list: some View {
        WithViewStore(store, observe: \.commits) { vs in
            List(vs.state, id: \.self) { item in
                NavigationLink(value: XS_NavPathItem.commit(item)) {
                    VStack(alignment: .leading) {
                        Text(item.messageSummary)
                            .fontWeight(.bold)
                        if let name = item.author?.name {
                            Text(name + " , " + item.dateStr)
                                .font(.footnote)
                        }
                    }
                    .lineLimit(1)
                    .frame(height: 38)
                }
            }
        }
    }
}

#if DEBUG
struct XS_CommitsView_Previews: PreviewProvider {
    static var previews: some View {
        XS_CommitsView(
            store: .init(initialState: .init(repo: XS_Git.shared.directorys.last!.repo)) {
                XS_Commits()
            }
        )
        .debugNav
    }
}
#endif
