//
//  XS_RootView.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/5/5.
//

import SwiftUI
import ComposableArchitecture

struct XS_RootView: View {
    var body: some View {
        Group {
            if UIDevice.isPad {
                XS_PadCodeView()
            } else {
                XS_NavView()
            }
        }
        .xsMask(maskStore)
        .tint(.black)
        .accessibilityHidden(true)
    }
}

#if DEBUG
struct XS_RootView_Previews: PreviewProvider {
    static var previews: some View {
        XS_RootView()
    }
}
#endif
