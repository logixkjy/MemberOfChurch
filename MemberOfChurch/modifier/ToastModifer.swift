//
//  ToastModifer.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/24/25.
//

import SwiftUI

struct ToastModifer: ViewModifier {
    @Binding var value: Bool
    let msg: String
    let buttonText: String?
    let alignment: Alignment
    let onClick: (() -> Void)?
    
    init(value: Binding<Bool>, msg: String, buttonText: String? = nil,
         alignment: Alignment, onClick: (() -> Void)? = nil) {
        self._value = value
        self.msg = msg
        self.buttonText = buttonText
        self.alignment = alignment
        self.onClick = onClick
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if value {
                ToastView(msg: msg, buttonText: buttonText, alignment: alignment, onClick: onClick).task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        value = false
                    }
                }
            }
        }
    }
}


