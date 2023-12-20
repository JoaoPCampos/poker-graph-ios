//
//  PokerGraphApp.swift
//  PokerGraph
//
//  Created by João Campos on 16/12/2023.
//

import SwiftUI

@main
struct PokerGraphApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(DarkModeViewModifier())
        }
    }
}

public struct DarkModeViewModifier: ViewModifier {

public func body(content: Content) -> some View {
    content
        .environment(\.colorScheme, .dark)
        .preferredColorScheme(.dark)
    }
}
