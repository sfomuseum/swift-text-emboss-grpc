// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextEmbossGRPC",
    products: [
        .library(
            name: "TextEmbossGRPC",
            targets: ["TextEmbossGRPC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/sfomuseum/swift-text-emboss", from: "0.0.1"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.15.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.6.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/sfomuseum/swift-coregraphics-image.git", branch: "main"),
        .package(url: "https://github.com/sfomuseum/swift-grpc-server.git", from: "0.0.1"),
        .package(url: "https://github.com/sfomuseum/swift-sfomuseum-logger.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TextEmbossGRPC",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "TextEmboss", package: "swift-text-emboss"),
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "CoreGraphicsImage", package: "swift-coregraphics-image"),
                .product(name: "GRPCServerLogger", package: "swift-grpc-server")
            ],
            exclude: ["embosser.proto"]
        ),
        .executableTarget(
            name: "text-emboss-grpc-server",
            dependencies: [
                "TextEmbossGRPC",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "TextEmboss", package: "swift-text-emboss"),
                // .product(name: "GRPC", package: "grpc-swift"),
                // .product(name: "Logging", package: "swift-log"),
                // .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                // .product(name:"CoreGraphicsImage", package: "swift-coregraphics-image"),
                .product(name: "SFOMuseumLogger", package: "swift-sfomuseum-logger"),
                .product(name: "GRPCServer", package: "swift-grpc-server")
            ],
            path: "Scripts"
	)
    ]
)
