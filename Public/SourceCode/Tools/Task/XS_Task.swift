//
//  XS_Task.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds duration: Double) async throws {
        try await sleep(nanoseconds: UInt64(duration*1000000000))
    }
}
