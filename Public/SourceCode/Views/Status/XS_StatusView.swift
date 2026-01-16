//
//  XS_StatusView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import SwiftUI
import ComposableArchitecture

struct XS_StatusView: View {
    let store: StoreOf<XS_Status>
    private let buttonSpacing: CGFloat = 12
    private let buttonHeight: CGFloat = 50

    var body: some View {
        List {
            // CURRENT BRANCH Section
            Section {
                WithViewStore(store, observe: \.repo) { vs in
                    VStack(alignment: .leading, spacing: 12) {
                        // Current Branch Name
                        Group {
                            if let branchName = getCurrentBranchName(vs.state) {
                                Text(branchName)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.blue)
                            } else {
                                Text("Unknown Branch")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .cornerRadius(10)
                        .allowsHitTesting(false)

                        // Action Buttons
                        HStack(spacing: buttonSpacing) {
                            actionButton(title: "Commit".i18n) {
                                store.send(.onCommit)
                            }
                            actionButton(title: "Pull".i18n) {
                                store.send(.onPull)
                            }
                            actionButton(title: "Push".i18n) {
                                store.send(.onPush)
                            }
                        }
                    }
                    .padding(.horizontal, buttonSpacing)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            } header: {
                Text("CURRENT BRANCH")
            }

            // STAGED CHANGES Section
            Section {
                Text("Staged changes will appear here")
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } header: {
                Text("STAGED CHANGES")
            }

            // UNSTAGED CHANGES Section
            Section {
                Text("Unstaged changes will appear here")
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } header: {
                Text("UNSTAGED CHANGES")
            }
        }
        .sheet(store: store.scopeCommit) { store in
            XS_OnCommitView(store: store)
        }
        .sheet(store: store.scopePull) { store in
            XS_OnPullView(store: store)
        }
        .sheet(store: store.scopePush) { store in
            XS_OnPushView(store: store)
        }
    }

    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: buttonHeight)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .allowsHitTesting(true)
    }

    private func getCurrentBranchName(_ repo: GTRepository) -> String? {
        do {
            let branch = try repo.currentBranch()
            return branch.shortName ?? branch.name
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}

#if DEBUG
struct XS_StatusView_Previews: PreviewProvider {
    static var previews: some View {
        XS_StatusView(
            store: .init(initialState: .init(repo: XS_Git.shared.directorys.last!.repo)) {
                XS_Status()
            }
        ).debugNav
    }
}
#endif
