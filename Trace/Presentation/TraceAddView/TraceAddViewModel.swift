//
//  TraceAddViewModel.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Combine

protocol TraceAddViewModel {
    var contentPublisher: AnyPublisher<String, Error> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func didSelectSave(trace: Trace) throws
}

final class DefaultTraceAddViewModel: TraceAddViewModel {
    
    private let useCase: TraceAddUseCase
    
    private let content: CurrentValueSubject<String, Error>
    private let error: PassthroughSubject<Error, Never>
    
    var contentPublisher: AnyPublisher<String, Error> {
        content.eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        error.eraseToAnyPublisher()
    }
    
    init(useCase: TraceAddUseCase) {
        self.useCase = useCase
        self.content = CurrentValueSubject(.init())
        self.error = PassthroughSubject()
    }
    
    func didSelectSave(trace: Trace) throws {
        do {
            try useCase.save(trace: trace, completion: { [weak self] result in
                switch result {
                case .success(let trace):
                    print(trace)
                    
                case .failure(let error):
                    self?.error.send(error)
                    
                }
            })
        } catch let error {
            self.error.send(error)
        }
    }
    
}
