//
//  TraceDetailViewController.swift
//  Trace
//
//  Created by Horus on 2023/06/26.
//

import UIKit
import Combine

final class TraceDetailViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var traceContentTextView: UITextView!
    
    private var viewModel: TraceDetailViewModel!
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(traceContentTextView: traceContentTextView)
        setUpdateButton()
        traceContentTextView.delegate = self
        subscribeContent(from: viewModel)
        subscribeError(from: viewModel)
        subscribeMode(from: viewModel)
        set(contentTextView: traceContentTextView)
        
        viewModel.didLoadTrace()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.didUpdateTrace()
    }

    static func create(with viewModel: TraceDetailViewModel) -> TraceDetailViewController {
        let viewController = TraceDetailViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func set(traceContentTextView: UITextView) {
        traceContentTextView.showsVerticalScrollIndicator = false
        traceContentTextView.showsHorizontalScrollIndicator = false
    }
    
    private func set(contentTextView: UITextView) {
        contentTextView.isEditable = false
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

extension TraceDetailViewController {
    private func subscribeContent(from viewModel: TraceDetailViewModel) {
        viewModel.contentPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
            } receiveValue: { [weak self] content in
                self?.traceContentTextView.text = content
            }
            .store(in: &cancellable)
    }
    
    private func subscribeError(from viewModel: TraceDetailViewModel) {
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
            } receiveValue: { [weak self] error in
                self?.presentAlert(of: error)
            }
            .store(in: &cancellable)
    }
    
    private func subscribeMode(from viewModel: TraceDetailViewModel) {
        viewModel.detailModePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
            } receiveValue: { [weak self] mode in
                switch mode {
                case .read:
                    self?.traceContentTextView.isEditable = false
                    
                case .edit:
                    self?.traceContentTextView.isEditable = true
                    self?.traceContentTextView.becomeFirstResponder()
                    self?.navigationController?.navigationItem.rightBarButtonItem?.style = .done
                    
                case .save:
                    self?.navigationController?.popViewController(animated: true)
                    
                }
            }
            .store(in: &cancellable)

    }
}

extension TraceDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.didEditTrace(for: textView.text)
    }
}

// MARK: - Save trace button
extension TraceDetailViewController {
    private func setUpdateButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(updateButtonAction))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func updateButtonAction(_ sender: UIBarButtonItem) {
        viewModel.didEdit()
    }
}
