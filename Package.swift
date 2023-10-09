// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTreeSitterCompatibilityLayer",
    products: [
        .library(
            name: "SwiftTreeSitterCompatibilityLayer",
            targets: ["SwiftTreeSitterCompatibilityLayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tree-sitter/tree-sitter", branch: "master")
    ],
    targets: [
        .target(
            name: "SwiftTreeSitterCompatibilityLayer", dependencies: [
                .product(name: "TreeSitter", package: "tree-sitter"),
            ]),
        .testTarget(
            name: "SwiftTreeSitterCompatibilityLayerTests",
            dependencies: ["SwiftTreeSitterCompatibilityLayer"]),
    ]
)
