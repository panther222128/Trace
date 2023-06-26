//
//  TraceListViewController.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit
import Combine

final class TraceListViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var traceListTableView: UITableView!
    
    private var viewModel: TraceListViewModel!
    private var cancellable: Set<AnyCancellable> = []
    
    private var traceListAdapter: TraceListAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        traceListAdapter = TraceListAdapter(tableView: traceListTableView, dataSource: viewModel, delegate: self)
        setAddButton()
        subscribeItem()
        
        viewModel.didFetchItems()
    }

    static func create(with viewModel: TraceListViewModel) -> TraceListViewController {
        let viewController = TraceListViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
}

// MARK: - Subscribe
extension TraceListViewController {
    private func subscribeItem() {
        viewModel.items
            .receive(on: DispatchQueue.main)
            .sink { success in
                
            } receiveValue: { _ in
                self.traceListTableView.reloadData()
            }
            .store(in: &cancellable)
    }
}

// MARK: - Add trace button
extension TraceListViewController {
    private func setAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonAction() {
        viewModel.didSelectAdd()
    }
}

// MARK: - Delegate
extension TraceListViewController: TraceListDelegate {
    func didSelectItem(at indexPath: IndexPath) {
        
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
