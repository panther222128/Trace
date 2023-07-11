//
//  TraceDetailViewModel.swift
//  Trace
//
//  Created by Horus on 2023/06/26.
//

import Foundation
import Combine

protocol TraceDetailViewModel {
    var errorPublisher: AnyPublisher<Error, Never> { get }
    var titlePublisher: AnyPublisher<String, Never> { get }
    var contentPublisher: AnyPublisher<String, Never> { get }
    var detailModePublisher: AnyPublisher<DefaultTraceDetailViewModel.DetailMode, Never> { get }
    
    func didLoadTrace()
    func didEditTrace(for text: String)
    func didUpdateTrace()
    func didEdit()
}

final class DefaultTraceDetailViewModel: TraceDetailViewModel {
    
    enum DetailMode {
        case read
        case edit
        case save
    }
    
    private let useCase: TraceDetailUseCase
    
    private let title: CurrentValueSubject<String, Never>
    private let content: CurrentValueSubject<String, Never>
    private let error: PassthroughSubject<Error, Never>
    private let mode: CurrentValueSubject<DetailMode, Never>
    
    var titlePublisher: AnyPublisher<String, Never> {
        return title.eraseToAnyPublisher()
    }
    var contentPublisher: AnyPublisher<String, Never> {
        return content.eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        return error.eraseToAnyPublisher()
    }
    var detailModePublisher: AnyPublisher<DetailMode, Never> {
        return mode.eraseToAnyPublisher()
    }
    
    private var traceTitle: String
    private var traceContent: String
    private let indexPath: IndexPath
    private var detailMode: DetailMode
    
    init(useCase: TraceDetailUseCase, trace: Trace, indexPath: IndexPath) {
        self.useCase = useCase
        self.title = CurrentValueSubject(trace.title)
        self.content = CurrentValueSubject(trace.content)
        self.error = PassthroughSubject()
        self.mode = CurrentValueSubject(.read)
        self.traceTitle = trace.title
        self.traceContent = trace.content
        self.indexPath = indexPath
        self.detailMode = .read
    }
    
    func didLoadTrace() {
        title.send(traceTitle)
        content.send(traceContent)
    }
    
    func didEditTrace(for text: String) {
        title.value = text
        content.value = text
        traceTitle = text
        traceContent = text
    }
    
    func didUpdateTrace() {
        do {
            try useCase.updateTrace(at: indexPath, with: .init(title: traceTitle, content: traceContent)) { [weak self] result in
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
        switch detailMode {
        case .read:
            self.detailMode = .edit
            mode.send(detailMode)
            
        case .edit:
            self.detailMode = .save
            mode.send(detailMode)
            
        case .save:
            self.detailMode = .read
            mode.send(detailMode)
            
        }
    }
    
}
