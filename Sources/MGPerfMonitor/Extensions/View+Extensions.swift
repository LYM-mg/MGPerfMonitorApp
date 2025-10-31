//
//  View+Extensions.swift
//  MobileDesign
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import Foundation
//import SwiftUI
//import SwiftUIIntrospect
//
//public struct GetHeightModifier: ViewModifier {
//    @Binding var height: CGFloat
//    
//    public init(height: Binding<CGFloat>) {
//        self._height = height
//    }
//
//    public func body(content: Content) -> some View {
//        content.background(
//            GeometryReader { geo -> Color in
//                DispatchQueue.main.async {
//                    height = geo.size.height
//                }
//                return Color.clear
//            }
//        )
//    }
//}
//
//extension View {
//    public func getHeight(_ height: Binding<CGFloat>) -> some View {
//        modifier(GetHeightModifier(height: height))
//    }
//}
//
//
//public struct ScrollViewRefreshableModifier: ViewModifier {
//    private var action: () async -> Void
//    private var refreshControl = UIRefreshControl()
//    
//    public init(_ action: @escaping () async -> Void) {
//        self.action = action
//    }
//    
//    private var refresh: UIAction {
//        UIAction { _ in Task { @MainActor [self] in
//                await self.action()
//                refreshControl.endRefreshing()
//            }
//        }
//    }
//    
//    public func body(content: Content) -> some View {
//        content
//            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18), customize: scrollView)
//    }
//    
//    private func scrollView(_ scrollView: UIScrollView) {
//        guard scrollView.refreshControl == nil else { return }
//        refreshControl.addAction(refresh, for: .valueChanged)
//        scrollView.refreshControl = refreshControl
//    }
//}
//
//extension View {
//    public func onRefresh(_ action: @escaping () async -> Void) -> some View {
//        modifier(ScrollViewRefreshableModifier(action))
//    }
//}
