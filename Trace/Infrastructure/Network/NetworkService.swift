//
//  NetworkService.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkService {
    func request(endpoint: some Requestable, completion: @escaping (Result<Data?, NetworkError>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    
    private let networkConfiguration: NetworkConfigurable
    
    init(networkConfiguration: NetworkConfigurable) {
        self.networkConfiguration = networkConfiguration
    }
    
    func request(endpoint: some Requestable, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        do {
            let urlRequest = try endpoint.urlRequest(with: networkConfiguration)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
        }
    }
    
    private func request(request: URLRequest, completion: @escaping ((Result<Data?, NetworkError>) -> Void)) {
        let task = URLSession.shared.dataTask(with: request) { data, response, requestError in
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        task.resume()
    }

    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
}
