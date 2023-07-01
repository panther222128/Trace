//
//  Encryptor.swift
//  Trace
//
//  Created by Horus on 2023/07/01.
//

import Foundation
import CryptoKit

enum EncryptorError: Error {
    case cannotFindData
    case cannotCreateCombined
}

protocol Encryptor {
    func encrypt(text: String) throws -> Data
}

final class GCMEncryptor: Encryptor {
    
    private let key: SymmetricKey
    
    init(key: SymmetricKey) {
        self.key = key
    }
    
    func encrypt(text: String) throws -> Data {
        guard let data = text.data(using: .utf8) else { throw EncryptorError.cannotFindData }
        let sealedBox = try AES.GCM.seal(data, using: key)
        guard let combined = sealedBox.combined else { throw EncryptorError.cannotCreateCombined }
        return combined
    }
    
}
