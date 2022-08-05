//
//  Model.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 27.07.2022.
//

import Combine
import SwiftUI

class Model: ObservableObject {
    @Published var showDetail: Bool = false
    @Published var selectedModal: Modal = .signIn
}

enum Modal: String {
    case signUp, signIn
}
