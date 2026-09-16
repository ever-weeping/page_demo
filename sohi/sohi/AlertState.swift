//
//  AlertState.swift
//  sohi
//

import SwiftUI
import Combine

final class AlertState: ObservableObject {
    static let shared = AlertState()
    @Published var show = false
    @Published var title = ""
    @Published var message = ""
}
