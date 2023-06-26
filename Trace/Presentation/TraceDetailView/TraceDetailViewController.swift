//
//  TraceDetailViewController.swift
//  Trace
//
//  Created by Horus on 2023/06/26.
//

import UIKit

final class TraceDetailViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var contentTextView: UITextView!
    
    private var viewModel: TraceDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.text = viewModel.content
        contentTextView.isEditable = false
    }
    
    static func create(with viewModel: TraceDetailViewModel) -> TraceDetailViewController {
        let viewController = TraceDetailViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
}


