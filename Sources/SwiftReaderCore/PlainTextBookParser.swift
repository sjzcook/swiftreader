import Foundation

public enum BookImportError: Error, LocalizedError {
    case unsupportedFormat
    case unreadableFile

    public var errorDescription: String? {
        switch self {
        case .unsupportedFormat: return "暂不支持此文件格式。"
        case .unreadableFile: return "无法读取文件内容。"
        }
    }
}

/// Minimal local TXT importer. EPUB parsing can be added behind the same interface.
public enum PlainTextBookParser {
    public static func parse(url: URL) throws -> (title: String, text: String) {
        guard url.pathExtension.lowercased() == "txt" else {
            throw BookImportError.unsupportedFormat
        }

        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess { url.stopAccessingSecurityScopedResource() }
        }

        guard let text = try? String(contentsOf: url, encoding: .utf8) else {
            if let text = try? String(contentsOf: url, encoding: .utf16) {
                return (url.deletingPathExtension().lastPathComponent, text)
            }
            throw BookImportError.unreadableFile
        }
        return (url.deletingPathExtension().lastPathComponent, text)
    }
}
