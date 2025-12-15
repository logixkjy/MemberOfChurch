//
//  MemberRegisterViewEx.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/12/25.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

extension MemberRegisterView {
    internal struct CameraAvatar: View {
        let imageData: Data?
        let diameter: CGFloat
        var onPrimaryTap: () -> Void   // 큰 원(아바타) 탭
        var onChangeTap: () -> Void    // 작은 카메라 버튼 탭
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                // 큰 원: 사진 없으면 카메라 아이콘, 있으면 사진
                Button(action: onPrimaryTap) {
                    ZStack {
                        Circle().fill(Color(.systemGray6))
                        if let data = imageData, let ui = UIImage(data: data) {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(width: diameter, height: diameter)
                    .shadow(radius: 6, y: 2)
                }
                .buttonStyle(.plain)
                .contentShape(Circle())
                
                // 🔽 작은 카메라 버튼: "사진이 있는 경우에만" 표시
                if imageData != nil {
                    Button(action: onChangeTap) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                            .background(Circle().fill(Color.black.opacity(0.75)))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .offset(x: 2, y: 2)
                    .contentShape(Circle())
                }
            }
        }
    }
    
    struct ImageFullScreenView: View {
        let imageData: Data?
        var onClose: () -> Void
        var onChange: () -> Void
        
        @State private var scale: CGFloat = 1
        @State private var lastScale: CGFloat = 1
        @State private var offset: CGSize = .zero
        @State private var lastOffset: CGSize = .zero
        
        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if let data = imageData, let ui = UIImage(data: data) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = min(max(1, lastScale * value), 4)
                                }
                                .onEnded { _ in lastScale = scale }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(width: lastOffset.width + value.translation.width,
                                                    height: lastOffset.height + value.translation.height)
                                }
                                .onEnded { _ in lastOffset = offset }
                        )
                        .onTapGesture(count: 2) { // 더블탭 줌
                            withAnimation(.easeInOut) {
                                if scale > 1 { scale = 1; lastScale = 1; offset = .zero; lastOffset = .zero }
                                else { scale = 2; lastScale = 2 }
                            }
                        }
                } else {
                    Text("이미지가 없습니다").foregroundColor(.white.opacity(0.7))
                }
                
                // 상단 버튼
                HStack {
                    Button { onClose() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .padding(10)
                            .background(Circle().fill(.black.opacity(0.5)))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button { onChange() } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "camera.fill")
                            Text("변경")
                        }
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.black.opacity(0.5)))
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 64)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    internal struct CameraPicker: View {
        let image: UIImage?
        let diameter: CGFloat
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle().fill(Color(.systemGray6))
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(.gray)
                    }
                }
                .frame(width: diameter, height: diameter)
                .shadow(radius: 6, y: 2)
            }
            .buttonStyle(.plain)
        }
    }
    
    internal struct SectionBox<Content: View>: View {
        var header: String?
        @ViewBuilder var content: Content
        
        init(header: String? = nil, @ViewBuilder content: () -> Content) {
            self.header = header
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                if let header {
                    Text(header)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
                VStack(spacing: 10) { content }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
            }
            .padding(.horizontal, 16)
        }
    }
    
    internal struct LabeledTextField<F: Hashable>: View {
        let title: String
        @Binding var text: String
        var keyboard: UIKeyboardType = .default
        
        var focus: FocusState<F?>.Binding?
        var focusID: F?
        var disabled: Bool = false
        
        init(_ title: String, text: Binding<String>, keyboard: UIKeyboardType = .default, focus: FocusState<F?>.Binding? = nil, focusID: F? = nil, disabled: Bool = false) {
            self.title = title
            self._text = text
            self.keyboard = keyboard
            self.focus = focus
            self.focusID = focusID
            self.disabled = disabled
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                TextField("", text: $text)
                    .keyboardType(keyboard)
                    .textFieldStyle(.roundedBorder)
                    .modifier(FocusIfProvided(focus: focus, id: focusID))
                    .disabled(disabled)
            }
        }
    }
    
    // focus가 있을 때만 .focused를 붙이는 작은 헬퍼
    private struct FocusIfProvided<F: Hashable>: ViewModifier {
        let focus: FocusState<F?>.Binding?
        let id: F?
        
        func body(content: Content) -> some View {
            if let focus, let id {
                content.focused(focus, equals: id)
            } else {
                content
            }
        }
    }
    
    internal struct LabeledTextEditor<F: Hashable>: View {
        let title: String
        @Binding var text: String
        
        var focus: FocusState<F?>.Binding?
        var focusID: F?
        
        init(_ title: String, text: Binding<String>, focus: FocusState<F?>.Binding? = nil, focusID: F? = nil) {
            self.title = title
            self._text = text
            self.focus = focus
            self.focusID = focusID
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                TextEditor(text: $text)
                    .frame(minHeight: 80)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(Color(.separator), lineWidth: 0.5)
                    )
                    .background(Color(.systemBackground))
                    .modifier(FocusIfProvided(focus: focus, id: focusID))
            }
        }
    }
    
    internal struct GenderPicker: View {
        let title: String
        @Binding var selection: MemberRegisterCore.Gender?
        init(_ title: String, selection: Binding<MemberRegisterCore.Gender?>) {
            self.title = title; self._selection = selection
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Picker("", selection: Binding(
                    get: { selection ?? .male },
                    set: { selection = $0 })
                ) {
                    ForEach(MemberRegisterCore.Gender.allCases) { g in
                        Text(g.rawValue).tag(g)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
    
    internal struct YesNoPicker: View {
        let title: String
        @Binding var selection: MemberRegisterCore.YesNo?
        init(_ title: String, selection: Binding<MemberRegisterCore.YesNo?>) {
            self.title = title; self._selection = selection
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Picker("", selection: Binding(
                    get: { selection ?? .no },
                    set: { selection = $0 })
                ) {
                    ForEach(MemberRegisterCore.YesNo.allCases) { v in
                        Text(v.rawValue).tag(v)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
    
    struct FormattedDateField: View {
        @Binding var date: Date
        @State private var showPicker = false
        
        var body: some View {
            Button {
                showPicker = true
            } label: {
                HStack {
                    Text(DateFormatter.ymdKorean.string(from: date)) // "yyyy-MM-dd"
                    Image(systemName: "chevron.down")
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.3)))
            }
            .sheet(isPresented: $showPicker) {
                VStack {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical) // 또는 .wheel
                        .labelsHidden()
                    Button("완료") { showPicker = false }
                        .padding(.top, 8)
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    internal struct DatePickerRow: View {
        let title: String
        @Binding var selection: Date
        var display: DateDisplayFormat = .korean   // 기본: "yyyy-MM-dd"
        
        init(_ title: String, selection: Binding<Date>, display: DateDisplayFormat) {
            self.title = title
            self._selection = selection
            self.display = display
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                FormattedDateField(date: $selection)
//                HStack(spacing: 12) {
//                    // ✅ 내가 원하는 포맷으로 표시
//                    Text(formatted(selection))
//                        .font(.body)
//                    
//                    // 실제 선택은 Compact DatePicker로
//                    DatePicker(
//                        "",
//                        selection: $selection,
//                        displayedComponents: [.date]
//                    )
//                    .labelsHidden()
//                    .datePickerStyle(.compact)
//                }
            }
        }
        
        private func formatted(_ date: Date) -> String {
            switch display {
            case .dash:   return DateFormatter.ymdDash.string(from: date)     // "yyyy-MM-dd"
            case .korean: return DateFormatter.ymdKorean.string(from: date)   // "yyyy년 MM월 dd일"
            }
        }
    }
    
    internal struct PhoneRow<P: DataPrefix, F: Hashable>: View {
        let title: String
        @Binding var prefix: P
        @Binding var p2: String
        @Binding var p3: String
        
        var focus: FocusState<F?>.Binding?
        var focusID2: F?
        var focusID3: F?
        
        init(
            title: String,
            prefix: Binding<P>,
            p2: Binding<String>,
            p3: Binding<String>,
            focus: FocusState<F?>.Binding? = nil,
            focusID2: F? = nil,
            focusID3: F? = nil
        ) {
            self.title = title
            self._prefix = prefix
            self._p2 = p2
            self._p3 = p3
            self.focus = focus
            self.focusID2 = focusID2
            self.focusID3 = focusID3
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    Picker("", selection: $prefix) {
                        ForEach(Array(P.allCases)) { v in
                            Text(v.rawValue).tag(v)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(width: 88)
                    
                    Text("-")
                    
                    TextField("", text: $p2)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .modifier(FocusIfProvided(focus: focus, id: focusID2))
                        .onChange(of: p2) { newValue in
                            if newValue.count > 4 {
                                p2 = String(newValue.prefix(4))
                            }
                        }
                    
                    Text("-")
                    
                    TextField("", text: $p3)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .modifier(FocusIfProvided(focus: focus, id: focusID3))
                        .onChange(of: p3) { newValue in
                            if newValue.count > 4 {
                                p3 = String(newValue.prefix(4))
                            }
                        }
                }
            }
        }
    }
    
    internal struct LabeledDataPicker<P: DataPrefix>: View {
        let title: String
        @Binding var prefix: P
        
        init(_ title: String, prefix: Binding<P>) {
            self.title = title
            self._prefix = prefix
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Picker("", selection: $prefix) {
                    // ✅ RandomAccessCollection 요구사항 만족 (Array로 래핑)
                    ForEach(Array(P.allCases)) { v in
                        Text(v.rawValue).tag(v)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    internal struct LabeledSectPicker: View {
        let title: String
        @Binding var sect: ChurSectEntity?
        let sectLists: Array<ChurSectEntity>
        
        init(_ title: String, sect: Binding<ChurSectEntity?>, sectLists: Array<ChurSectEntity>) {
            self.title = title
            self._sect = sect
            self.sectLists = sectLists.sorted(by: { $0.SECT_CD < $1.SECT_CD })
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Picker("", selection: $sect) {
                    // ✅ RandomAccessCollection 요구사항 만족 (Array로 래핑)
                    ForEach(sectLists, id: \.SECT_CD) { v in
                        Text("\(v.SECT_CD)").tag(v)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    internal struct LabeledChurchPicker: View {
        let title: String
        @Binding var church: ChurchEntity?
        let churchLists: Array<ChurchEntity>
        
        init(_ title: String, church: Binding<ChurchEntity?>, churchLists: Array<ChurchEntity>) {
            self.title = title
            self._church = church
            self.churchLists = churchLists.sorted(by: { ($0.CHUR_NM ?? "") < ($1.CHUR_NM ?? "") })
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Picker("", selection: $church) {
                    // ✅ RandomAccessCollection 요구사항 만족 (Array로 래핑)
                    ForEach(churchLists, id: \.CHUR_CD) { v in
                        Text(v.CHUR_NM ?? "").tag(v)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
