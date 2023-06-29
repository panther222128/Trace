//
//  DefaultTraceRepository.swift
//  Trace
//
//  Created by Horus on 2023/06/27.
//

import Foundation

final class DefaultTraceRepository: TraceRepository {
    
    private var traceStorage: TraceStorage
    
    init(traceStorage: TraceStorage) {
        self.traceStorage = traceStorage
    }
    
}

extension DefaultTraceRepository {
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void) {
        return traceStorage.fetchTraces(completion: completion)
    }
    
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[Trace], Error>) -> Void) {
        return traceStorage.deleteTrace(at: indexPath, completion: completion)
    }
    
    func save(trace: Trace) {
        traceStorage.save(trace: trace)
    }
    
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) {
        traceStorage.updateTrace(at: indexPath, with: trace, completion: completion)
    }
}
