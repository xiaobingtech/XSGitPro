//
//  XS_FilesView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/14.
//

import SwiftUI
import ComposableArchitecture

struct XS_FilesView: View {
    let store: StoreOf<XS_Files>
    private func status(_ status: GTIndexEntryStatus) -> String {
        switch status {
        case .updated:
            return "Updated"
        case .conflicted:
            return "Conflicted"
        case .added:
            return "Added"
        case .removed:
            return "Removed"
        case .upToDate:
            return "UpToDate"
        @unknown default:
            return ""
        }
    }
    private func array(_ dic: [String:[XS_GitFile]], key: String) -> [XS_GitFile] {
        dic[key] ?? []
    }
    var body: some View {
        WithViewStore(store) { $0 } content: { vs in
            List(array(vs.files, key: vs.key)) { item in
                if let entry = item.entry {
                    HStack {
                        Label(item.name, systemImage: "doc.text")
                        Spacer()
                        Text(status(entry.status))
                    }
                } else {
                    NavigationLink(value: XS_NavPathItem.files(vs.files, item.id, item.name)) {
                        HStack {
                            Label(item.name, systemImage: "folder")
                            Spacer()
                            Text("\(array(vs.files, key: item.id).count)")
                        }
                    }
                }
            }
            
        }
    }
}

#if DEBUG
struct XS_FilesView_Previews: PreviewProvider {
    static var previews: some View {
        XS_FilesView(
            store: .init(initialState: .init(files: ["":[.init(id: "name", name: "name", entry: nil)]], key: "")) {
                XS_Files()
            }
        )
        .navigationTitle("title")
        .debugNav
    }
}
#endif
