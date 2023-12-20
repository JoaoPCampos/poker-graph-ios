//
//  ContentView.swift
//  PokerGraph
//
//  Created by João Campos on 16/12/2023.
//

import SwiftUI
import Charts

struct ContentView: View {

    @State private var animateChart = false

    @StateObject var fetcher = Fetcher()
    @State var winrate: Double = 0

    var body: some View {
        NavigationStack {
                VStack {
                    HStack {
                        Spacer()
                        Image("polarize")
                            .resizable()
                            .scaledToFill()
                            .frame(width:40, height: 40)
                        Spacer()
                        Text("€0.05/€0.10 NL Holdem")
                            .font(.headline.weight(.semibold))
                            .opacity(0.7)
                        Spacer()
                        Text("joCs")
                            .font(.headline.weight(.heavy))
                            .opacity(0.9)
                        Spacer()
                    }
                    Text("\(self.winrate, specifier: "%.2f") bb/100")
                        .foregroundStyle(.green.gradient)
                        .font(.body.weight(.bold))
                    if animateChart {
                        self.AnimatedChart()
                    }
                }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .top)
            .padding()
            .navigationTitle("")
            .onAppear {
                Task {
                    await self.fetcher.loadHands(for: .nl10)
                    self.animateChart = true
                }
            }
        }
    }

    @ViewBuilder
    func AnimatedChart() -> some View {
        let stops = [
            Gradient.Stop(color: .red, location: 0.0),
            Gradient.Stop(color: .orange, location: 0.25),
            Gradient.Stop(color: .yellow, location: 0.5),
            Gradient.Stop(color: .green, location: 0.65),
            Gradient.Stop(color: .green, location: 1.0)
        ]

        Chart {
            ForEach(self.fetcher.hands) { item in
                if item.animate {
                    LineMark(x: .value("Hands", item.hands.asDouble),
                             y: .value("Won", item.bbs.asDouble))
                    .foregroundStyle(.linearGradient(Gradient(stops: stops),
                                                     startPoint: .bottom,
                                                     endPoint: .top))
                }
            }
            .lineStyle(StrokeStyle(lineWidth: 2.5))
            .interpolationMethod(.linear)
        }
        .chartLegend(.visible)
        .chartYAxisLabel(position: .trailing, alignment: .center) {
            Text("Big Blinds")
                .font(.body.weight(.bold))
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Hands")
                .font(.body.weight(.bold))
        }
        .chartYScale(domain: 0...(self.fetcher.hands.last?.bbs.asDouble ?? 0)*1.1)
        .chartXScale(domain: 0...(self.fetcher.hands.last?.hands.asDouble ?? 0)*1.01)
        .chartLegend(position: .trailing, alignment: .top)
        .onAppear {
            for (index, session) in self.fetcher.hands.enumerated() {

                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.015) {
                    withAnimation(.linear) {
                        self.winrate = session.winrate
                        self.fetcher.hands[index].animate = true
                    }

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
