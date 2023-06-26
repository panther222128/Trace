//
//  TraceListUseCase.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

protocol TraceListUseCase {
    func fetchTraces() -> [Trace]
}

final class DefaultTraceListUseCase: TraceListUseCase {
    
    private let repository: TraceListRepository
    
    init(repository: TraceListRepository) {
        self.repository = repository
    }
    
    func fetchTraces() -> [Trace] {
        return repository.fetchTraces()
    }
    
}
