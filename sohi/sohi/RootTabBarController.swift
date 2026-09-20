//
//  RootTabBarController.swift
//  sohi
//

import UIKit

final class RootTabBarController: UITabBarController {
    
    override func loadView(){        // 创建 self.view
        super.loadView()
    }
    override func viewWillAppear(_ animated : Bool){  // 即将显示到屏幕上。'_'：省略外部参数名(外部标签)
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool){   // 已经显示出来了
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool){  // 即将从屏幕上消失
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){   // 已经从屏幕上消失了
        super.viewDidDisappear(animated)
    }

    override func viewDidLoad() { // 视图已加载到内存，你在这里设置 UI
        super.viewDidLoad()

        let home = makeTab(title: "首页", image: "house", vc: HomeWaterfallViewController(), hidesBar: true)
        let resource = makeTab(title: "资源测试", image: "doc.text", vc: ResourceTestViewController(title: "系统性视觉"))
        // print("[TabTitle] makeTab tab2.tabBarItem.title = \(resource.tabBarItem.title ?? "nil")")
        let profile = makeTab(title: "个人中心", image: "person.crop.circle", vc: PlaceholderViewController(title: "个人中心"))

        viewControllers = [home, resource, profile]
    }

    private func makeTab(title: String, image: String, vc: UIViewController, hidesBar: Bool = false) -> UINavigationController {
//        vc.title = title   // 让 nav 的 title 落到自身，防止页面 title 后来覆盖 tab 标题
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(hidesBar, animated: false)
        nav.tabBarItem = UITabBarItem(title: title,
                                      image: UIImage(systemName: image),
                                      selectedImage: UIImage(systemName: "\(image).fill"))
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        return nav
    }
}

// MARK: - 占位页

final class PlaceholderViewController: UIViewController {
    private let text: String
    init(title: String) {
        self.text = title
        super.init(nibName: nil, bundle: nil)
        self.title = title
        print("[TabTitle] PlaceholderVC.title 赋值为 ???, tabBarItem.title = \(tabBarItem?.title ?? "nil")")
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
