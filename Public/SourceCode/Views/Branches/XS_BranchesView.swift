//
//  XS_BranchesView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/15.
//

import SwiftUI
import ComposableArchitecture

struct XS_BranchesView: View {
    let store: StoreOf<XS_Branches>
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    var body: some View {
        _tabbar
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    _toolbarItem
                }
            }
    }
    private var _toolbarItem: some View {
        WithViewStore(store, observe: \.selection) { vs in
            _ItemView(current: vs.binding)
                .frame(width: screenWidth/2 + 82 - 15, alignment: .leading)
        }
    }
    
    private var _tabbar: some View {
        WithViewStore(store, observe: \.selection) { vs in
            TabView(selection: vs.binding) {
                _branches
                    .tag(XS_Branches.State.SelectionType.Branches)
                _tags
                    .tag(XS_Branches.State.SelectionType.Tags)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    private var _tags: some View {
        WithViewStore(store, observe: \.tags) { vs in
            List {
                Section {
                    if vs.state.isEmpty {
                        nullView("No branches")
                    } else {
                        ForEach(vs.state, id: \.self) { item in
                            Text(item.name)
                        }
                    }
                } header: {
                    Text("TAGS")
                }
            }
        }
    }
    private func _branch(_ item: GTBranch) -> some View {
        HStack {
            switch item.branchType {
            case .local:
                Text(item.name ?? "")
                    .background(
                        Color.blue
                            .cornerRadius(8)
                            .padding(-3)
                            .opacity(item.isCurrent ? 0.3 : 0)
                    )
            default:
                Text(item.name ?? "")
            }
//            Spacer()
//            Text(item.dateStr)
        }
    }
    private var _branches: some View {
        WithViewStore(store, observe: \.branches, removeDuplicates: ==) { vs in
            List {
                Section {
                    if vs.state.local.isEmpty {
                        nullView("No branches")
                    } else {
                        ForEach(vs.state.local, id: \.self) { item in
                            _branch(item)
                        }
                    }
                } header: {
                    Text("LOCAL BRANCHES")
                }
                Section {
                    if vs.state.remote.isEmpty {
                        nullView("No branches")
                    } else {
                        ForEach(vs.state.remote, id: \.self) { item in
                            _branch(item)
                        }
                    }
                } header: {
                    Text("REMOTE BRANCHES")
                }
            }
        }
    }
    private func nullView(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.gray.opacity(0.5))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct _ItemView: View {
    @Binding var current: XS_Branches.State.SelectionType
    private let all: [XS_Branches.State.SelectionType] = XS_Branches.State.SelectionType.all

    var body: some View {
        let index = all.firstIndex { $0 == current } ?? 0
        return ZStack(alignment: .leading) {
            Color.white
                .frame(width: 80, height: 30)
                .cornerRadius(8)
                .offset(x: Double(index)*80)
                .animation(.easeInOut, value: index)
            HStack(spacing: 0) {
                ForEach(all, id: \.self) { type in
                    Text(type.rawValue)
                        .frame(width: 80, height: 30)
                }
            }
        }
        .padding(2)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .onTapGesture {
            guard all.count > 0 else { return }
            if index < all.count - 1 {
                current = all[index + 1]
            } else {
                current = all[0]
            }
        }
    }
}

#if DEBUG
struct XS_BranchesView_Previews: PreviewProvider {
    static var previews: some View {
        XS_BranchesView(
            store: .init(initialState: .init(repo: XS_Git.shared.directorys.last!.repo)) {
                XS_Branches()
            }
        )
        .debugNav
    }
}
#endif
