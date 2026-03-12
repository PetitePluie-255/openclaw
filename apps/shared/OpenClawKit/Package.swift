// swift-tools-version: 6.2

import Foundation
import PackageDescription

let disableTextual = ProcessInfo.processInfo.environment["OPENCLAW_DISABLE_TEXTUAL"] == "1"

var packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
    .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.4.1"),
]

if !disableTextual {
    packageDependencies.append(
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"))
}

var openClawChatUIDependencies: [Target.Dependency] = [
    "OpenClawKit",
    .product(
        name: "MarkdownUI",
        package: "swift-markdown-ui",
        condition: .when(platforms: [.macOS, .iOS])),
]

if !disableTextual {
    openClawChatUIDependencies.append(
        .product(
            name: "Textual",
            package: "textual",
            condition: .when(platforms: [.macOS, .iOS])))
}

let package = Package(
    name: "OpenClawKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "OpenClawProtocol", targets: ["OpenClawProtocol"]),
        .library(name: "OpenClawKit", targets: ["OpenClawKit"]),
        .library(name: "OpenClawChatUI", targets: ["OpenClawChatUI"]),
    ],
    dependencies: packageDependencies,
    targets: [
        .target(
            name: "OpenClawProtocol",
            path: "Sources/OpenClawProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenClawKit",
            dependencies: [
                "OpenClawProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/OpenClawKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenClawChatUI",
            dependencies: openClawChatUIDependencies,
            path: "Sources/OpenClawChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "OpenClawKitTests",
            dependencies: ["OpenClawKit", "OpenClawChatUI"],
            path: "Tests/OpenClawKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
