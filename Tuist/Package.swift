// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // RxSwift 관련 라이브러리는 dynamic framework로 설정 필요 (DelegateProxy 런타임 문제 해결)
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "RxRelay": .framework,
            "RxCocoaRuntime": .framework
        ]
    )
#endif

let package = Package(
    name: "Template",
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0")
      ]
)
