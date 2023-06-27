//
//  SceneDIContainer.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit

final class SceneDIContainer: ViewFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    lazy var traceStorage: TraceStorage = DefaultTraceStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeViewFlowCoordinator(tabBarController: UITabBarController) -> ViewFlowCoordinator {
        return ViewFlowCoordinator(tabBarController: tabBarController, dependencies: self)
    }
    
}

extension SceneDIContainer {
    func makeTraceListRepository() -> TraceListRepository {
        return DefaultTraceListRepository(traceStorage: traceStorage)
    }
    
    func makeTraceListUseCase() -> TraceListUseCase {
        return DefaultTraceListUseCase(repository: makeTraceListRepository())
    }
    
    func makeTraceListViewModel(action: TraceListAction) -> TraceListViewModel {
        return DefaultTraceListViewModel(useCase: makeTraceListUseCase(), action: action)
    }

    func makeTraceListViewController(action: TraceListAction) -> TraceListViewController {
        return TraceListViewController.create(with: makeTraceListViewModel(action: action))
    }
}

extension SceneDIContainer {
    func makeTraceAddRepository() -> TraceAddRepository {
        return DefaultTraceAddRepository(traceStorage: traceStorage)
    }
    
    func makeTraceAddUseCase() -> TraceAddUseCase {
        return DefaultTraceAddUseCase(repository: makeTraceAddRepository())
    }
    
    func makeTraceAddViewModel() -> TraceAddViewModel {
        return DefaultTraceAddViewModel(useCase: makeTraceAddUseCase())
    }
    
    func makeTraceAddViewController() -> TraceAddViewController {
        return TraceAddViewController.create(with: makeTraceAddViewModel())
    }
}

extension SceneDIContainer {
    func makeTraceDetailRepository() -> TraceDetailRepository {
        return DefaultTraceDetailRepository(traceStorage: traceStorage)
    }
    
    func makeTraceDetailUseCase() -> TraceDetailUseCase {
        return DefaultTraceDetailUseCase(repository: makeTraceDetailRepository())
    }
    
    func makeTraceDetailViewModel(of trace: Trace, indexPath: IndexPath) -> TraceDetailViewModel {
        return DefaultTraceDetailViewModel(useCase: makeTraceDetailUseCase(), trace: trace, indexPath: indexPath)
    }
    
    func makeTraceDetailViewController(of trace: Trace, indexPath: IndexPath) -> TraceDetailViewController {
        return TraceDetailViewController.create(with: makeTraceDetailViewModel(of: trace, indexPath: indexPath))
    }
}
