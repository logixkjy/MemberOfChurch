//
//  ContactPopupView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 4/2/25.
//

import SwiftUI
import ComposableArchitecture

internal struct ContactPopupView: View {
    @Binding var name: String
    @Binding var phone: String
    @Binding var email: String
    
    @Binding var isPresented: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                // 🔵 헤더
                HStack {
                    Text(name)
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        isPresented = false
                        name = ""
                        phone = ""
                        email = ""
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                
                Divider()
                
                // 🔵 버튼 4개
                LazyVGrid(columns: columns, spacing: 20) {
                    contactButton(label: "전화걸기", systemImage: "phone.fill") {
                        if let url = URL(string: "tel://\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    contactButton(label: "문자메시지", systemImage: "message.fill") {
                        if let url = URL(string: "sms:\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    contactButton(label: "이메일", systemImage: "envelope.fill") {
                        if let url = URL(string: "mailto:\(email)") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    contactButton(label: "전화번호 복사", systemImage: "doc.on.doc") {
                        UIPasteboard.general.string = phone
                    }
                }
            }
            .padding()
            .frame(width: 300)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .position(x: geo.size.width / 2, y: geo.size.height * 0.4) // ✅ 중앙보다 약간 위
        }
    }
    
    // 버튼 모양 구성
    @ViewBuilder
    func contactButton(label: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blue)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
