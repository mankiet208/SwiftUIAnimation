//
//  PreferenceKeys.swift
//  HeaderAnimation
//
//  Created by Kiet Truong on 04/11/2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
