//
//  DemoToast.swift
//  demoResource
//
//  Created by ali_mahai on 2026/9/15.
//

import SwiftUI
import Combine

public enum DemoToastPosition {
    case top
    case center
    case bottom
}

public final class DemoToastManager: ObservableObject {
    @Published public var message: String?
    @Published public var position: DemoToastPosition = .center

    public static let shared = DemoToastManager()

    private init() {}

    public func show(_ text: String,
                     duration: TimeInterval = 2.0,
                     position: DemoToastPosition = .center) {
        DispatchQueue.main.async { [weak self] in
            self?.message = text
            self?.position = position
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.message = nil
        }
    }

    public func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.message = nil
        }
    }
}

public struct DemoToastModifier: ViewModifier {
    @ObservedObject private var manager = DemoToastManager.shared

    public func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                if let message = manager.message {
                    Text(message)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(8)
                        .transition(.opacity)
                        .frame(maxWidth: 300)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment(for: manager.position))
                        .padding(.vertical, 60)
                        .animation(.easeInOut(duration: 0.25), value: manager.message)
                }
            }
        )
    }

    private func alignment(for pos: DemoToastPosition) -> Alignment {
        switch pos {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
}

public extension View {
    func demoToast() -> some View {
        modifier(DemoToastModifier())
    }
}
