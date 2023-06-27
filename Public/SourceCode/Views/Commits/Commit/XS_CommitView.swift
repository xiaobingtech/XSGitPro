//
//  XS_CommitView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/21.
//

import SwiftUI
import ComposableArchitecture

struct XS_CommitView: View {
    let store: StoreOf<XS_Commit>
    var body: some View {
        WithViewStore(store, observe: \.commit) { vs in
            ScrollView {
                VStack {
                    info(vs)
//                    tree(vs)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Commit \(vs.shortSHA)")
        }
    }
    private func tree(_ vs: ViewStore<GTCommit, XS_Commit.Action>) -> some View {
        VStack {
            if let tree = vs.tree, let entries = tree.entries {
                ForEach(entries, id: \.self) { item in
                    Text(item.name)
                    Text("\(item.type.rawValue)")
                }
            }
        }
    }
    private func info(_ vs: ViewStore<GTCommit, XS_Commit.Action>) -> some View {
        VStack(spacing: 2) {
            if let author = vs.author, let name = author.name {
                _Info(name: "Author & Committer") {
                    Text(name)
                }
            } else if let committer = vs.committer, let name = committer.name {
                _Info(name: "Author & Committer") {
                    Text(name)
                }
            }
            _Info(name: "Date") {
                Text(vs.commitDate, format: Date.FormatStyle())
            }
            _Info(name: "SHA") {
                Text(vs.sha)
            }
            if !vs.parents.isEmpty {
                _Info(name: "Parents") {
                    HStack {
                        ForEach(vs.parents, id: \.self) { item in
                            NavigationLink(value: XS_NavPathItem.commit(item)) {
                                Text(item.shortSHA)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct _Info<Content: View>: View {
    let name: String
    let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .foregroundColor(.gray.opacity(0.6))
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
    }
}

#if DEBUG
struct XS_CommitView_Previews: PreviewProvider {
    static var previews: some View {
        XS_CommitView(
            store: .init(initialState: .init(commit: try! XS_Git.shared.directorys.last!.repo.currentBranch().targetCommit())) {
                XS_Commit()
            }
        )
        .debugNav
    }
}
#endif
