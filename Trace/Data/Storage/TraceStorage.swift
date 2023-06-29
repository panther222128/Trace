//
//  TraceStorage.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation
import CoreData

protocol TraceStorage {
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void)
    func save(trace: Trace)
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[Trace], Error>) -> Void)
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void)
}

final class DefaultTraceStorage {
    
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension DefaultTraceStorage: TraceStorage {
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = TraceEntity.fetchRequest()
                let result = try context.fetch(request).map { $0.toDomain() }
                completion(.success(result))
            } catch {
                
            }
        }
    }

    func save(trace: Trace) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            do {
                let entity = TraceEntity(trace: trace, insertInto: context)
                try context.save()
            } catch {
                
            }
        }
    }
    
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[Trace], Error>) -> Void) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            do {
                let request: NSFetchRequest = TraceEntity.fetchRequest()
                let result = try context.fetch(request)
                context.delete(result[indexPath.row])
                try context.save()
                
                completion(.success(result.map { $0.toDomain() }))
            } catch {
                
            }
        }
    }
    
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            do {
                let request: NSFetchRequest = TraceEntity.fetchRequest()
                let traces = try context.fetch(request)
                let target = traces[indexPath.row]
                
                target.setValue(trace.title, forKey: "title")
                target.setValue(trace.content, forKey: "content")
                
                try context.save()
                completion(.success(trace))
            } catch {
                
            }
        }
    }
}
