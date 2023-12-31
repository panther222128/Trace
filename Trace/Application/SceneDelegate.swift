//
//  SceneDelegate.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let appDIContainer = AppDIContainer()
    private var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()

        window?.rootViewController = tabBarController
        self.appFlowCoordinator = AppFlowCoordinator(tabBarController: tabBarController, appDIContainer: appDIContainer)
        
        self.appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }

}


