//
//  TraceListUseCase.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

protocol TraceListUseCase {
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void)
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[Trace], Error>) -> Void)
}

final class DefaultTraceListUseCase: TraceListUseCase {
    
    private let repository: TraceListRepository
    
    init(repository: TraceListRepository) {
        self.repository = repository
    }
    
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void) {
        return repository.fetchTraces(completion: completion)
    }
    
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<[Trace], Error>) -> Void) {
        repository.deleteTrace(at: indexPath, completion: completion)
    }
    
}
