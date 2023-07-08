//
//  Encryptor.swift
//  Trace
//
//  Created by Horus on 2023/07/01.
//

import Foundation
import CryptoKit

enum EncryptorError: Error {
    case cannotCreateCombined
    case cannotCreateStringData
}

protocol Encryptor {
    func encrypt(data: Data) throws -> Data
}

final class GCMEncryptor: Encryptor {
    
    private let stringKey: String
    
    init(stringKey: String) {
        self.stringKey = stringKey
    }
    
    private func createSymmetrickey(with string: String) throws -> SymmetricKey {
        guard let data = string.data(using: .utf8) else { throw EncryptorError.cannotCreateStringData }
        return SymmetricKey(data: data)
    }
    
    func encrypt(data: Data) throws -> Data {
        let key = try createSymmetrickey(with: stringKey)
        let sealedBox = try AES.GCM.seal(data, using: key)
        guard let combined = sealedBox.combined else { throw EncryptorError.cannotCreateCombined }
        return combined
    }
    
}
