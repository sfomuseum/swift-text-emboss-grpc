// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextEmbosser",
    platforms: [
        .macOS("15.0"),
        .iOS("18.0")
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift-2.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.8.2"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.15.0"),
        .package(url: "https://github.com/sfomuseum/swift-text-emboss", from: "0.0.3"),
        .package(url: "https://github.com/sfomuseum/swift-coregraphics-image.git", from: "1.0.0"),
        .package(url: "https://github.com/sfomuseum/swift-sfomuseum-logger.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "text-emboss-grpc-server",
            dependencies: [
                .product(name: "GRPCCore", package: "grpc-swift-2"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "TextEmboss", package: "swift-text-emboss"),
                .product(name: "CoreGraphicsImage", package: "swift-coregraphics-image"),
                .product(name: "SFOMuseumLogger", package: "swift-sfomuseum-logger"),
            ],
        )
    ]
)
