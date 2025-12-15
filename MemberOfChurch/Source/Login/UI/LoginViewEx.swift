//
//  LoginViewEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 3/24/25.
//

import SwiftUI
import ComposableArchitecture

extension LoginView {
    internal struct TextFieldView: View {
        @State private var isPasswordShow: Bool = false
        
        let store: StoreOf<LoginCore>
        @Binding var id: String
        @Binding var password: String
        @Binding var isAutoLogin: Bool

        @FocusState private var isFocused: ExistFocusable?
        
        init(store: StoreOf<LoginCore>, id: Binding<String>, password: Binding<String>, isAutoLogin: Binding<Bool>) {
            self.store = store
            self._id = id
            self._password = password
            self._isAutoLogin = isAutoLogin
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Image(.icUserid)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.leading, 10)
                    
                    TextField("", text: $id)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .limitInputLength(value: $id, length: 50)
                        .placeholder(when: id.isEmpty) {
                            Text("\("사용자 아이디")")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                .font(.system(size: 16))
                                .foregroundColor(.gray50)
                        }
                        .font(.system(size: 16))
                        .foregroundStyle(.gray80)
                        .tint(.gray80)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($isFocused, equals: .id)
                        .onSubmit {
                            isFocused = .hidePassword
                        }
                        .submitLabel(.continue)
                    
                    if !id.isEmpty && isFocused == .id {
                        Image(.icClear)
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 16)
                            .onTapGesture {
                                id = ""
                            }
                    }
                }
                .frame(height: 48)
                .background(.white)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isFocused == .id ? .green01.opacity(0.3) : .green01.opacity(0.2), lineWidth: 1)
                )
                .padding(.top, 8)
                
                HStack(alignment: .center, spacing: 0) {
                    Image(.icPassword)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.leading, 10)
                    
                    ZStack {
                        SecureField("", text: $password)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            //.limitInputLength(value: $password, length: 30)
                            .placeholder(when: password.isEmpty) {
                                Text("\("패스워드")")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray50)
                            }
                            .font(.system(size: 16))
                            .foregroundStyle(.gray80)
                            .tint(.gray80)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                            .focused($isFocused, equals: .hidePassword)
                            .onSubmit {
                                isFocused = nil
                            }
                            .submitLabel(.done)
                            .opacity(isPasswordShow ? 0 : 1)
                        
                        TextField("exist_tranggle_pw_hint", text: $password)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            //.limitInputLength(value: $password, length: 30)
                            .placeholder(when: password.isEmpty) {
                                Text("exist_tranggle_pw_hint")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray50)
                            }
                            .font(.system(size: 16))
                            .foregroundStyle(.gray80)
                            .tint(.gray80)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                            .focused($isFocused, equals: .showPassword)
                            .onSubmit {
                                isFocused = nil
                            }
                            .submitLabel(.done)
                            .opacity(isPasswordShow ? 1 : 0)
                    }
                    
                    if !password.isEmpty {
                        Image(isPasswordShow ? .icPwHide : .icPwShow)
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 16)
                            .onTapGesture {
                                isPasswordShow.toggle()
                                isFocused = isPasswordShow ? .showPassword : .hidePassword
                            }
                    }
                }
                .frame(height: 48)
                .background(.white)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke((isFocused == .showPassword || isFocused == .hidePassword) ? .green01.opacity(0.3    ) : .green01.opacity(0.2), lineWidth: 1)
                )
                .padding(.top, 8)
                
                Text("\("로그인")")
                    .font(.system(size: 20, weight: .black))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .padding(.leading, 8)
                    .background((!id.isEmpty && !password.isEmpty) ? Color.green01 : Color.gray20)
                    .cornerRadius(4, antialiased: true)
                    .padding(.top, 16)
                    .onTapGesture {
                        if !id.isEmpty && !password.isEmpty {
                            store.send(.userLogin(id, password, isAutoLogin))
                        }
                    }
                
                Toggle(isOn: $isAutoLogin) {
                    Text("자동 로그인")
                        .font(.system(size: 20, weight: .black))
                        .foregroundStyle(.white)
                }
                .toggleStyle(CheckboxToggleStyle())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 16)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack(alignment: .center, spacing: 0) {
                        Text("\("닫기")")
                            .font(.system(size: 16))
                            .foregroundStyle(.gray90)
                            .padding(.trailing, 10)
                            .onTapGesture {
                                isFocused = nil
                            }
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
}
