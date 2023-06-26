//
//  TraceAddUseCase.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

protocol TraceAddUseCase {
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void)
}

final class DefaultTraceAddUseCase: TraceAddUseCase {
    
    private let repository: TraceAddRepository
    
    init(repository: TraceAddRepository) {
        self.repository = repository
    }
    
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) {
        repository.save(trace: trace, completion: completion)
    }
    
}
