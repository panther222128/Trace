//
//  TraceAddRepository.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

protocol TraceAddRepository {
    func save(trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void)
}
