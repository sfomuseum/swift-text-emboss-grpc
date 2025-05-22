// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextEmbossGRPC",
    platforms: [.macOS("15.0")],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "2.2.1"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", from: "1.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", from: "1.2.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
        
        .package(url: "https://github.com/sfomuseum/swift-text-emboss", from: "0.0.3"),
        .package(url: "https://github.com/sfomuseum/swift-coregraphics-image.git", from: "1.0.0"),
        .package(url: "https://github.com/sfomuseum/swift-sfomuseum-logger.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "text-emboss-grpc-server",
            dependencies: [
                .product(name: "GRPCCore", package: "grpc-swift"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "TextEmboss", package: "swift-text-emboss"),
                .product(name: "CoreGraphicsImage", package: "swift-coregraphics-image"),
                .product(name: "SFOMuseumLogger", package: "swift-sfomuseum-logger"),
            ],
            plugins: [
              .plugin(name: "GRPCProtobufGenerator", package: "grpc-swift-protobuf")
            ],
            // path: "Scripts"
    )
    ]
)
