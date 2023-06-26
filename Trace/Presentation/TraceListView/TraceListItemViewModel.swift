//
//  TraceListItemViewModel.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import Foundation

struct TraceListItemViewModel {
    let title: String
}

extension TraceListItemViewModel {
    init(trace: Trace) {
        self.title = trace.title
    }
}
