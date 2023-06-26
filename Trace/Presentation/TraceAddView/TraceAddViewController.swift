//
//  TraceAddViewController.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit
import Combine

final class TraceAddViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var traceContentTextView: UITextView!
    
    private var viewModel: TraceAddViewModel!
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeContent()
        setSaveButton()
    }
    
    static func create(with viewModel: TraceAddViewModel) -> TraceAddViewController {
        let viewController = TraceAddViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
}

extension TraceAddViewController {
    private func subscribeContent() {
        viewModel.content
            .receive(on: DispatchQueue.main)
            .sink { success in
                
            } receiveValue: { content in
                self.traceContentTextView.text = content
            }
            .store(in: &cancellable)
    }
}

// MARK: - 
extension TraceAddViewController: UITextViewDelegate {
    
}

// MARK: - Save trace button
extension TraceAddViewController {
    private func setSaveButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func saveButtonAction() {
        viewModel.didSelectSave(trace: .init(title: traceContentTextView.text, content: traceContentTextView.text))
    }
}
