import SwiftUI

/// Grocery-app style feed: a horizontal shelf on top, then cards with a one-tap save.
struct FeedScreen: View {
    @State private var deals = SampleData.deals
    @State private var sortByScore = false

    private var shown: [Deal] {
        sortByScore ? deals.sorted { ($0.score?.allInPctOfArv ?? 999) < ($1.score?.allInPctOfArv ?? 999) } : deals
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Best scores").font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(deals.filter { $0.score?.grade == "A" }) { d in MiniCard(deal: d) }
                    }
                }
                Toggle("Sort by deal score", isOn: $sortByScore.animation())
                ForEach(shown) { d in
                    DealCard(deal: d) { toggleSave(d) }
                }
            }
            .padding(16)
        }
        .navigationTitle("Deals")
    }

    private func toggleSave(_ d: Deal) {
        guard let i = deals.firstIndex(of: d) else { return }
        deals[i].saved.toggle()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

struct DealCard: View {
    var deal: Deal
    var onSave: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                LinearGradient(colors: [Palette.green.opacity(0.35), .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 150).clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(Image(systemName: "house.fill").font(.largeTitle).foregroundStyle(.white.opacity(0.3)))
                Button(action: onSave) {
                    Image(systemName: deal.saved ? "heart.fill" : "heart")
                        .foregroundStyle(deal.saved ? Palette.red : .white)
                        .frame(width: 38, height: 38).background(.black.opacity(0.45), in: Circle())
                }.padding(8).accessibilityLabel(deal.saved ? "Remove from saved" : "Save")
            }
            HStack {
                Text(usd(deal.priceUsd)).font(.title3.bold().monospacedDigit())
                Spacer()
                if let s = deal.score { GradePill(grade: s.grade) }
            }
            Text(deal.title).font(.subheadline.weight(.semibold))
            Text("\(deal.city), \(deal.state) · listed \(deal.listedAt.formatted(.relative(presentation: .named)))")
                .font(.caption).foregroundStyle(Palette.muted)
            if let s = deal.spreadUsd {
                Text("Spread \(usd(s))").font(.caption.weight(.bold)).foregroundStyle(s > 0 ? Palette.green : Palette.red)
            }
        }
        .padding(12)
        .background(Palette.surface, in: RoundedRectangle(cornerRadius: 18))
        .accessibilityElement(children: .combine)
    }
}

struct MiniCard: View {
    var deal: Deal
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(usd(deal.priceUsd)).font(.headline.monospacedDigit())
            Text(deal.city).font(.caption).foregroundStyle(Palette.muted)
            if let s = deal.score { GradePill(grade: s.grade) }
        }
        .padding(12).frame(width: 140, alignment: .leading)
        .background(Palette.surface, in: RoundedRectangle(cornerRadius: 14))
    }
}

struct GradePill: View {
    var grade: String
    var body: some View {
        Text("Grade \(grade)").font(.caption.weight(.bold)).padding(.horizontal, 8).padding(.vertical, 3)
            .background((grade == "A" ? Palette.green : grade == "B" ? Color.blue : grade == "C" ? Palette.amber : Palette.red).opacity(0.25), in: Capsule())
    }
}
