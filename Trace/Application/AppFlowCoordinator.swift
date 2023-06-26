//
//  AppFlowCoordinator.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit

final class AppFlowCoordinator {

    private let tabBarController: UITabBarController
    private let appDIContainer: AppDIContainer
    
    init(tabBarController: UITabBarController, appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let sceneDIContainer = appDIContainer.makeSceneDIContainer()
        let flow = sceneDIContainer.makeViewFlowCoordinator(tabBarController: tabBarController)
        flow.start()
    }
    
}
