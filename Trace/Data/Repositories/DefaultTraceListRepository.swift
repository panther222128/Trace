//
//  DefaultTraceListRepository.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

final class DefaultTraceListRepository: TraceListRepository {
    
    private var traceStorage: TraceStorage
    
    init(traceStorage: TraceStorage) {
        self.traceStorage = traceStorage
    }
    
}

extension DefaultTraceListRepository {
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void) {
        return traceStorage.fetchTraces(completion: completion)
    }
}
