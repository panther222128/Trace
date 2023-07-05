//
//  TraceAddViewModel.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Combine

protocol TraceAddViewModel {
    var content: CurrentValueSubject<String, Error> { get }
    
    func didSelectSave(trace: Trace) throws
}

final class DefaultTraceAddViewModel: TraceAddViewModel {
    
    private let useCase: TraceAddUseCase
    
    private(set) var content: CurrentValueSubject<String, Error>
    
    init(useCase: TraceAddUseCase) {
        self.useCase = useCase
        self.content = CurrentValueSubject(.init())
    }
    
    func didSelectSave(trace: Trace) throws {
        do {
            try useCase.save(trace: trace)
        } catch {
            
        }
    }
    
}
