//
//  PokerData.swift
//  PokerGraph
//
//  Created by João Campos on 17/12/2023.
//

import Combine
import SwiftUI
import Charts

struct PokerData: Identifiable, Decodable {

    enum Stakes: String, Decodable {

        case nl2 = "0.02"
        case nl5 = "0.05"
        case nl10 = "0.10"

        var asFloat: CGFloat {

            return self.rawValue.asCGFloat()
        }
    }

    private enum CodingKeys : String, CodingKey {

        case session
        case hands
        case won
        case ev
        case wonSD
        case wonNonSD
        case stakes
    }

    let id = UUID()
    let session: Date
    let hands: CGFloat
    let won: CGFloat
    let ev: CGFloat
    let wonSD: CGFloat
    let wonNonSD: CGFloat
    let stakes: Stakes

    let bbs: CGFloat
    let winrate: CGFloat

    var animate: Bool = false

    internal init(session: Date,
                  hands: CGFloat,
                  won: CGFloat,
                  ev: CGFloat,
                  wonSD: CGFloat,
                  wonNonSD: CGFloat,
                  stakes: Stakes) {

        self.session = session
        self.hands = hands
        self.won = won
        self.ev = ev
        self.wonSD = wonSD
        self.wonNonSD = wonNonSD
        self.stakes = stakes

        let bbs = won/stakes.asFloat
        self.bbs = bbs
        self.winrate = bbs/hands * 100
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.session = try container.decode(Date.self, forKey: .session)
        self.hands = try container.decode(CGFloat.self, forKey: .hands)
        self.won = try container.decode(CGFloat.self, forKey: .won)
        self.ev = try container.decode(CGFloat.self, forKey: .ev)
        self.wonSD = try container.decode(CGFloat.self, forKey: .wonSD)
        self.wonNonSD = try container.decode(CGFloat.self, forKey: .wonNonSD)
        self.stakes = try container.decode(Stakes.self, forKey: .stakes)

        let bbs = self.won/self.stakes.asFloat
        self.bbs = bbs
        self.winrate = bbs/hands * 100
    }

    func merge(to pokerData: PokerData) -> PokerData {

        return PokerData(session: pokerData.session,
                         hands: self.hands + pokerData.hands,
                         won: self.won + pokerData.won,
                         ev: self.ev + pokerData.ev,
                         wonSD: self.wonSD + pokerData.wonSD,
                         wonNonSD: self.wonNonSD + pokerData.wonNonSD,
                         stakes: pokerData.stakes)
    }

    private static func allHands() async -> [PokerData] {

        if let url = Bundle.main.url(forResource: "all_hands", withExtension: "json") {

                do {

                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)

                    let pokerData = try decoder.decode([PokerData].self, from: data)

                    return pokerData

                } catch {

                    print("error:\(error)")
                }
            }

            return []
    }

    static func loadHands(for stakes: Stakes) async -> [PokerData] {

        let final: [PokerData] = await Self.allHands().filter { $0.stakes == stakes }.reduce([]) { partialResult, element in

            var aux = partialResult

            if let last = partialResult.last {

                let new = last.merge(to: element)
                aux.append(new)

            } else {

                aux.append(element)
            }
            return aux
        }

        return final
    }
}
