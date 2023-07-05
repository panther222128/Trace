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
    
    lazy var encryptor: Encryptor = {
        return GCMEncryptor(stringKey: appConfiguration.gcmKey)
    }()
    
    lazy var decryptor: Decryptor = {
        return GCMDecryptor(stringKey: appConfiguration.gcmKey)
    }()
    
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService, encryptor: encryptor, decryptor: decryptor)
        return SceneDIContainer(dependencies: dependencies)
    }
    
}
