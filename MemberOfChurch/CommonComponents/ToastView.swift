//
//  ToastView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/24/25.
//

import SwiftUI

struct ToastView: View {
    let msg: String
    let buttonText: String?
    let alignment: Alignment
    let onClick: (() -> Void)?
    
    init(msg: String, buttonText: String? = nil, alignment: Alignment, onClick: (() -> Void)? = nil) {
        self.msg = msg
        self.buttonText = buttonText
        self.alignment = alignment
        self.onClick = onClick
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if alignment == .center {
                Spacer().frame(height: 180)
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text(msg)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .padding([.trailing, .leading], 20)
                    .padding([.top, .bottom], 14)
                
                Spacer()
                
                if let text = buttonText {
                    Text(text)
                        .font(.system(size: 14))
                        .foregroundStyle(.red.opacity(0.4))
                        .padding(.trailing, 20)
                        .padding([.top, .bottom], 14)
                        .onTapGesture {
                            onClick?()
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black.opacity(0.2))
            .cornerRadius(8, antialiased: true)
            .padding([.leading, .trailing], 20)
            .padding(.bottom, alignment == .bottom ? 40 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        .background(.clear)
    }
}


