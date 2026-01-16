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
    private func array(_ dic: [String:XS_GitFolder], key: String) -> XS_GitFolder {
        dic[key] ?? XS_GitFolder()
    }
    var body: some View {
        WithViewStore(store) { $0 } content: { vs in
            List(array(vs.files, key: vs.key).list) { item in
                if let entry = item.entry {
                    if UIDevice.isPad {
                        Button {
                            XS_PadCode.setCode(code: .init(file: item, dire: vs.directory))
                        } label: {
                            HStack {
                                Label(item.name, systemImage: "doc.text")
                                    .foregroundStyle(.primary)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                Spacer()
                                Text(status(entry.status))
                                    .foregroundStyle(.secondary)
                                    .font(.footnote)
                            }
                        }
                        .tint(.defaultText)
                        
//                        HStack {
//                            Label(item.name, systemImage: "doc.text")
//                                .minimumScaleFactor(0.5)
//                                .lineLimit(1)
//                            Spacer()
//                            Text(status(entry.status))
//                                .font(.footnote)
//                        }
//                        .onTapGesture {
//                            XS_PadCode.setCode(code: .init(file: item, dire: vs.directory))
//                        }
                    } else {
                        NavigationLink(value: XS_NavPathItem.code(item, vs.directory)) {
                            HStack {
                                Label(item.name, systemImage: "doc.text")
                                    .foregroundStyle(.primary)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                Spacer()
                                Text(status(entry.status))
                                    .foregroundStyle(.secondary)
                                    .font(.footnote)
                            }
                        }
                    }
                } else {
                    NavigationLink(value: XS_NavPathItem.files(vs.files, item.id, item.name, vs.directory)) {
                        HStack {
                            Label(item.name, systemImage: "folder")
                                .foregroundStyle(.primary)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Spacer()
                            Text("\(array(vs.files, key: item.id).count)")
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

//#if DEBUG
//struct XS_FilesView_Previews: PreviewProvider {
//    static var previews: some View {
//        XS_FilesView(
//            store: .init(initialState: .init(files: ["":XS_GitFolder()], key: "")) {
//                XS_Files()
//            }
//        )
//        .navigationTitle("title")
//        .debugNav
//    }
//}
//#endif
