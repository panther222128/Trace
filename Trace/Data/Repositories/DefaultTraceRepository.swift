//
//  DefaultTraceRepository.swift
//  Trace
//
//  Created by Horus on 2023/06/27.
//

import Foundation

enum TraceRepositoryError: Error {
    case decrypt
    case encrypt
    case decode
    case encode
}

final class DefaultTraceRepository: TraceRepository {

    private var traceStorage: TraceStorage
    private let decryptor: Decryptor
    private let encryptor: Encryptor
    
    init(traceStorage: TraceStorage, decryptor: Decryptor, encryptor: Encryptor) {
        self.traceStorage = traceStorage
        self.decryptor = decryptor
        self.encryptor = encryptor
    }
    
}

extension DefaultTraceRepository {
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void) {
        traceStorage.fetchTraces { [weak self] result in
            do {
                switch result {
                case .success(let entity):
                    let decryptedData = try entity.compactMap { try self?.decryptor.decrypt(data: $0.encryptedTrace) }
                    let decoded = try decryptedData.map { try JSONDecoder().decode(Trace.self, from: $0) }
                    completion(.success(decoded))
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<IndexPath, Error>) -> Void) {
        traceStorage.deleteTrace(at: indexPath) { [weak self] result in
            do {
                switch result {
                case .success(_):
                    completion(.success(indexPath))
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws {
        let traceData = try JSONEncoder().encode(trace)
        let encryptedData = try encryptor.encrypt(data: traceData)
        traceStorage.save(data: encryptedData) { result in
            switch result {
            case .success(_):
                completion(.success(trace))
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws {
        let encoded = try JSONEncoder().encode(trace)
        let encrypted = try encryptor.encrypt(data: encoded)
        traceStorage.updateTrace(at: indexPath, with: encrypted) { result in
            switch result {
            case .success(_):
                completion(.success(trace))
            
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}
