//
//  TraceListRepository.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

protocol TraceListRepository {
    func fetchTraces() -> [Trace]
}
