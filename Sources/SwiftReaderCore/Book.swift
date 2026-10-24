import Foundation

public struct Book: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var author: String
    public var fileURL: URL?
    public var progress: Double
    public var lastOpenedAt: Date?

    public init(
        id: UUID = UUID(),
        title: String,
        author: String = "未知作者",
        fileURL: URL? = nil,
        progress: Double = 0,
        lastOpenedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.fileURL = fileURL
        self.progress = min(max(progress, 0), 1)
        self.lastOpenedAt = lastOpenedAt
    }
}
