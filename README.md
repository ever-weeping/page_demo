# page_demo

一个 iOS App 页面的 demo 工程，包含各种组件排列、实现。

## 项目结构

```
page_demo/
├── page_demo.xcworkspace/    # 旧工作区（源码级双工程引用，已弃用）
├── sohi/                     # 主工程
│   ├── sohi/                 # 源码：SwiftUI 入口 + UIKit TabBar
│   ├── Podfile               # CocoaPods 依赖（本地 pod）
│   └── sohi.xcworkspace/     # 入口工程：pod install 后打开这个
└── demoResource/             # 本地组件库（开发 pod）
    ├── demoResource/         # DemoToast / DemoAlert 组件源码
    └── demoResource.podspec
```

### sohi 主工程

SwiftUI 与 UIKit 混合：`sohiApp` → `ContentView`（挂载全局 `.demoToast()` / `.demoAlert()` 修饰符）→ `RootTabBarRepresentable` 桥接 `RootTabBarController`。

- `RootTabBarController`：底部三 Tab
  - 首页：`HomeWaterfallViewController` + `WaterfallLayout` 瀑布流（导航栏隐藏，内容顶到屏幕顶部）
  - 资源测试：`ResourceTestViewController`，测试 demoResource 组件
  - 个人中心：占位页
- **注意**：VC 的 `title` 要在 `init` 里设置，不要放 `viewDidLoad`。UINavigationController 会在栈顶 VC title 变化时自动同步覆盖 `tabBarItem.title`，init 里设置早于 tabBarItem 赋值，可避开这个坑。

### demoResource 组件库

SwiftUI 全局浮层组件，状态统一由 `XxxManager.shared` 驱动：

```swift
// 挂载（在根视图上，全局只挂一次）
content.overlay(...)  // 内部实现，使用方只需加修饰符
RootTabBarRepresentable()
    .demoToast()
    .demoAlert()

// 触发 Toast
DemoToastManager.shared.show("这是一条 Toast 测试", duration: 2.0, position: .center)

// 触发弹窗
DemoAlertManager.shared.show(title: "弹窗测试", message: "这是来自 demoResource 的弹窗")
```

## 运行

```bash
cd sohi
pod install
open sohi.xcworkspace
```

始终打开 `sohi.xcworkspace`（而非 `sohi.xcodeproj`），否则 demoResource 不会参与编译。

## 环境要求

- Xcode 26+、Swift 5.9+
- CocoaPods 1.17+
- ⚠️ Xcode 26 的 `PBXFileSystemSynchronizedRootGroup` 与 CocoaPods 1.17 不兼容（报 `undefined method 'files'`）。本工程的文件夹均已转为传统 Group，**不要在 Xcode 里把文件夹再转回 Folder reference / 同步组**。
