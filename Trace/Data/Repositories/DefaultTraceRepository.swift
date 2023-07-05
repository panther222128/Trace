//
//  DefaultTraceRepository.swift
//  Trace
//
//  Created by Horus on 2023/06/27.
//

import Foundation

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
                    let decryptedData = try entity.map { try self?.decryptor.decrypt(data: $0.encryptedTrace) }
                    let decoded = try decryptedData.map { try JSONDecoder().decode(Trace.self, from: $0 ?? Data()) }
                    completion(.success(decoded))
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            } catch {
                
            }
        }
    }
    
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[Trace], Error>) -> Void) {
        traceStorage.deleteTrace(at: indexPath) { [weak self] result in
            do {
                switch result {
                case .success(let data):
                    let decryptedData = try data.map { try self?.decryptor.decrypt(data: $0.encryptedTrace) }
                    let decoded = try decryptedData.map { try JSONDecoder().decode(Trace.self, from: $0 ?? Data()) }
                    completion(.success(decoded))
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            } catch {
                
            }
        }
    }
    
    func save(trace: Trace) throws {
        do {
            let traceData = try JSONEncoder().encode(trace)
            let encryptedData = try encryptor.encrypt(data: traceData)
            traceStorage.save(data: encryptedData)
        } catch {
            
        }
    }
    
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) {
        do {
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
        } catch {
            
        }
    }
}
