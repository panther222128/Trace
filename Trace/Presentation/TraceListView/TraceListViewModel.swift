//
//  TraceListViewModel.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Combine

protocol TraceListViewModel: TraceListDataSource {
    var items: CurrentValueSubject<[TraceListItemViewModel], Error> { get }
    var error: PassthroughSubject<Error, Never> { get }
    
    func didSelectAdd()
    func didFetchItems()
}

struct TraceListAction {
    let addTrace: () -> Void
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
    
    func didFetchItems() {
        useCase.fetchTraces { result in
            switch result {
            case .success(let traces):
                print(traces)
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
