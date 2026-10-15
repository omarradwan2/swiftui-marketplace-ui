import Foundation

struct Deal: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var city: String
    var state: String
    var priceUsd: Int
    var arvUsd: Int?
    var repairsUsd: Int?
    var listedAt: Date
    var saved = false

    var spreadUsd: Int? { arvUsd.map { $0 - priceUsd - (repairsUsd ?? 0) } }
    var score: DealScore? { DealScore(price: priceUsd, arv: arvUsd, repairs: repairsUsd) }
}

/// A simple A–D grade from all-in cost as a share of after-repair value (the "70% rule").
struct DealScore: Hashable {
    let grade: String
    let allInPctOfArv: Int

    init?(price: Int, arv: Int?, repairs: Int?) {
        guard let arv, arv > 0, price > 0 else { return nil }
        let pct = Int((Double(price + max(0, repairs ?? 0)) / Double(arv) * 100).rounded())
        allInPctOfArv = pct
        grade = pct <= 65 ? "A" : pct <= 75 ? "B" : pct <= 85 ? "C" : "D"
    }
}

func usd(_ n: Int) -> String { n.formatted(.currency(code: "USD").precision(.fractionLength(0))) }

enum SampleData {
    static let deals: [Deal] = [
        Deal(title: "3/2 brick ranch, needs cosmetics", city: "Tyler", state: "TX", priceUsd: 142_000, arvUsd: 235_000, repairsUsd: 28_000, listedAt: .now.addingTimeInterval(-3_600)),
        Deal(title: "Duplex, both units rented", city: "Memphis", state: "TN", priceUsd: 118_000, arvUsd: 170_000, repairsUsd: 12_000, listedAt: .now.addingTimeInterval(-86_400)),
        Deal(title: "Full rehab on a corner lot", city: "Birmingham", state: "AL", priceUsd: 64_000, arvUsd: 160_000, repairsUsd: 45_000, listedAt: .now.addingTimeInterval(-7_200)),
        Deal(title: "Turnkey 4/2 near schools", city: "Wichita Falls", state: "TX", priceUsd: 189_000, arvUsd: 230_000, repairsUsd: 5_000, listedAt: .now.addingTimeInterval(-172_800)),
    ]
}
