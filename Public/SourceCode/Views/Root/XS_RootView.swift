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
        XS_NavView()
            .xsMask(maskStore)
            .tint(.black)
            .accessibilityHidden(true)
//            .onAppear(perform: setupAppearance)
    }
    
    func setupAppearance() {
        // 避免 iOS15 的默认行为导致 NavigationBar 没有背景色
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        let titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.clear]
        navigationBarAppearance.backButtonAppearance.normal.titleTextAttributes = titleTextAttributes
        navigationBarAppearance.backButtonAppearance.highlighted.titleTextAttributes = titleTextAttributes
        navigationBarAppearance.backButtonAppearance.disabled.titleTextAttributes = titleTextAttributes
        navigationBarAppearance.backButtonAppearance.focused.titleTextAttributes = titleTextAttributes
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().isTranslucent = false
        
        // 避免 iOS15 的默认行为导致 TabBar 没有背景色
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().isTranslucent = false
        
        // 避免 iOS15 增加的列表顶部空白
        UITableView.appearance().sectionHeaderTopPadding = 0
    }
}
#if DEBUG
struct XS_RootView_Previews: PreviewProvider {
    static var previews: some View {
        XS_RootView()
    }
}
#endif
