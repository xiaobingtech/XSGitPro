//
//  XS_Directory.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/6.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == String?, ViewAction == XS_Directory.Action {
    var binding: Binding<String> {
        binding(
            get: { $0 ?? "" },
            send: ViewAction.setText
        )
    }
}

extension XS_Directory.State {
    struct Progess: Equatable {
        var progess: Double
        var text: String
    }
}

struct XS_Directory: ReducerProtocol {
    struct State: Equatable {
        var list: [XS_GitDirectory] = XS_Git.shared.directorys
        var text: String?
        var progess: Progess?
    }
    enum Action {
        case update
        case onAdd
        case onSure
        case onDismiss
        case changeProgess(Double, String)
        case setText(String)
        case clear
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .clear:
            state.text = nil
            state.progess = nil
            return .none
        case .update:
            state.list = XS_Git.shared.directorys
            return .none
        case .onAdd:
            state.progess = nil
            state.text = ""
            return .none
        case .onDismiss:
            state.text = nil
            return .none
        case .onSure:
            if let text = state.text, !text.isEmpty {
                state.progess = .init(progess: 0, text: "- KB")
                state.text = nil
                return .run { send in
                    let vs = ViewStore(maskStore.scopeActivity)
                    DispatchQueue.main.async {
                        vs.send(.show)
                    }
                    let repo = XS_Git.shared.clone(text) { pro in
                        if vs.isShow {
                            DispatchQueue.main.async {
                                vs.send(.hide)
                            }
                        }
                        DispatchQueue.main.async {
                            var kb = Double(pro.received_bytes)/1024.0
                            let unit: String
                            if kb < 1024 {
                                unit = "KB"
                            } else if kb < 1048576 {
                                unit = "MB"
                                kb /= 1024.0
                            } else {
                                unit = "GB"
                                kb /= 1048576.0
                            }
                            send(.changeProgess(
                                Double(pro.received_objects)/Double(pro.total_objects),
                                String(format: "%.2f ", kb) + unit
                            ))
                        }
                    }
                    if repo != nil {
                        await send(.update)
                    } else {
                        vs.send(.hide)
                    }
                    await send(.clear)
                }
            } else {
                state.text = nil
            }
            return .none
        case let .changeProgess(progress, text):
            state.progess?.progess = progress
            state.progess?.text = text
            return .none
        case let .setText(text):
            state.text = text
            return .none
        }
    }
}
