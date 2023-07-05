//
//  TraceStorage.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation
import CoreData

protocol TraceStorage {
    func fetchTraces(completion: @escaping (Result<[EncryptedTraceEntity], Error>) -> Void)
    func save(data: Data)
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[EncryptedTraceEntity], Error>) -> Void)
    func updateTrace(at indexPath: IndexPath, with data: Data, completion: @escaping (Result<EncryptedTraceEntity, Error>) -> Void)
}

final class DefaultTraceStorage {
    
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension DefaultTraceStorage: TraceStorage {
    func fetchTraces(completion: @escaping (Result<[EncryptedTraceEntity], Error>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = EncryptedTraceEntity.fetchRequest()
                let result = try context.fetch(request)
                completion(.success(result))
            } catch {
                
            }
        }
    }

    func save(data: Data) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            do {
                let entity = try EncryptedTraceEntity(encryptedData: data, insertInto: context)
                entity.encryptedTrace = data
                try context.save()
            } catch {
                
            }
        }
    }
    
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[EncryptedTraceEntity], Error>) -> Void) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            do {
                let request: NSFetchRequest = EncryptedTraceEntity.fetchRequest()
                let result = try context.fetch(request)
                context.delete(result[indexPath.row])
                try context.save()
                
                completion(.success(result))
            } catch {
                
            }
        }
    }
    
    func updateTrace(at indexPath: IndexPath, with data: Data, completion: @escaping (Result<EncryptedTraceEntity, Error>) -> Void) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            do {
                let request: NSFetchRequest = EncryptedTraceEntity.fetchRequest()
                let traces = try context.fetch(request)
                let target = traces[indexPath.row]
                
                target.setValue(data, forKey: "encryptedTrace")
                
                try context.save()
                completion(.success(target))
            } catch {
                
            }
        }
    }
}
