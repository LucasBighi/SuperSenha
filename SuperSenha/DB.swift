//
//  DB.swift
//  SuperSenha
//
//  Created by Lucas Bighi on 15/01/21.
//  Copyright © 2021 Lucas Marques Bighi. All rights reserved.
//

import Foundation

struct DB {
    
    static let defaults = UserDefaults.standard
    static let storedPasswordsKey = "storedPasswords"
    
    static func store(password: String) {
        if var storedPasswords = getPasswords() {
            storedPasswords.append(password)
            defaults.setValue(storedPasswords, forKey: storedPasswordsKey)
        } else {
            defaults.setValue([password], forKey: storedPasswordsKey)
        }
    }
    
    static func getPasswords() -> [String]? {
        return defaults.array(forKey: storedPasswordsKey) as? [String]
    }
}
