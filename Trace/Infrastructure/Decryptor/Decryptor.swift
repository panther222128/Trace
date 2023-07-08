//
//  Decryptor.swift
//  Trace
//
//  Created by Horus on 2023/07/01.
//

import Foundation
import CryptoKit

enum DecryptorError: Error {
    case cannotDecrypt
    case cannotCreateStringData
}

protocol Decryptor {
    func decrypt(data: Data) throws -> Data
}

final class GCMDecryptor: Decryptor {
    
    private let stringKey: String
    
    init(stringKey: String) {
        self.stringKey = stringKey
    }
    
    private func createSymmetrickey(with string: String) throws -> SymmetricKey {
        guard let data = string.data(using: .utf8) else { throw DecryptorError.cannotCreateStringData }
        return SymmetricKey(data: data)
    }
    
    func decrypt(data: Data) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let key = try createSymmetrickey(with: stringKey)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return decryptedData
    }
    
}
