import Foundation
import UniformTypeIdentifiers

struct WallpaperFile: Identifiable, Hashable {
    let url: URL
    var id: String { url.lastPathComponent }
    var isVideo: Bool {
        ["mov", "mp4", "m4v"].contains(url.pathExtension.lowercased())
    }
}

enum WallpaperLibrary {
    static var directory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("NoxWallpapers", isDirectory: true)
    }

    static func allFiles() -> [WallpaperFile] {
        guard let urls = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }
        return urls.map(WallpaperFile.init(url:)).sorted { $0.url.lastPathComponent < $1.url.lastPathComponent }
    }

    static func importFiles(_ urls: [URL]) throws -> [WallpaperFile] {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        var imported: [WallpaperFile] = []
        for source in urls {
            let didStart = source.startAccessingSecurityScopedResource()
            defer { if didStart { source.stopAccessingSecurityScopedResource() } }

            let safeName = source.lastPathComponent
            var destination = directory.appendingPathComponent(safeName)
            if FileManager.default.fileExists(atPath: destination.path) {
                let suffix = UUID().uuidString.prefix(8)
                destination = directory.appendingPathComponent("\(suffix)-\(safeName)")
            }
            try FileManager.default.copyItem(at: source, to: destination)
            imported.append(WallpaperFile(url: destination))
        }
        return imported
    }

    static func delete(_ file: WallpaperFile) throws {
        try FileManager.default.removeItem(at: file.url)
    }
}
