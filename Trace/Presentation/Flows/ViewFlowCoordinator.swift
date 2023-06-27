//
//  ViewFlowCoordinator.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit

protocol ViewFlowCoordinatorDependencies {
    func makeTraceListViewController(action: TraceListAction) -> TraceListViewController
    func makeTraceAddViewController() -> TraceAddViewController
    func makeTraceDetailViewController(of trace: Trace, indexPath: IndexPath) -> TraceDetailViewController
}

final class ViewFlowCoordinator {
    
    private weak var traceListViewController: TraceListViewController?
    private var navigationController: UINavigationController?
    private weak var tabBarController: UITabBarController?
    private let dependencies: ViewFlowCoordinatorDependencies

    init(tabBarController: UITabBarController, dependencies: ViewFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        tabBarController?.tabBar.tintColor = .black
        tabBarController?.tabBar.unselectedItemTintColor = .black

        navigationController = UINavigationController()
        guard let navigationController = navigationController else { return }
        
        let action = TraceListAction(addTrace: showTraceAddView, select: showTraceDetailView)
        
        let traceListViewController = dependencies.makeTraceListViewController(action: action)
        
        tabBarController?.viewControllers = [navigationController]
        navigationController.pushViewController(traceListViewController, animated: true)
        
        self.traceListViewController = traceListViewController
    }
    
    private func showTraceAddView() {
        let viewController = dependencies.makeTraceAddViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showTraceDetailView(of trace: Trace, indexPath: IndexPath) {
        let viewController = dependencies.makeTraceDetailViewController(of: trace, indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
