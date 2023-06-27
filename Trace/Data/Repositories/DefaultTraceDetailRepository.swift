//
//  DefaultTraceDetailRepository.swift
//  Trace
//
//  Created by Horus on 2023/06/27.
//

import Foundation

final class DefaultTraceDetailRepository: TraceDetailRepository {
    
    private var traceStorage: TraceStorage
    
    init(traceStorage: TraceStorage) {
        self.traceStorage = traceStorage
    }
    
}

extension DefaultTraceDetailRepository {
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) {
        traceStorage.updateTrace(at: indexPath, with: trace, completion: completion)
    }
}
