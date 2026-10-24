// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftReaderCore",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "SwiftReaderCore", targets: ["SwiftReaderCore"])
    ],
    targets: [
        .target(name: "SwiftReaderCore"),
        .testTarget(name: "SwiftReaderCoreTests", dependencies: ["SwiftReaderCore"])
    ]
)
