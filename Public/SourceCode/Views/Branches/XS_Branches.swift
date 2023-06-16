//
//  XS_Branches.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/15.
//

import Foundation
import ComposableArchitecture
import SwiftUI

extension ViewStore where ViewState == XS_Branches.State.SelectionType, ViewAction == XS_Branches.Action {
    var binding: Binding<ViewState> {
        binding(
            send: ViewAction.setSelection
        )
    }
}
extension GTBranch {
    var isCurrent: Bool {
        do {
            return try repository.currentBranch().isEqual(self)
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    var date: Date? {
        do {
            return try targetCommit().commitDate
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    var dateStr: String {
        guard let date = date else { return "未知" }
        let cale = Calendar.current
        let fm = DateFormatter()
        if cale.compare(date, to: Date(), toGranularity: .year) == .orderedSame {
            fm.dateFormat = "MM.dd"
        } else {
            fm.dateFormat = "yyyy.MM.dd"
        }
        return fm.string(from: date)
    }
}
extension XS_Branches.State {
    enum SelectionType: String {
        case Branches, Tags
        static var all: [SelectionType] {
            [.Branches, .Tags]
        }
    }
    var branches: (local: [GTBranch], remote: [GTBranch]) {
        do {
            return (
                try repo.localBranches(),
                try repo.remoteBranches()
            )
        } catch {
            debugPrint(error.localizedDescription)
            return ([], [])
        }
    }
    var tags: [GTTag] {
        do {
            return try repo.allTags().reversed()
        } catch {
            debugPrint(error.localizedDescription)
            return []
        }
    }
}

struct XS_Branches: ReducerProtocol {
    struct State: Equatable {
        let repo: GTRepository
        var selection: SelectionType = .Branches
    }
    enum Action {
        case setSelection(State.SelectionType)
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .setSelection(selection):
            state.selection = selection
            return .none
        }
    }
}
