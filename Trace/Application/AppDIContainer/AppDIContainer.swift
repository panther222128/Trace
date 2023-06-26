//
//  AppDIContainer.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

final class AppDIContainer {

    lazy var appConfiguration = AppConfiguration()
    
    lazy var apiDataTransferService: DataTransferService = {
        let networkConfiguration = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        let apiDataNetwork = DefaultNetworkService(networkConfiguration: networkConfiguration)
        return DefaultDataTransferService(networkService: apiDataNetwork)
    }()
    
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return SceneDIContainer(dependencies: dependencies)
    }
    
}
