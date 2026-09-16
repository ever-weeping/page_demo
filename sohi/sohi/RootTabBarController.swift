//
//  RootTabBarController.swift
//  sohi
//

import UIKit

final class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let home = makeTab(title: "首页", image: "house", vc: HomeWaterfallViewController())
        let resource = makeTab(title: "资源测试", image: "doc.text", vc: ResourceTestViewController())
        let profile = makeTab(title: "个人中心", image: "person.crop.circle", vc: PlaceholderViewController(title: "个人中心"))

        viewControllers = [home, resource, profile]
    }

    private func makeTab(title: String, image: String, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title,
                                      image: UIImage(systemName: image),
                                      selectedImage: UIImage(systemName: "\(image).fill"))
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
