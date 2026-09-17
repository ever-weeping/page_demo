//
//  ResourceTestViewController.swift
//  sohi
//

import UIKit
import demoResource

final class ResourceTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "系统性视觉"
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
