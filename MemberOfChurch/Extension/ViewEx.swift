//
//  ViewEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/24/25.
//

import SwiftUI
import ComposableArchitecture

extension View {
    func limitInputLength(value: Binding<String>, length: Int, isShowToast: Bool = false) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length, isShowToast: isShowToast))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func toast(show: Binding<Bool>, msg: String, buttonText: String? = nil,
               alignment: Alignment = .bottom, onClick: (() -> Void)? = nil) -> some View {
        self.modifier(ToastModifer(value: show, msg: msg, buttonText: buttonText, alignment: alignment, onClick: onClick))
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(configuration.isOn ? .icCheckPress : .icCheck)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
