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
}

protocol Decryptor {
    func decrypt(data: Data) throws -> String
}

final class GCMDecryptor: Decryptor {
    
    private let key: SymmetricKey
    
    init(key: SymmetricKey) {
        self.key = key
    }
    
    func decrypt(data: Data) throws -> String {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else { throw DecryptorError.cannotDecrypt }
        return decryptedString
    }
    
}
