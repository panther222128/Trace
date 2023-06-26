//
//  DataTransferService.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

enum DataTransferServiceError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferService {
    func request<T: Decodable, E: Requestable>(with endpoint: E, completion: @escaping (Result<T, DataTransferServiceError>) -> Void) where E.Response == T
}

protocol DataTransferServiceErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

final class DefaultDataTransferService: DataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferServiceErrorResolver
    
    init(networkService: NetworkService, errorResolver: DataTransferServiceErrorResolver = DefaultDataTransferServiceErrorResolver()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
    }
    
    func request<T: Decodable, E: Requestable>(with endpoint: E, completion: @escaping (Result<T, DataTransferServiceError>) -> Void) where E.Response == T {
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferServiceError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async { completion(result) }
            case .failure(let error):
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferServiceError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferServiceError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
    
}

final class DefaultDataTransferServiceErrorResolver: DataTransferServiceErrorResolver {
    
    init() {
        
    }
    
    func resolve(error: NetworkError) -> Error {
        return error
    }
    
}

final class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
