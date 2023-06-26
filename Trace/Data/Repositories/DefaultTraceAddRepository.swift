//
//  DefaultTraceAddRepository.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

final class DefaultTraceAddRepository: TraceAddRepository {
    
    private var traceStorage: TraceStorage
    
    init(traceStorage: TraceStorage) {
        self.traceStorage = traceStorage
    }
    
}

extension DefaultTraceAddRepository {
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) {
        traceStorage.save(trace: trace, completion: completion)
    }
}
