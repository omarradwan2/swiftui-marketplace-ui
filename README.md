# SwiftUI Marketplace UI

Open-source SwiftUI screens in the style of the marketplace apps I build at [Radwan Labs](https://radwanlabs.com). Sample data only: no backend, accounts or business logic.

**What's inside**
- **Grocery-app style feed:** a horizontal "best scores" shelf, deal cards, one-tap save with haptics, and sorting
- **Deal score:** the same idea I use in production: it grades a property A–D by all-in cost as a share of after-repair value (the 70% rule)
- **Swipe deck:** drag right to save and left to pass, with rotation, stamps, buttons and an "all caught up" state
- Accessible: VoiceOver reads each card as one element

**Run it** (Xcode 15+, iOS 17):
```bash
brew install xcodegen
xcodegen
open MarketplaceUI.xcodeproj
```

**Stack:** Swift 5.9 · SwiftUI · iOS 17 · XcodeGen

Built by [Omar Radwan](https://github.com/omarradwan2) · hello@radwanlabs.com
