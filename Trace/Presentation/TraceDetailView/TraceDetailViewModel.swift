//
//  TraceDetailViewModel.swift
//  Trace
//
//  Created by Horus on 2023/06/26.
//

import Foundation

struct TraceDetailViewModel {
    let title: String
    let content: String
}

extension TraceDetailViewModel {
    init(trace: Trace) {
        self.title = trace.title
        self.content = trace.content
    }
}
