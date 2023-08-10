//
//  XS_Search.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/16.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == String, ViewAction == XS_Search.Action {
    var binding: Binding<ViewState> {
        binding(send: ViewAction.setText)
    }
}

struct XS_Search: Reducer {
    struct State: Equatable {
        let entries: [Entry]
        var text: String = ""
        var list: [Entry]
        struct Entry: Equatable, Identifiable {
            var id: GTOID { entry.oid }
            var name: String
            var entry: GTIndexEntry
        }
        init(_ entries: [GTIndexEntry]) {
            self.entries = entries.compactMap {
                guard let name = $0.path.components(separatedBy: "/").last else { return nil }
                return Entry(name: name, entry: $0)
            }
            list = self.entries
        }
    }
    enum Action {
        case setText(String)
        case onCancel
    }
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onCancel:
            state.text = ""
            state.list = state.entries
            return .none
        case let .setText(value):
            state.text = value
            if value.isEmpty {
                state.list = state.entries
            } else {
                state.list = state.entries.filter {
                    $0.name.contains(value)
                }
            }
            return .none
        }
    }
}


