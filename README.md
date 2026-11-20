# NOX

**NOX** is an iOS personalization hub focused on a deep-black OLED interface, selectable visual systems, custom colors, language switching, wallpapers, passcode-keypad design and system actions.

## Included in the first scaffold

- SwiftUI app shell for iOS 16+.
- Four selectable app styles: Liquid Glass, Material Design, OLED Black and Minimal.
- Persistent accent color, card radius, surface opacity and motion settings.
- Five interface languages: Russian, Ukrainian, Belarusian, English and Simplified Chinese.
- Local wallpaper library with import of images and videos from Files.
- Passcode keypad designer and in-app preview.
- Home-screen Respring action using the WebKit-based NeoSpring/Erosion approach, with a confirmation step.
- GitHub Actions workflow that builds an unsigned IPA on a macOS runner.

## Important implementation status

The appearance settings, translations, local media import and keypad preview are implemented in this scaffold. The keypad editor currently saves a preview configuration; it does **not** yet write to the iOS lock-screen passcode interface. Imported wallpaper files are stored in the app container; PosterBoard installation/injection is not yet connected. The tweak cards are a UI shell until the compatible system backend is integrated and verified.

Respring is wired to the WebKit method used by NeoSpring/Erosion. As with any process-pressure-based SpringBoard refresh method, behavior can vary by iOS build and should be tested on the target device with important data saved first.

## Backend direction

The intended system backend is based on the publicly documented Erosion project and its `worse_query` support range. Erosion's current README lists iOS/iPadOS 27.0–27.2.1 among supported versions; support depends on the exact OS build and may change when Apple patches the underlying technique. Do not assume a version is supported just because the app opens.

Before importing or adapting upstream implementation files, retain their upstream license and attribution. Erosion is GPL-3.0. NeoSpring credits @neonmodder123 for the WebKit respring method and @skadz108 for the Swift implementation.

## Build

The project uses XcodeGen. On macOS:

```sh
brew install xcodegen
xcodegen generate
xcodebuild -project NOX.xcodeproj -scheme NOX -sdk iphoneos -configuration Release CODE_SIGNING_ALLOWED=NO build
```

GitHub Actions runs the same build and uploads an unsigned IPA artifact.


## License and third-party code

NOX is distributed under GPL-3.0 because its respring component is adapted from Erosion. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for attribution and upstream links.
