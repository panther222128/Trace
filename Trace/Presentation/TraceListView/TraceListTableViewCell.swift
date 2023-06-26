//
//  TraceListTableViewCell.swift
//  Trace
//
//  Created by Jun Ho JANG on 2023/06/26.
//

import UIKit

final class TraceListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: TraceListItemViewModel) {
        titleLabel.text = viewModel.title
    }
    
}
