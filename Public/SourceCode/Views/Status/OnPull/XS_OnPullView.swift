//
//  XS_OnPullView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/25.
//

import SwiftUI
import ComposableArchitecture

struct XS_OnPullView: View {
    let store: StoreOf<XS_OnPull>
    var body: some View {
        NavigationStack {
            VStack {
                WithViewStore(store, observe: \.showType) { vs in
                    switch vs.state {
                    case let .pull(progress, size):
                        _pulling(progess: progress, size: size)
                    case .wait:
                        _wait
                    case let .error(value):
                        Text(value)
                            .foregroundColor(.red)
                        _pull
                    default:
                        _pull
                    }
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        store.send(.onCancel)
                    }
                }
            }
            .navigationTitle("Pull")
        }
    }
    private func _pulling(progess: String, size: String) -> some View {
        VStack(spacing: 20) {
            Text(progess)
                .font(.largeTitle)
            +
            Text(" %")
            Text("Pulling... (\(size))")
        }
        .padding(.bottom, 100)
    }
    private var _wait: some View {
        Text("waiting...")
            .padding(.bottom, 100)
    }
    private var _pull: some View {
        VStack {
            Text("Switch to the seleted remote")
                .frame(maxWidth: .infinity, alignment: .leading)
            _text.padding(.top)
            Spacer()
        }
    }
    private var _text: some View {
        VStack(alignment: .leading) {
            _menu.padding(.bottom)
            WithViewStore(store, observe: \.username) { vs in
                TextField("username", text: vs.bindingUsername)
            }
            WithViewStore(store, observe: \.password) { vs in
                SecureField("password", text: vs.bindingPassword)
            }
            Spacer()
            WithViewStore(store, observe: \.disabled) { vs in
                Button {
                    vs.send(.onPull)
                } label: {
                    Text("Pull")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .background(vs.state ? Color.gray.opacity(0.6) : Color.blue)
                        .clipShape(Capsule())
                }
                .disabled(vs.state)
            }
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .textFieldStyle(.roundedBorder)
    }
    private var _menu: some View {
        VStack {
            HStack {
                Text("Remote:")
                    .foregroundColor(.blue)
                WithViewStore(store, observe: \.remote) { vs in
                    Menu {
                        WithViewStore(store, observe: \.remoteNames) { vs in
                            ForEach(vs.state, id: \.self) { item in
                                Button(item) {
                                    vs.send(.setRemote(item))
                                }
                            }
                        }
                    } label: {
                        TextField("choose a remote", text: .constant(vs.state?.name ?? ""))
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            WithViewStore(store, observe: \.remote) { vs in
                if vs.state != nil {
                    HStack {
                        Text("Branch:")
                            .foregroundColor(.blue)
                        WithViewStore(store, observe: { ($0.branch, $0.currentBranchs) }, removeDuplicates: ==) { vs in
                            Menu {
                                ForEach(vs.1, id: \.self) { item in
                                    Button(item.shortName ?? "") {
                                        vs.send(.setBranch(item))
                                    }
                                }
                            } label: {
                                TextField("choose a branch", text: .constant(vs.0?.shortName ?? ""))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct XS_OnPullView_Previews: PreviewProvider {
    static var previews: some View {
        XS_OnPullView(
            store: .init(initialState: .init(repo: XS_Git.shared.directorys.last!.repo)) {
                XS_OnPull()
            }
        )
    }
}
#endif
