//
//  TraceListViewModel.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Combine
import Foundation

protocol TraceListViewModel: TraceListDataSource {
    var items: CurrentValueSubject<[TraceListItemViewModel], Error> { get }
    var error: PassthroughSubject<Error, Never> { get }
    
    func didSelectAdd()
    func didSelectItem(at indexPath: IndexPath)
    func didFetchItems()
    func didDeleteItem(at indexPath: IndexPath)
}

struct TraceListAction {
    let addTrace: () -> Void
    let select: (Trace) -> Void
}

final class DefaultTraceListViewModel: TraceListViewModel {
    
    private let useCase: TraceListUseCase
    private let action: TraceListAction
    
    private var traces: [Trace] = []
    private(set) var items: CurrentValueSubject<[TraceListItemViewModel], Error>
    private(set) var error: PassthroughSubject<Error, Never>
    
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
        action.select(traces[indexPath.row])
    }
    
    func didFetchItems() {
        useCase.fetchTraces(completion: { [weak self] result in
            switch result {
            case .success(let traces):
                self?.traces = traces
                self?.items.value = traces.map { .init(trace: $0) }
                
            case .failure(let failure):
                print(failure)
                
            }
        })
    }
    
    func didDeleteItem(at indexPath: IndexPath) {
        useCase.deleteTrace(at: indexPath) { [weak self] result in
            switch result {
            case .success(let traces):
                self?.traces.remove(at: indexPath.row)
                self?.items.value = traces.map { .init(trace: $0) }
                
            case .failure(let failure):
                print(failure)
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
