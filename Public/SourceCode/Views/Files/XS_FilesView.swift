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
    @State private var expandedFolderIds: Set<String> = []

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
            List {
                ForEach(array(vs.files, key: vs.key).list, id: \.id) { item in
                    FileTreeItem(
                        item: item,
                        files: vs.files,
                        directory: vs.directory,
                        expandedFolderIds: $expandedFolderIds,
                        status: status
                    )
                }
            }
            .listStyle(.plain)
        }
    }
}

private struct FileTreeItem: View {
    let item: XS_GitFile
    let files: [String: XS_GitFolder]
    let directory: XS_GitDirectory
    @Binding var expandedFolderIds: Set<String>
    let status: (GTIndexEntryStatus) -> String
    var depth: Int = 0

    private let indentPerLevel: CGFloat = 16

    private func array(_ dic: [String:XS_GitFolder], key: String) -> XS_GitFolder {
        dic[key] ?? XS_GitFolder()
    }

    private var isExpanded: Bool {
        expandedFolderIds.contains(item.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let entry = item.entry {
                // File item
                fileRow(for: entry)
            } else {
                // Folder item
                folderRow
                if isExpanded {
                    children
                }
            }
        }
    }

    private func fileRow(for entry: GTIndexEntry) -> some View {
        Group {
            if UIDevice.isPad {
                Button {
                    XS_PadCode.setCode(code: .init(file: item, dire: directory))
                } label: {
                    rowContent(
                        icon: "doc.text",
                        text: item.name,
                        trailing: status(entry.status)
                    )
                }
                .tint(.defaultText)
            } else {
                NavigationLink(value: XS_NavPathItem.code(item, directory)) {
                    rowContent(
                        icon: "doc.text",
                        text: item.name,
                        trailing: status(entry.status)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: depth > 0 ? 44 : nil)
        .padding(.leading, CGFloat(depth) * indentPerLevel)
    }

    private var folderRow: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                if isExpanded {
                    expandedFolderIds.remove(item.id)
                } else {
                    expandedFolderIds.insert(item.id)
                }
            }
        } label: {
            HStack(alignment: .center) {
                Image(systemName: isExpanded ? "folder.fill" : "folder")
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                Text(item.name)
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Spacer()
                Text("\(array(files, key: item.id).count)")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 12, weight: .semibold))
                    .frame(width: 16)
            }
            .contentShape(Rectangle())
        }
        .frame(height: depth > 0 ? 44 : nil)
        .buttonStyle(.plain)
        .padding(.leading, CGFloat(depth) * indentPerLevel)
    }

    private var children: some View {
        let childList = array(files, key: item.id).list
        return ForEach(Array(childList.enumerated()), id: \.element.id) { index, child in
            VStack(spacing: 0) {
                FileTreeItem(
                    item: child,
                    files: files,
                    directory: directory,
                    expandedFolderIds: $expandedFolderIds,
                    status: status,
                    depth: depth + 1
                )
                if index < childList.count - 1 {
                    Divider()
                        .padding(.leading, CGFloat(depth + 1) * indentPerLevel)
                }
            }
        }
    }

    private func rowContent(icon: String, text: String, trailing: String) -> some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            Text(text)
                .foregroundStyle(.primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Spacer()
            Text(trailing)
                .foregroundStyle(.secondary)
                .font(.footnote)
        }
        .contentShape(Rectangle())
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
