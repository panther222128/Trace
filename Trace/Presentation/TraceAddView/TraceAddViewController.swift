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
        set(traceContentTextView: traceContentTextView)
        subscribeContent(from: viewModel)
        subscribeError(from: viewModel)
        setDoneButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    static func create(with viewModel: TraceAddViewModel) -> TraceAddViewController {
        let viewController = TraceAddViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func set(traceContentTextView: UITextView) {
        traceContentTextView.showsVerticalScrollIndicator = false
        traceContentTextView.showsHorizontalScrollIndicator = false
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        traceContentTextView.contentInset.bottom = keyboardHeight
        traceContentTextView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        traceContentTextView.contentInset = .zero
        traceContentTextView.verticalScrollIndicatorInsets = .zero
    }
    
}

extension TraceAddViewController {
    private func subscribeContent(from viewModel: TraceAddViewModel) {
        viewModel.contentPublisher
            .receive(on: DispatchQueue.main)
            .sink { success in
                
            } receiveValue: { content in
                self.traceContentTextView.text = content
            }
            .store(in: &cancellable)
    }
    
    private func subscribeError(from viewModel: TraceAddViewModel) {
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
            } receiveValue: { [weak self] error in
                self?.presentAlert(of: error)
            }
            .store(in: &cancellable)
    }
}

// MARK: - Save trace button
extension TraceAddViewController {
    private func setDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func saveButtonAction() {
        do {
            try viewModel.didSelectSave(trace: .init(title: traceContentTextView.text, content: traceContentTextView.text))
            navigationController?.popViewController(animated: true)
        } catch {
            
        }
     }
}
