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
    let directory: XS_GitDirectory
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
                let file = XS_GitFile(id: item.entry.path, name: item.name, entry: item.entry)
                if UIDevice.isPad {
                    Button {
                        XS_PadCode.setCode(code: .init(file: file, dire: directory))
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                            Text(item.entry.path)
                                .font(.footnote)
                                .lineLimit(1)
                        }
                        .lineLimit(1)
                    }
                    .tint(.defaultText)
                } else {
                    NavigationLink(value: XS_NavPathItem.code(file, directory)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                            Text(item.entry.path)
                                .font(.footnote)
                                .lineLimit(1)
                        }
                        .lineLimit(1)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#if DEBUG
struct XS_SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let directory = XS_Git.shared.directorys.first!
        XS_SearchView(
            store: .init(initialState: .init(directory.entries, directory: directory)) {
                XS_Search()
            },
            directory: directory
        )
        .debugNav
    }
}
#endif
