//
//  TraceListViewController.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit
import Combine

final class TraceListViewController: UIViewController, StoryboardInstantiable {
    
    static let storyboardName = "TraceListViewController"
    static let storyboardID = "TraceListViewController"
    
    @IBOutlet weak var traceListTableView: UITableView!
    
    private var viewModel: TraceListViewModel!
    private var cancellable: Set<AnyCancellable> = []
    
    private var traceListAdapter: TraceListAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        traceListAdapter = TraceListAdapter(tableView: traceListTableView, dataSource: viewModel, delegate: self)
        setAddButton()
        subscribeItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            .sink { [weak self] success in
                self?.traceListTableView.reloadData()
            } receiveValue: { [weak self] _ in
                self?.traceListTableView.reloadData()
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
        viewModel.didSelectItem(at: indexPath)
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .normal, title: "Delete", handler: { [weak self] (action, view, completion) in
            self?.viewModel.didDeleteItem(at: indexPath)
            completion(true)
        })
        swipeAction.backgroundColor = UIColor.blue
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        
        return configuration
    }
}
