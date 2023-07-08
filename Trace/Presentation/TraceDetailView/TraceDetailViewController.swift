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
        traceContentTextView.delegate = self
        subscribeError()
        setUpdateButton()
        set(contentTextView: traceContentTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    static func create(with viewModel: TraceDetailViewModel) -> TraceDetailViewController {
        let viewController = TraceDetailViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func set(contentTextView: UITextView) {
        contentTextView.isEditable = false
        contentTextView.text = viewModel.content
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
    private func subscribeError() {
        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
            } receiveValue: { [weak self] error in
                self?.presentAlert(of: error)
            }
            .store(in: &cancellable)
    }
}

extension TraceDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.didUpdateTrace(with: .init(title: textView.text, content: textView.text))
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
        let buttonState = viewModel.editButtonState
        updateButtonActionForMode(sender, isEditMode: buttonState)
    }
    
    private func updateButtonActionForMode(_ sender: UIBarButtonItem, isEditMode: Bool) {
        if !isEditMode {
            traceContentTextView.isEditable = true
            traceContentTextView.becomeFirstResponder()
            navigationController?.navigationItem.rightBarButtonItem?.style = .done
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
