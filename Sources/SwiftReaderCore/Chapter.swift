import Foundation

public struct Chapter: Identifiable, Hashable, Sendable {
    public let id: Int
    public var title: String
    public var content: String

    public init(id: Int, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
