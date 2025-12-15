//
//  MemberRegisterView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/12/25.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct MemberRegisterView: View {
    @EnvironmentObject var mainRouter: MainRouter
    
    let store: StoreOf<MemberRegisterCore>
    
    private let headerHeight: CGFloat = 100
    private let cameraDiameter: CGFloat = 112
    
    @State private var showSourceMenu = false
    @State private var showCameraSheet = false
    @State private var showPhotoPicker = false
    @State private var photoItem: PhotosPickerItem?
    @State private var showFullScreen = false
    
    @FocusState private var focusedField: Field?
    
    @State private var isShowAlert = false
    @State private var alertMessage: String = ""
    
    enum Field: Hashable {
        case name, mobile2, mobile3, phone2, phone3, job, school, familyRep, address, email, gnc, memo
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { (viewStore: ViewStoreOf<MemberRegisterCore>) in
            ZStack {
                KeyboardPrewarmView() // ✅ 첫 키보드 로딩 예열
                GeometryReader { geo in
                    VStack {
                        ZStack {
                            Text("성도등록")
                                .foregroundStyle(.white)
                                .font(.system(size: 25, weight: .bold))
                        }
                        .padding(.horizontal, 8)
                        .frame(height: headerHeight, alignment: .top)
                        .overlay(alignment: .bottom) {
                            CameraAvatar(
                                imageData: viewStore.pickedImageData,
                                diameter: cameraDiameter,
                                onPrimaryTap: {
                                    if viewStore.pickedImageData == nil {
                                        showSourceMenu = true
                                    } else {
                                        showFullScreen = true
                                    }
                                },
                                onChangeTap: { showSourceMenu = true }
                            )
                            .offset(y: cameraDiameter/2)
                            .zIndex(50)
                        }
                        .zIndex(10)
                        .ignoresSafeArea(.keyboard, edges: .bottom) // ✅ 헤더만 키보드 무시
                        
                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(spacing: 14) {
                                    Spacer().frame(height: cameraDiameter/2)
                                    
                                    SectionBox {
                                        LabeledTextField<Field>("이름*", text: viewStore.binding(
                                            get: \.name, send: MemberRegisterCore.Action.setName
                                        ), focus: $focusedField, focusID: .name)
                                        .id(Field.name)
                                        GenderPicker("성별*", selection:  viewStore.binding(
                                            get: \.gender, send: MemberRegisterCore.Action.setGender
                                        ))
                                    }
                                    SectionBox {
                                        YesNoPicker("구원여부*", selection: viewStore.binding(
                                            get: \.isSaved, send: MemberRegisterCore.Action.setIsSaved
                                        ))
                                        YesNoPicker("출석여부*", selection: viewStore.binding(
                                            get: \.isAttend, send: MemberRegisterCore.Action.setIsAttend
                                        ))
                                    }
                                    
                                    SectionBox {
                                        DatePickerRow(
                                            "출생년도",
                                            selection: viewStore.binding(
                                                get: \.birthDate, send: MemberRegisterCore.Action.setBirthDate
                                            ),
                                            display: DateDisplayFormat.korean
                                        )
                                        DatePickerRow(
                                            "중생년도",
                                            selection: viewStore.binding(
                                                get: \.salvationDate, send: MemberRegisterCore.Action.setSalvationDate
                                            ),
                                            display: DateDisplayFormat.korean
                                        )
                                    }
                                    
                                    SectionBox {
                                        PhoneRow<MobileCode, Field>(
                                            title: "휴대전화*",
                                            prefix: viewStore.binding(
                                                get: \.mobile1, send: MemberRegisterCore.Action.setMobile1
                                            ),
                                            p2: viewStore.binding(
                                                get: \.mobile2, send: MemberRegisterCore.Action.setMobile2
                                            ),
                                            p3: viewStore.binding(
                                                get: \.mobile3, send: MemberRegisterCore.Action.setMobile3
                                            ),
                                            focus: $focusedField,
                                            focusID2: .mobile2,
                                            focusID3: .mobile3
                                        )
                                        .id(Field.mobile2)
                                        PhoneRow<PhoneCode, Field>(
                                            title: "집전화",
                                            prefix: viewStore.binding(
                                                get: \.phone1, send: MemberRegisterCore.Action.setPhone1
                                            ),
                                            p2: viewStore.binding(
                                                get: \.phone2, send: MemberRegisterCore.Action.setPhone2
                                            ),
                                            p3: viewStore.binding(
                                                get: \.phone3, send: MemberRegisterCore.Action.setPhone3
                                            ),
                                            focus: $focusedField,
                                            focusID2: .phone2,
                                            focusID3: .phone3
                                        )
                                        .id(Field.phone2)
                                    }
                                    
                                    SectionBox {
                                        LabeledChurchPicker("소속교회*", church: viewStore.binding(
                                            get: \.churchName, send: MemberRegisterCore.Action.setChurchName
                                        ), churchLists: viewStore.churchLists)
                                        HStack {
                                            LabeledDataPicker("구분*", prefix: viewStore.binding(
                                                get: \.category, send: MemberRegisterCore.Action.setCategory
                                            ))
                                            LabeledDataPicker("직분*", prefix: viewStore.binding(
                                                get: \.duty, send: MemberRegisterCore.Action.setDuty
                                            ))
                                        }
                                        LabeledDataPicker("임원직분", prefix: viewStore.binding(
                                            get: \.officerDuty, send: MemberRegisterCore.Action.setOfficerDuty
                                        ))
                                        if !viewStore.sectLists.isEmpty {
                                            HStack {
                                                LabeledSectPicker("구역", sect: viewStore.binding(
                                                    get: \.sect, send: MemberRegisterCore.Action.setSect
                                                ), sectLists: viewStore.sectLists)
                                                LabeledTextField<Field>("직업", text: viewStore.binding(
                                                    get: \.job, send: MemberRegisterCore.Action.setJob
                                                ), focus: $focusedField, focusID: .job)
                                                .id(Field.job)
                                            }
                                        }
                                    }
                                    
                                    SectionBox {
                                        HStack {
                                            LabeledTextField<Field>("학교", text: viewStore.binding(
                                                get: \.school, send: MemberRegisterCore.Action.setSchool
                                            ), focus: $focusedField, focusID: .school)
                                            .id(Field.school)
                                            LabeledDataPicker("학년", prefix: viewStore.binding(
                                                get: \.grade, send: MemberRegisterCore.Action.setGrade
                                            ))
                                            .frame(width: 150)
                                        }
                                    }
                                    
                                    SectionBox {
                                        HStack {
                                            LabeledTextField<Field>(
                                                "가족대표*",
                                                text: viewStore.binding(
                                                    get: \.familyRep, send: MemberRegisterCore.Action.setFamilyRep
                                                ),
                                                focus: $focusedField,
                                                focusID: .familyRep,
                                                disabled: viewStore.familyRepDisabled
                                            )
                                            .id(Field.familyRep)
                                            LabeledDataPicker("관계*", prefix: viewStore.binding(
                                                get: \.relation, send: MemberRegisterCore.Action.setRelation
                                            ))
                                            .frame(width: 150)
                                        }
                                    }
                                    
                                    SectionBox {
                                        LabeledTextEditor<Field>("주소", text: viewStore.binding(
                                            get: \.address, send: MemberRegisterCore.Action.setAddress
                                        ), focus: $focusedField, focusID: .address)
                                        .frame(minHeight: 80)
                                        .id(Field.address)
                                        LabeledTextField<Field>("이메일주소", text: viewStore.binding(
                                            get: \.email, send: MemberRegisterCore.Action.setEmail
                                        ), keyboard: .emailAddress, focus: $focusedField, focusID: .email)
                                        .id(Field.email)
                                        LabeledTextField<Field>("굿뉴스코", text: viewStore.binding(
                                            get: \.goodNewsCorps, send: MemberRegisterCore.Action.setGoodNewsCorps
                                        ), focus: $focusedField, focusID: .gnc)
                                        .id(Field.gnc)
                                        LabeledDataPicker("기간근무자", prefix: viewStore.binding(
                                            get: \.termWorker, send: MemberRegisterCore.Action.setTermWorker
                                        ))
                                        LabeledTextEditor<Field>("기타사항", text: viewStore.binding(
                                            get: \.memo, send: MemberRegisterCore.Action.setMemo
                                        ), focus: $focusedField, focusID: .memo)
                                        .frame(minHeight: 120)
                                        .id(Field.memo)
                                    }
                                    //
                                    // 등록 버튼
                                    Button {
                                        viewStore.send(.submitTapped)
                                    } label: {
                                        if viewStore.isSubmitting {
                                            ProgressView()
                                                .frame(maxWidth: .infinity, minHeight: 52)
                                        } else {
                                            Text(viewStore.mode == .write ? "등록하기" :  "수정하기")
                                                .font(.headline)
                                                .frame(maxWidth: .infinity, minHeight: 52)
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.27, green: 0.50, blue: 0.16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 20)
                                }
                            }
                            // 포커스 변경 시 해당 위치로 스크롤
                            .onChange(of: focusedField) { new in
                                guard let new else { return }
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    proxy.scrollTo(new, anchor: .center) // or .bottom
                                }
                            }
                        }
                        .scrollDismissesKeyboard(.interactively) // iOS 16+
                        .background(.white)
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                    .background(.green04)
                    .task {
//                        viewStore.send(.onAppear)
                    }
                    .onDisappear() {
                        viewStore.send(.clear)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    // 🔹 왼쪽: 이전 버튼
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            if !mainRouter.mainPath.isEmpty {
                                mainRouter.mainPath.removeLast()
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.green07)
                                Text("이전")
                                    .foregroundStyle(.green07)
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("완료") {
                            focusedField = nil
                        }
                    }
                }
            }
            .onChange(of: viewStore.alert) { alert in
                if !alert.isEmpty {
                    self.isShowAlert = true
                    self.alertMessage = alert
                }
            }
            .alert("알림", isPresented: $isShowAlert, actions: {
                Button("확인", action: {
                    // 등록/수정 성공시 뒤로가기
                    if viewStore.isSuccress {
                        mainRouter.memberStore.send(.markNeedsRefresh)
                        mainRouter.areaStore.send(.markNeedsRefresh)
                        if !mainRouter.mainPath.isEmpty {
                            mainRouter.mainPath.removeLast()
                        }
                    }
                })
            }, message: {
                Text(self.alertMessage)
            })
            .fullScreenCover(isPresented: $showFullScreen) {
                ImageFullScreenView(
                    imageData: viewStore.pickedImageData,
                    onClose: {
                        showFullScreen = false
                    },
                    onChange: {
                        showFullScreen = false
                        showSourceMenu = true
                    }
                )
                .ignoresSafeArea()
            }
            .confirmationDialog("사진을 선택하세요", isPresented: $showSourceMenu) {
                Button("카메라로 촬영") { showCameraSheet = true }
                Button("앨범에서 선택") { showPhotoPicker = true }
                Button("취소", role: .cancel) {}
            }
            .sheet(isPresented: $showCameraSheet) {
                ImagePicker(source: .camera) { data in
                    viewStore.send(.setPickedImageData(data))
                }
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { item in
                Task {
                    guard let item else { viewStore.send(.setPickedImageData(nil)); return }
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        viewStore.send(.setPickedImageData(data)); return
                    }
                    if let url = try? await item.loadTransferable(type: URL.self),
                       let data = try? Data(contentsOf: url) {
                        viewStore.send(.setPickedImageData(data)); return
                    }
                    viewStore.send(.setPickedImageData(nil))
                }
            }
        }
    }
    
    // 키보드 툴바 높이(대략). 포커스 있을 때만 적용.
    private var toolbarExtraHeight: CGFloat {
        focusedField == nil ? 0 : 48
    }
}
