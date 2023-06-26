//
//  TraceListAdapter.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit

protocol TraceListDataSource: AnyObject {
    func numberOfCell() -> Int
    func loadTrace(at index: Int) -> TraceListItemViewModel
}

protocol TraceListDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
    func heightForRow(at indexPath: IndexPath) -> CGFloat
}

final class TraceListAdapter: NSObject {
    
    private let tableView: UITableView
    weak var dataSource: TraceListDataSource?
    weak var delegate: TraceListDelegate?
    
    init(tableView: UITableView, dataSource: TraceListDataSource?, delegate: TraceListDelegate?) {
        tableView.register(TraceListTableViewCell.self, forCellReuseIdentifier: "TraceListTableViewCell")
        self.tableView = tableView
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension TraceListAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfCell() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TraceListTableViewCell", for: indexPath) as? TraceListTableViewCell else { return .init() }
        guard let dataSource = dataSource else { return .init() }
        let traceListItemViewModel = dataSource.loadTrace(at: indexPath.row)
        cell.configure(with: traceListItemViewModel)
        return cell
    }
}

extension TraceListAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
}
