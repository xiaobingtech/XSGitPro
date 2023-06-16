//
//  XS_SearchView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/16.
//

import SwiftUI
import ComposableArchitecture

struct XS_SearchView: View {
    let store: StoreOf<XS_Search>
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    var body: some View {
        WithViewStore(store, observe: \.text) { vs in
            _list
                .searchable(text: vs.binding, prompt: Text("搜索文件名"))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
    }
    private var _list: some View {
        WithViewStore(store, observe: \.list) { vs in
            List(vs.state) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                    Text(item.entry.path)
                        .font(.footnote)
                        .lineLimit(1)
                }
                .lineLimit(1)
            }
            .listStyle(.plain)
        }
    }
}

#if DEBUG
struct XS_SearchView_Previews: PreviewProvider {
    static var previews: some View {
        XS_SearchView(
            store: .init(initialState: .init(XS_Git.shared.directorys.first!.entries)) {
                XS_Search()
            }
        )
        .debugNav
    }
}
#endif
