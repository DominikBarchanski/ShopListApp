//
//  SettingsViewModel.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
class SettingsViewModel:ObservableObject {
    
    @Published var disabledMode:Bool{
        didSet{
            UserDefaults.standard.set(disabledMode,forKey: "disabledMode")
        }
    }
    @Published var colorBlindMode:Bool{
        didSet{
            UserDefaults.standard.set(colorBlindMode,forKey: "colorBlindMode")
        }
    }
    @Published var voiceOverMode:Bool{
        didSet{
            UserDefaults.standard.set(voiceOverMode,forKey: "voiceOverMode")
        }
    }
    @Published var fontSizeMode:Bool{
        didSet{
            UserDefaults.standard.set(fontSizeMode,forKey: "fontSizeMode")
        }
    }
    @Published var fontSize:Double{
        didSet{
            UserDefaults.standard.set(fontSize,forKey: "fontSizeMode")
        }
    }
    @Published var isTokenSaved:Bool{
        didSet{
            UserDefaults.standard.set(isTokenSaved,forKey: "tokenSaved")
        }
    }
    @Published var keepLogin:Bool{
        didSet{
            UserDefaults.standard.set(keepLogin,forKey: "keepLogin")
        }
    }
    
    init(){
        self.colorBlindMode = UserDefaults.standard.bool(forKey: "colorBlindMode")
        self.voiceOverMode = UserDefaults.standard.bool(forKey: "voiceOverMode")
        self.disabledMode = UserDefaults.standard.bool(forKey: "disabledMode")
        self.fontSizeMode = UserDefaults.standard.bool(forKey: "fontSizeMode")
        self.fontSize = UserDefaults.standard.double(forKey: "fontSizeMode")
        self.isTokenSaved = UserDefaults.standard.bool(forKey: "tokenSaved")
        self.keepLogin = UserDefaults.standard.bool(forKey: "keepLogin")
        
    }

}
