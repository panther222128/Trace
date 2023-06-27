//
//  TraceDetailRepository.swift
//  Trace
//
//  Created by Horus on 2023/06/27.
//

import Foundation

protocol TraceDetailRepository {
    func updateTrace(at indexPath: IndexPath, with trace: Trace, completion: @escaping (Result<Trace, Error>) -> Void)
}
