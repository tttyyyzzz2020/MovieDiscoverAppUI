//
//  FontExt.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import SwiftUI


extension Font {
    static func FHACondFrenchNC(size: CGFloat) -> Font {
        Font.custom("FHA condensed French NC", size: size)
    }
}

struct TitleFont: ViewModifier {
    var size: CGFloat = 16
    func body(content: Content) -> some View {
        content.font(.FHACondFrenchNC(size: size))
    }
}


extension View {
    func titleFont(size: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: TitleFont(size: size))
    }
}
