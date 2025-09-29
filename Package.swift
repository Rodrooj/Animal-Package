// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
<<<<<<< HEAD
    name: "Grupo-02-Package",
    platforms: [.iOS(.v13), .macOS(.v11)],
=======
    name: "AnimalPackage",
    platforms: [
        .iOS(.v18), .macOS(.v15)
    ],
>>>>>>> origin/feature/Package-Ph
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AnimalPackage",
            targets: ["AnimalPackage"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AnimalPackage"
        ),
    ]
)
