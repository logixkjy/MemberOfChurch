//
//  KeyboardPrewarmView.swift
//  MemberOfChurch
//
//  Created by JooYoung Kim on 8/19/25.
//

import Foundation
import SwiftUI

struct KeyboardPrewarmView: UIViewRepresentable {
  func makeUIView(context: Context) -> UITextField {
    let tf = UITextField(frame: .zero)
    tf.isHidden = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      tf.becomeFirstResponder()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
        tf.resignFirstResponder()
      }
    }
    return tf
  }
  func updateUIView(_ uiView: UITextField, context: Context) {}
}
