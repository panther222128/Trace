//
//  TraceRepository.swift
//  Trace
//
//  Created by Horus on 2023/06/27.
//

import Foundation

protocol TraceRepository {
    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void)
    func deleteTrace(at indexPath: IndexPath, completion: @escaping (Result<Trace, Error>) -> Void)
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws 
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void) throws
}
