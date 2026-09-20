//
//  ResourceTestViewController.swift
//  sohi
//

import UIKit
import demoResource

final class ResourceTestViewController: UIViewController {
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) { fatalError() }

    override func loadView(){        // 创建 self.view
        super.loadView()
    }
    override func viewWillAppear(_ animated : Bool){  // 即将显示到屏幕上。'_'：省略外部参数名(外部标签)
        super.viewWillAppear(animated)
        print("[TabTitle] ResourceTestVC.viewWillAppear, title = \(title ?? "nil") 即将显示")
    }
    override func viewDidAppear(_ animated: Bool){   // 已经显示出来了
        super.viewDidAppear(animated)
        print("[TabTitle] ResourceTestVC.viewDidAppear, title = \(title ?? "nil") 已经显示")
    }
    override func viewWillDisappear(_ animated: Bool){  // 即将从屏幕上消失
        print("[TabTitle] ResourceTestVC.viewWillDisappear, title = \(title ?? "nil") 即将消失") 
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){   // 已经从屏幕上消失了
        print("[TabTitle] ResourceTestVC.viewDidDisappear, title = \(title ?? "nil") 已经消失")
        super.viewDidDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "系统性视觉"
//        print("[TabTitle] ResourceTestVC.title 赋值后, tabBarItem.title = \(navigationController?.tabBarItem.title ?? "nil")")
        view.backgroundColor = .systemGroupedBackground

        let toastBtn = makeButton(title: "toast测试")
        toastBtn.addTarget(self, action: #selector(onToastTapped), for: .touchUpInside)

        let alertBtn = makeButton(title: "弹窗")
        alertBtn.addTarget(self, action: #selector(onAlertTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [toastBtn, alertBtn])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func makeButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }

    @objc private func onToastTapped() {
        DemoToastManager.shared.show("这是一条 Toast 测试", duration: 2.0, position: .center)
    }

    @objc private func onAlertTapped() {
        DemoAlertManager.shared.show(title: "弹窗测试", message: "这是来自 demoResource 的弹窗")
    }
}
