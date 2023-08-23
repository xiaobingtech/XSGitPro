//
//  XS_CloneView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/8.
//

import SwiftUI
import ComposableArchitecture

struct XS_CloneView: View {
    let store: StoreOf<XS_Clone>
    var body: some View {
        NavigationStack {
            VStack {
                WithViewStore(store, observe: \.showType) { vs in
                    switch vs.state {
                    case let .clone(progress, size):
                        _cloning(progess: progress, size: size)
                    case .wait:
                        _wait
                    case let .error(value):
                        Text(value)
                            .foregroundColor(.red)
                        _clone
                    default:
                        _clone
                    }
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel".i18n) {
                        store.send(.onCancel)
                    }
                }
            }
            .navigationTitle("Clone Repository".i18n)
        }
    }
    private func _cloning(progess: String, size: String) -> some View {
        VStack(spacing: 20) {
            Text(progess)
                .font(.largeTitle)
            +
            Text(" %")
            Text("Cloning...".i18n + " (\(size))")
        }
        .padding(.bottom, 100)
    }
    private var _wait: some View {
        Text("Waiting...".i18n)
            .padding(.bottom, 100)
    }
    private var _clone: some View {
        VStack {
            Text("Clone an existing repository".i18n)
                .frame(maxWidth: .infinity, alignment: .leading)
            _text.padding(.top)
            Spacer()
        }
    }
    private var _text: some View {
        VStack(alignment: .leading) {
            Text("URL".i18n)
                .foregroundColor(.blue)
            WithViewStore(store, observe: \.text) { vs in
                TextField(String("https://github.com/apple/swift.git"), text: vs.binding)
                    .padding(.bottom)
                WithViewStore(store, observe: \.username) { vs in
                    TextField("Username".i18n, text: vs.bindingUsername)
                }
                WithViewStore(store, observe: \.password) { vs in
                    SecureField("Password".i18n, text: vs.bindingPassword)
                }
                Spacer()
                Button {
                    vs.send(.onClone)
                } label: {
                    Text("Clone".i18n)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .background(vs.isEmpty ? Color.gray.opacity(0.6) : Color.blue)
                        .clipShape(Capsule())
                }
                .disabled(vs.isEmpty)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .textFieldStyle(.roundedBorder)
        }
    }
}

#if DEBUG
struct XS_CloneView_Previews: PreviewProvider {
    static var previews: some View {
        XS_CloneView(
            store: .init(initialState: .init()) {
                XS_Clone()
            }
        )
    }
}
#endif
