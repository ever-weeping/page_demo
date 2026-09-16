//
//  DemoAlert.swift
//  demoResource
//
//  Created by ali_mahai on 2026/9/15.
//

import SwiftUI
import Combine

public final class DemoAlertManager: ObservableObject {
    @Published public var title: String = ""
    @Published public var message: String = ""
    @Published public var confirmTitle: String = "确定"
    @Published public var cancelTitle: String?
    @Published public var isPresented: Bool = false

    private var onConfirm: (() -> Void)?
    private var onCancel: (() -> Void)?

    public static let shared = DemoAlertManager()

    private init() {}

    public func show(title: String,
                     message: String,
                     confirmTitle: String = "确定",
                     cancelTitle: String? = nil,
                     onConfirm: (() -> Void)? = nil,
                     onCancel: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.title = title
            self.message = message
            self.confirmTitle = confirmTitle
            self.cancelTitle = cancelTitle
            self.onConfirm = onConfirm
            self.onCancel = onCancel
            self.isPresented = true
        }
    }

    public func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.isPresented = false
            self?.onConfirm = nil
            self?.onCancel = nil
        }
    }

    func handleConfirm() {
        onConfirm?()
        dismiss()
    }

    func handleCancel() {
        onCancel?()
        dismiss()
    }
}

public struct DemoAlertModifier: ViewModifier {
    @ObservedObject private var manager = DemoAlertManager.shared

    public func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                if manager.isPresented {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture { manager.dismiss() }

                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text(manager.title)
                                .font(.system(size: 17, weight: .semibold))

                            Text(manager.message)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)

                        Divider()

                        HStack {
                            if let cancel = manager.cancelTitle {
                                Button(cancel) {
                                    manager.handleCancel()
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)

                                Divider()
                            }

                            Button(manager.confirmTitle) {
                                manager.handleConfirm()
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 44)
                    }
                    .frame(width: 270)
                    .background(Color(.systemBackground))
                    .cornerRadius(14)
                    .shadow(radius: 10)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: manager.isPresented)
        )
    }
}

public extension View {
    func demoAlert() -> some View {
        modifier(DemoAlertModifier())
    }
}
