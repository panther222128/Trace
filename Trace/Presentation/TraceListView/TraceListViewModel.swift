//
//  TraceListViewModel.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Combine
import Foundation

enum TraceListViewModelError: Error {
    case cannotFindViewModel
}

protocol TraceListViewModel: TraceListDataSource {
    var itemsPublisher: AnyPublisher<[TraceListItemViewModel], Error> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func didSelectAdd()
    func didSelectItem(at indexPath: IndexPath)
    func didFetchItems()
    func didDeleteItem(at indexPath: IndexPath)
}

struct TraceListAction {
    let addTrace: () -> Void
    let select: (Trace, IndexPath) -> Void
}

final class DefaultTraceListViewModel: TraceListViewModel {
    
    private let useCase: TraceListUseCase
    private let action: TraceListAction
    
    private var traces: [Trace] = []
    private let items: CurrentValueSubject<[TraceListItemViewModel], Error>
    private let error: PassthroughSubject<Error, Never>
    
    var itemsPublisher: AnyPublisher<[TraceListItemViewModel], Error> {
        items.eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        error.eraseToAnyPublisher()
    }
    
    init(useCase: TraceListUseCase, action: TraceListAction) {
        self.useCase = useCase
        self.action = action
        self.items = CurrentValueSubject([])
        self.error = PassthroughSubject()
    }
    
    func didSelectAdd() {
        action.addTrace()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        action.select(traces[indexPath.row], indexPath)
    }
    
    func didFetchItems() {
        useCase.fetchTraces(completion: { [weak self] result in
            switch result {
            case .success(let traces):
                self?.traces = traces
                self?.items.value = traces.map { .init(trace: $0) }
                
            case .failure(let error):
                self?.error.send(error)
                
            }
        })
    }
    
    func didDeleteItem(at indexPath: IndexPath) {
        useCase.deleteTrace(at: indexPath) { [weak self] result in
            switch result {
            case .success(_):
                guard let self = self else {
                    self?.error.send(TraceListViewModelError.cannotFindViewModel)
                    return
                }
                self.traces.remove(at: indexPath.row)
                self.items.value = self.traces.map { .init(trace: $0) }
                
            case .failure(let error):
                self?.error.send(error)
                
            }
        }
    }
    
}

extension DefaultTraceListViewModel {
    func numberOfCell() -> Int {
        return traces.count
    }
    
    func loadTrace(at index: Int) -> TraceListItemViewModel {
        return .init(trace: traces[index])
    }
}
