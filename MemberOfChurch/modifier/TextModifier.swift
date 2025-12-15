//
//  TextModifier.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/24/25.
//


import SwiftUI

struct TextFieldLimitModifer: ViewModifier {
    @State private var isToast: Bool = false
    
    @Binding var value: String
    let length: Int
    let isShowToast: Bool
    
    init(value: Binding<String>, length: Int, isShowToast: Bool = false) {
        self._value = value
        self.length = length
        self.isShowToast = isShowToast
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value) { newValue in
                if newValue.count > length {
                    value = String(newValue.prefix(length))
                    
                    if isShowToast && !isToast {
                        isToast.toggle()
                    }
                }
            }
            .overlay {
                VStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0).frame(height: 20)
                    
                    Color.clear
                        .toast(show: $isToast, msg: "공백 포함 \(length)자 이내로 입력해 주세요.")
                }
            }
    }
}
