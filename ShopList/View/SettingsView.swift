//
//  SettingsView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $userViewModel.settings.keepLogin) {
                    CustomText("Do you want to stay logged in?")
                }
                .accessibilityLabel("Keep me logged in")
                
                Toggle(isOn: $userViewModel.settings.disabledMode) {
                    CustomText("Enable disabled mode")
                }
                .accessibilityLabel("Enable disabled mode")
                .onChange(of: userViewModel.settings.disabledMode) { newValue in
                    if newValue {
                        userViewModel.settings.voiceOverMode = true
                        userViewModel.settings.fontSizeMode = true
                    }
                }
                
                Toggle(isOn: $userViewModel.settings.colorBlindMode) {
                    CustomText("Enable color blind mode")
                }
                .accessibilityLabel("Enable color blind mode")
                
                Toggle(isOn: $userViewModel.settings.voiceOverMode) {
                    CustomText("Enable voice over mode")
                }
                .accessibilityLabel("Enable voice over mode")
                
                Toggle(isOn: $userViewModel.settings.fontSizeMode) {
                    CustomText("Enable font size mode")
                }
                .accessibilityLabel("Enable font size mode")
                
                HStack {
                    CustomText("Font Size")
                    Slider(value: $userViewModel.settings.fontSize, in: 1...5, step: 1)
                }
                .disabled(!$userViewModel.settings.fontSizeMode.wrappedValue)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Font Size")
                .accessibilityValue("\(userViewModel.settings.fontSize)")
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .accessibilityLabel("Settings")
        }
    }
}
