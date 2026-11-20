import SwiftUI
import UniformTypeIdentifiers
import UIKit

struct NoxRootView: View {
    @AppStorage("nox.design") private var designRaw = NoxDesign.liquidGlass.rawValue
    @AppStorage("nox.accent") private var accentHex = NoxAccent.violet.rawValue
    @AppStorage("nox.radius") private var radius = 24.0
    @AppStorage("nox.opacity") private var opacity = 0.92
    @AppStorage("nox.language") private var languageRaw = NoxLanguage.russian.rawValue
    @AppStorage("nox.motion") private var motionEnabled = true
    @State private var runRespring = false

    private var language: String { languageRaw }
    private var theme: NoxTheme {
        NoxTheme(
            design: NoxDesign(rawValue: designRaw) ?? .liquidGlass,
            accent: Color(hex: accentHex),
            cornerRadius: radius,
            opacity: opacity
        )
    }

    var body: some View {
        TabView {
            HomeView(theme: theme, language: language, motionEnabled: motionEnabled, runRespring: $runRespring)
                .tabItem { Label(L10n.text("tab.home", language: language), systemImage: "house.fill") }
            TweaksView(theme: theme, language: language)
                .tabItem { Label(L10n.text("tab.tweaks", language: language), systemImage: "slider.horizontal.3") }
            WallpapersView(theme: theme, language: language)
                .tabItem { Label(L10n.text("tab.wallpapers", language: language), systemImage: "play.rectangle.on.rectangle") }
            PasscodeDesignerView(theme: theme, language: language)
                .tabItem { Label(L10n.text("tab.passcode", language: language), systemImage: "circle.grid.3x3.fill") }
            SettingsView(theme: theme, language: language)
                .tabItem { Label(L10n.text("tab.settings", language: language), systemImage: "gearshape.fill") }
        }
        .tint(theme.accent)
        .preferredColorScheme(.dark)
        .overlay {
            if runRespring {
                // Keep the WebKit refresh surface at the app-window level.
                RespringRunner()
                    .brightness(-1.0)
                    .ignoresSafeArea()
            }
        }
    }
}

// MARK: - Shared UI

private struct PageBackground: View {
    let theme: NoxTheme
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            if theme.design == .liquidGlass {
                RadialGradient(colors: [theme.accent.opacity(0.18), .clear], center: .topTrailing, startRadius: 12, endRadius: 420)
                    .ignoresSafeArea()
            }
        }
    }
}

private struct SectionHeading: View {
    let title: String
    var detail: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.title3.weight(.bold)).foregroundStyle(.white)
            if let detail {
                Text(detail).font(.footnote).foregroundStyle(.white.opacity(0.55))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 5)
    }
}

private struct FeatureTile: View {
    let icon: String
    let title: String
    let subtitle: String
    let theme: NoxTheme
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2.weight(.semibold))
                .foregroundStyle(theme.accent)
                .frame(width: 42, height: 42)
                .background(theme.accent.opacity(0.14), in: RoundedRectangle(cornerRadius: 14))
            Text(title).font(.headline).foregroundStyle(.white)
            Text(subtitle).font(.caption).foregroundStyle(.white.opacity(0.52)).fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 116, alignment: .leading)
        .noxCard(theme, padding: 14)
    }
}

// MARK: - Home

private struct HomeView: View {
    let theme: NoxTheme
    let language: String
    let motionEnabled: Bool
    @State private var showingRespringConfirm = false
    @Binding var runRespring: Bool

    private func t(_ key: String) -> String { L10n.text(key, language: language) }

    var body: some View {
        NavigationStack {
            ZStack {
                PageBackground(theme: theme)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(t("home.eyebrow"))
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .tracking(2.1)
                                .foregroundStyle(theme.accent)
                            Text(t("home.title"))
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(t("home.subtitle"))
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.58))
                        }
                        .padding(.top, 12)
                        .transition(motionEnabled ? .opacity.combined(with: .move(edge: .top)) : .identity)

                        HStack(spacing: 12) {
                            Image(systemName: "iphone.gen3")
                                .font(.title2)
                                .foregroundStyle(theme.accent)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(t("home.environment")).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                                Text(t("home.backendPending")).font(.caption).foregroundStyle(.white.opacity(0.52))
                            }
                            Spacer()
                            Circle().fill(Color.orange).frame(width: 7, height: 7)
                        }
                        .noxCard(theme)

                        SectionHeading(title: t("home.quick"))
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            FeatureTile(icon: "slider.horizontal.3", title: t("tab.tweaks"), subtitle: t("tweaks.subtitle"), theme: theme)
                            FeatureTile(icon: "sparkles.tv", title: t("tab.wallpapers"), subtitle: t("wallpapers.subtitle"), theme: theme)
                            FeatureTile(icon: "circle.grid.3x3.fill", title: t("tab.passcode"), subtitle: t("passcode.subtitle"), theme: theme)
                            FeatureTile(icon: "paintpalette.fill", title: t("settings.appearance"), subtitle: t("settings.design"), theme: theme)
                        }

                        Button { showingRespringConfirm = true } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title2.weight(.bold))
                                    .frame(width: 48, height: 48)
                                    .background(.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 16))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(t("home.respring")).font(.headline.weight(.bold))
                                    Text(t("home.respringInfo")).font(.caption).opacity(0.75)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").font(.footnote.weight(.bold)).opacity(0.7)
                            }
                            .foregroundStyle(.white)
                            .padding(14)
                            .background(LinearGradient(colors: [theme.accent, theme.accent.opacity(0.68)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint(t("home.respringInfo"))
                        .padding(.top, 2)
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 28)
                }
            }
            .navigationTitle("NOX")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog(t("respring.confirmTitle"), isPresented: $showingRespringConfirm, titleVisibility: .visible) {
                Button(t("common.continue"), role: .destructive) { runRespring = true }
                Button(t("common.cancel"), role: .cancel) { }
            } message: {
                Text(t("respring.confirmBody"))
            }
        }
    }
}

// MARK: - Tweaks

private struct TweakModule: Identifiable {
    let icon: String
    let titleKey: String
    let detailKey: String
    var id: String { titleKey }
}

private struct TweaksView: View {
    let theme: NoxTheme
    let language: String
    private func t(_ key: String) -> String { L10n.text(key, language: language) }

    private let modules: [TweakModule] = [
        TweakModule(icon: "lock.fill", titleKey: "tweaks.lock", detailKey: "tweaks.lockDetail"),
        TweakModule(icon: "circle.grid.3x3.fill", titleKey: "tweaks.passcode", detailKey: "tweaks.passcodeDetail"),
        TweakModule(icon: "app.dashed", titleKey: "tweaks.icons", detailKey: "tweaks.iconsDetail"),
        TweakModule(icon: "hand.tap.fill", titleKey: "tweaks.gestures", detailKey: "tweaks.gesturesDetail")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                PageBackground(theme: theme)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeading(title: t("tweaks.title"), detail: t("tweaks.subtitle"))
                        ForEach(modules) { module in
                            HStack(spacing: 14) {
                                Image(systemName: module.icon)
                                    .font(.title3)
                                    .foregroundStyle(theme.accent)
                                    .frame(width: 44, height: 44)
                                    .background(theme.accent.opacity(0.13), in: RoundedRectangle(cornerRadius: 14))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(t(module.titleKey)).font(.headline).foregroundStyle(.white)
                                    Text(t(module.detailKey)).font(.caption).foregroundStyle(.white.opacity(0.5))
                                }
                                Spacer(minLength: 4)
                                Text(t("tweaks.pending"))
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.orange)
                                    .padding(.horizontal, 8).padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.12), in: Capsule())
                            }
                            .noxCard(theme)
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle(t("tab.tweaks"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Wallpapers

private struct WallpapersView: View {
    let theme: NoxTheme
    let language: String
    @State private var files: [WallpaperFile] = []
    @State private var showImporter = false
    @State private var importError: String?
    private func t(_ key: String) -> String { L10n.text(key, language: language) }

    var body: some View {
        NavigationStack {
            ZStack {
                PageBackground(theme: theme)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeading(title: t("wallpapers.title"), detail: t("wallpapers.subtitle"))
                        Button { showImporter = true } label: {
                            Label(t("wallpapers.import"), systemImage: "plus.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(theme.accent, in: RoundedRectangle(cornerRadius: theme.cornerRadius))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)

                        if files.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "photo.stack").font(.system(size: 34)).foregroundStyle(theme.accent.opacity(0.8))
                                Text(t("wallpapers.empty")).font(.headline).foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 48).noxCard(theme)
                        } else {
                            ForEach(files) { file in
                                HStack(spacing: 12) {
                                    Image(systemName: file.isVideo ? "film" : "photo")
                                        .font(.title2).foregroundStyle(theme.accent)
                                        .frame(width: 44, height: 44)
                                        .background(theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 13))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(file.url.lastPathComponent).font(.subheadline.weight(.semibold)).foregroundStyle(.white).lineLimit(1)
                                        Text(file.isVideo ? "VIDEO" : "IMAGE").font(.caption2.weight(.bold)).tracking(1.4).foregroundStyle(.white.opacity(0.42))
                                    }
                                    Spacer()
                                    Button(role: .destructive) {
                                        try? WallpaperLibrary.delete(file)
                                        reload()
                                    } label: {
                                        Image(systemName: "trash").foregroundStyle(.red.opacity(0.85))
                                    }
                                    .buttonStyle(.plain)
                                }
                                .noxCard(theme, padding: 12)
                            }
                        }
                        if let importError {
                            Text(importError).font(.caption).foregroundStyle(.red)
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle(t("tab.wallpapers"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: reload)
            .fileImporter(isPresented: $showImporter, allowedContentTypes: [.image, .movie], allowsMultipleSelection: true) { result in
                do {
                    let urls = try result.get()
                    _ = try WallpaperLibrary.importFiles(urls)
                    importError = nil
                    reload()
                } catch {
                    importError = error.localizedDescription
                }
            }
        }
    }

    private func reload() { files = WallpaperLibrary.allFiles() }
}

// MARK: - Passcode designer

private struct PasscodeDesignerView: View {
    let theme: NoxTheme
    let language: String
    @AppStorage("nox.passcode.accent") private var keypadAccent = "8B5CF6"
    @AppStorage("nox.passcode.style") private var keypadStyle = "glass"
    @State private var showingSaved = false
    private func t(_ key: String) -> String { L10n.text(key, language: language) }

    private let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "•", "0", "⌫"]

    var body: some View {
        NavigationStack {
            ZStack {
                PageBackground(theme: theme)
                ScrollView {
                    VStack(spacing: 18) {
                        SectionHeading(title: t("passcode.title"), detail: t("passcode.subtitle"))

                        VStack(spacing: 20) {
                            HStack(spacing: 12) {
                                ForEach(0..<4, id: \.self) { _ in
                                    Circle().stroke(Color.white.opacity(0.7), lineWidth: 1.2).frame(width: 9, height: 9)
                                }
                            }
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 14) {
                                ForEach(digits, id: \.self) { digit in
                                    Text(digit)
                                        .font(.system(size: digit == "⌫" ? 20 : 25, weight: .light, design: .rounded))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .background {
                                            Circle().fill(keypadStyle == "glass" ? Color.white.opacity(0.11) : Color(hex: keypadAccent).opacity(keypadStyle == "solid" ? 0.92 : 0.22))
                                                .overlay(Circle().stroke(Color.white.opacity(keypadStyle == "glass" ? 0.2 : 0.06), lineWidth: 1))
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 24).padding(.vertical, 22)
                        .background(Color.black.opacity(0.32), in: RoundedRectangle(cornerRadius: 32))
                        .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.white.opacity(0.07)))

                        VStack(alignment: .leading, spacing: 14) {
                            Text(t("settings.accent")).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                            HStack(spacing: 12) {
                                ForEach(NoxAccent.allCases) { item in
                                    Circle().fill(item.color).frame(width: 30, height: 30)
                                        .overlay(Circle().stroke(Color.white, lineWidth: keypadAccent == item.rawValue ? 2 : 0).padding(-4))
                                        .onTapGesture { keypadAccent = item.rawValue }
                                }
                            }
                            Text(t("passcode.buttonStyle")).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                            Picker(t("passcode.buttonStyle"), selection: $keypadStyle) {
                                Text(t("passcode.glass")).tag("glass")
                                Text(t("passcode.soft")).tag("soft")
                                Text(t("passcode.solid")).tag("solid")
                            }
                            .pickerStyle(.segmented)
                            Text(t("passcode.note")).font(.caption).foregroundStyle(.white.opacity(0.52))
                        }
                        .noxCard(theme)

                        Button { showingSaved = true } label: {
                            Text(t("common.save")).font(.headline).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 14)
                                .background(theme.accent, in: RoundedRectangle(cornerRadius: theme.cornerRadius))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(18)
                }
            }
            .navigationTitle(t("tab.passcode"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(t("common.save"), isPresented: $showingSaved) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(t("passcode.note"))
            }
        }
    }
}

// MARK: - Settings

private struct SettingsView: View {
    let theme: NoxTheme
    let language: String
    @AppStorage("nox.design") private var designRaw = NoxDesign.liquidGlass.rawValue
    @AppStorage("nox.accent") private var accentHex = NoxAccent.violet.rawValue
    @AppStorage("nox.radius") private var radius = 24.0
    @AppStorage("nox.opacity") private var opacity = 0.92
    @AppStorage("nox.language") private var languageRaw = NoxLanguage.russian.rawValue
    @AppStorage("nox.motion") private var motionEnabled = true
    private func t(_ key: String) -> String { L10n.text(key, language: language) }

    var body: some View {
        NavigationStack {
            ZStack {
                PageBackground(theme: theme)
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        SectionHeading(title: t("settings.appearance"))
                        VStack(alignment: .leading, spacing: 14) {
                            Text(t("settings.design")).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                            ForEach(NoxDesign.allCases) { design in
                                Button { designRaw = design.rawValue } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: design == .liquidGlass ? "drop.halffull" : design == .material ? "square.stack.3d.up.fill" : design == .oled ? "circle.lefthalf.filled" : "circle.grid.2x2")
                                            .font(.title3).foregroundStyle(theme.accent).frame(width: 38)
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(design.title).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                                            Text(t(design.subtitleKey)).font(.caption).foregroundStyle(.white.opacity(0.48))
                                        }
                                        Spacer()
                                        if designRaw == design.rawValue {
                                            Image(systemName: "checkmark.circle.fill").foregroundStyle(theme.accent)
                                        }
                                    }
                                    .padding(10)
                                    .background(Color.white.opacity(designRaw == design.rawValue ? 0.08 : 0.025), in: RoundedRectangle(cornerRadius: 14))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .noxCard(theme)

                        VStack(alignment: .leading, spacing: 14) {
                            Text(t("settings.accent")).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                            HStack(spacing: 13) {
                                ForEach(NoxAccent.allCases) { accent in
                                    Circle().fill(accent.color).frame(width: 28, height: 28)
                                        .overlay(Circle().stroke(Color.white, lineWidth: accentHex == accent.rawValue ? 2 : 0).padding(-4))
                                        .onTapGesture { accentHex = accent.rawValue }
                                }
                            }
                            Divider().overlay(Color.white.opacity(0.1))
                            VStack(alignment: .leading, spacing: 8) {
                                HStack { Text(t("settings.radius")); Spacer(); Text("\(Int(radius)) pt").foregroundStyle(.white.opacity(0.5)) }
                                Slider(value: $radius, in: 12...32, step: 1).tint(theme.accent)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                HStack { Text(t("settings.opacity")); Spacer(); Text("\(Int(opacity * 100))%").foregroundStyle(.white.opacity(0.5)) }
                                Slider(value: $opacity, in: 0.35...1).tint(theme.accent)
                            }
                        }
                        .font(.subheadline.weight(.medium)).foregroundStyle(.white)
                        .noxCard(theme)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(t("settings.language")).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                            ForEach(NoxLanguage.allCases) { item in
                                Button { languageRaw = item.rawValue } label: {
                                    HStack {
                                        Text(item.nativeName).foregroundStyle(.white)
                                        Spacer()
                                        if languageRaw == item.rawValue { Image(systemName: "checkmark.circle.fill").foregroundStyle(theme.accent) }
                                    }
                                    .padding(.vertical, 5)
                                }
                                .buttonStyle(.plain)
                            }
                            Toggle(t("settings.motion"), isOn: $motionEnabled).tint(theme.accent)
                        }
                        .noxCard(theme)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(t("settings.access")).font(.headline).foregroundStyle(.white)
                            HStack(spacing: 10) {
                                Image(systemName: "folder").foregroundStyle(theme.accent)
                                Text(t("settings.filesAccess")).foregroundStyle(.white)
                                Spacer()
                                Text(t("settings.selectedOnly"))
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.green)
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "lock.slash").foregroundStyle(.orange)
                                Text(t("settings.systemAccess")).foregroundStyle(.white)
                                Spacer()
                                Text(t("settings.notConnected"))
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.orange)
                            }
                            Text(t("settings.accessNote"))
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.52))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .noxCard(theme)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(t("settings.about")).font(.headline).foregroundStyle(.white)
                            Text(t("settings.aboutText")).font(.caption).foregroundStyle(.white.opacity(0.55))
                            Text("NOX · 0.1.0 DEV").font(.system(size: 10, weight: .bold, design: .monospaced)).tracking(1.8).foregroundStyle(theme.accent).padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .noxCard(theme)
                    }
                    .padding(18)
                }
            }
            .navigationTitle(t("tab.settings"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NoxRootView()
}
