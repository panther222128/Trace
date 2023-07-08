//
//  TraceDetailUseCase.swift
//  Trace
//
//  Created by Horus on 2023/06/27.
//

import Foundation

protocol TraceDetailUseCase {
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws
}

final class DefaultTraceDetailUseCase: TraceDetailUseCase {
    
    private let repository: TraceRepository
    
    init(repository: TraceRepository) {
        self.repository = repository
    }
    
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws {
        return try repository.updateTrace(at: indexPath, with: trace, completion: completion)
    }
    
}
