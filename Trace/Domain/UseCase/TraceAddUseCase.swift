//
//  TraceAddUseCase.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

protocol TraceAddUseCase {
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws
}

final class DefaultTraceAddUseCase: TraceAddUseCase {
    
    private let repository: TraceRepository
    
    init(repository: TraceRepository) {
        self.repository = repository
    }
    
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws {
        return try repository.save(trace: trace, completion: completion)
    }
    
}
