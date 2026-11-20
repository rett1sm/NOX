import SwiftUI

@main
struct NoxApp: App {
    var body: some Scene {
        WindowGroup {
            NoxRootView()
                .preferredColorScheme(.dark)
        }
    }
}
