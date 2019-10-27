//
//  AttributedText.swift
//  
//
//  Created by Tiziano Coroneo on 27/10/2019.
//

import Foundation
import SwiftUI

public struct AttributedText: UIViewRepresentable {

    public class LabelView : UIView {
        public let label = UILabel()

        public internal(set) var attributedText: NSAttributedString? {
            get { label.attributedText }
            set { label.attributedText = newValue }
        }

        init() {
            super.init(frame: .zero)

            self.addSubview(label)

            label.numberOfLines = 0
            label.frame = self.bounds
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }

    public let attributedString: NSAttributedString

    public init(
        attributedString: NSAttributedString
    ) {
        self.attributedString = attributedString
    }

    public func makeUIView(
        context: Context
    ) -> LabelView {
        return LabelView()
    }

    public func updateUIView(
        _ uiView: LabelView,
        context: UIViewRepresentableContext<AttributedText>
    ) {
        uiView.attributedText = attributedString
    }
}
