//
//  CustomText.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import SwiftUI
struct CustomText: View {
    @EnvironmentObject var userViewModel: UserViewModel
        var text: String

        init(_ text: String) {
            self.text = text
        }

        var body: some View {
            Text(text)
                .font(.system(size: userViewModel.settings.fontSizeMode ? (CGFloat(userViewModel.settings.fontSize)/10 * 17)  + 17 : 17))
        }
}
