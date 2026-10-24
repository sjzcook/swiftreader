import XCTest
@testable import SwiftReaderCore

final class PlainTextBookParserTests: XCTestCase {
    func testBookProgressIsClamped() {
        XCTAssertEqual(Book(title: "A", progress: 2).progress, 1)
        XCTAssertEqual(Book(title: "B", progress: -1).progress, 0)
    }
}
