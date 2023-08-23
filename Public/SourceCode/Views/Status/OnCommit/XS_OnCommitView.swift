//
//  XS_OnCommitView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import SwiftUI
import ComposableArchitecture

struct XS_OnCommitView: View {
    let store: StoreOf<XS_OnCommit>
    @FocusState private var focused: Bool
    private func typeStr(_ type: GTDeltaType) -> String {
        switch type {
        case .unmodified: return "Unmodified"
        case .added: return "Added"
        case .deleted: return "Deleted"
        case .modified: return "Modified"
        case .renamed: return "Renamed"
        case .copied: return "Copied"
        case .ignored: return "Ignored"
        case .untracked: return "Untracked"
        case .typeChange: return "TypeChange"
        case .unreadable: return "Unreadable"
        case .conflicted: return "Conflicted"
        @unknown default: return ""
        }
    }
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create a commit with staged changes")
                    .frame(maxWidth: .infinity, alignment: .leading)
                _message
                _list
                _button
            }
            .padding(.horizontal)
            .background(Color.white)
            .onTapGesture {
                focused = false
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        store.send(.onCancel)
                    }
                }
            }
            .navigationTitle("Commit")
        }
    }
    private var _message: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Message")
            WithViewStore(store, observe: \.text) { vs in
                TextEditor(text: vs.binding)
            }
            .cornerRadius(5)
            .focused($focused)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .frame(height: 200)
    }
    private var _list: some View {
        ScrollView {
            VStack {
                _header
                _deltas
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
    private var _header: some View {
        HStack {
            Text("Files to Commit")
            Spacer()
            WithViewStore(store, observe: \.str) { vs in
                Text(vs.state)
            }
        }
    }
    private var _deltas: some View {
        WithViewStore(store, observe: \.deltas) { vs in
            ForEach(vs.state, id: \.self) { item in
                Divider()
                HStack {
                    if let file = item.newFile {
                        Text(file.path)
                    } else if let file = item.oldFile {
                        Text(file.path)
                    }
                    Spacer()
                    Text(typeStr(item.type))
                        .font(.footnote)
                }
            }
        }
    }
    private var _button: some View {
        WithViewStore(store, observe: \.isError) { vs in
            Button {
                vs.send(.onCommit)
            } label: {
                Text("Commit")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(vs.state ? Color.gray.opacity(0.6) : Color.blue)
                    .clipShape(Capsule())
            }
            .disabled(vs.state)
        }
    }
}
#if DEBUG
struct XS_OnCommitView_Previews: PreviewProvider {
    static var previews: some View {
        XS_OnCommitView(
            store: .init(initialState: .init(repo: XS_Git.shared.directorys.last!.repo)) {
                XS_OnCommit()
            }
        )
    }
}
#endif
