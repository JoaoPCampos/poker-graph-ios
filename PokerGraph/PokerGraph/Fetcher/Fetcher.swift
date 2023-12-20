//
//  Fetcher.swift
//  PokerGraph
//
//  Created by João Campos on 19/12/2023.
//

import Foundation

@MainActor
class Fetcher: ObservableObject {

    @Published var hands: [PokerData] = []

    func loadHands(for stakes: PokerData.Stakes) async {

        self.hands = await PokerData.loadHands(for: stakes)
    }
}
