import SwiftUI

/// Tinder-style triage: drag right to save, left to pass, with stamps and haptics.
struct SwipeScreen: View {
    @State private var deals: [Deal]
    @State private var index = 0
    @State private var drag: CGSize = .zero
    @State private var saved = 0

    init(deals: [Deal]) { _deals = State(initialValue: deals) }

    var body: some View {
        VStack(spacing: 20) {
            if index < deals.count {
                DealCard(deal: deals[index]) {}
                    .overlay(alignment: .topLeading) { if drag.width > 40 { stamp("SAVE", Palette.green) } }
                    .overlay(alignment: .topTrailing) { if drag.width < -40 { stamp("PASS", Palette.red) } }
                    .offset(x: drag.width)
                    .rotationEffect(.degrees(Double(drag.width / 20)))
                    .gesture(DragGesture()
                        .onChanged { drag = $0.translation }
                        .onEnded { v in
                            if abs(v.translation.width) > 110 { decide(v.translation.width > 0) }
                            else { withAnimation(.spring) { drag = .zero } }
                        })
                    .padding(.horizontal, 16)
                HStack(spacing: 40) {
                    round("xmark", Palette.red) { decide(false) }
                    round("heart.fill", Palette.green) { decide(true) }
                }
            } else {
                Image(systemName: "checkmark.seal.fill").font(.system(size: 56)).foregroundStyle(Palette.green)
                Text("All caught up · \(saved) saved").font(.title3.bold())
                Button("Start over") { index = 0; saved = 0 }
            }
        }
    }

    private func decide(_ keep: Bool) {
        if keep { saved += 1 }
        UIImpactFeedbackGenerator(style: keep ? .medium : .light).impactOccurred()
        withAnimation(.easeOut(duration: 0.25)) { drag = CGSize(width: keep ? 600 : -600, height: 0) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { index += 1; drag = .zero }
    }
    private func stamp(_ t: String, _ c: Color) -> some View {
        Text(t).font(.title.weight(.black)).foregroundStyle(c).padding(6)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(c, lineWidth: 4)).padding(20)
    }
    private func round(_ icon: String, _ c: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon).font(.title.weight(.bold)).foregroundStyle(c)
                .frame(width: 68, height: 68).background(Palette.surface, in: Circle())
        }
    }
}
