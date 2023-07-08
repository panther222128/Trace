//
//  TraceAddViewModel.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Combine

protocol TraceAddViewModel {
    var error: PassthroughSubject<Error, Never> { get }
    var content: CurrentValueSubject<String, Error> { get }
    
    func didSelectSave(trace: Trace) throws
}

final class DefaultTraceAddViewModel: TraceAddViewModel {
    
    private let useCase: TraceAddUseCase
    
    private(set) var content: CurrentValueSubject<String, Error>
    private(set) var error: PassthroughSubject<Error, Never>
    
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
