//
//  TraceDetailViewModel.swift
//  Trace
//
//  Created by Horus on 2023/06/26.
//

import Foundation
import Combine

protocol TraceDetailViewModel {
    var error: PassthroughSubject<Error, Never> { get }
    var title: String { get }
    var content: String { get }
    var editButtonState: Bool { get }
    
    func didUpdateTrace(with trace: Trace)
    func didEdit()
}

final class DefaultTraceDetailViewModel: TraceDetailViewModel {
    
    private let useCase: TraceDetailUseCase
    
    private(set) var error: PassthroughSubject<Error, Never>
    
    private let trace: Trace
    private let indexPath: IndexPath
    private(set) var title: String
    private(set) var content: String
    private(set) var editButtonState: Bool
    
    init(useCase: TraceDetailUseCase, trace: Trace, indexPath: IndexPath) {
        self.useCase = useCase
        self.error = PassthroughSubject()
        self.trace = trace
        self.indexPath = indexPath
        self.title = trace.title
        self.content = trace.content
        self.editButtonState = true
    }
    
    func didUpdateTrace(with trace: Trace) {
        do {
            try useCase.updateTrace(at: indexPath, with: trace) { [weak self] result in
                switch result {
                case .success(let success):
                    print(success)
                    
                case .failure(let error):
                    self?.error.send(error)
                    
                }
            }
        } catch let error {
            self.error.send(error)
        }
    }
    
    func didEdit() {
        editButtonState.toggle()
    }
    
}
