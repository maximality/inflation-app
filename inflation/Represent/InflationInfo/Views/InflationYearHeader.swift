//
//  InflationYearHeader.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate: class {
    func toggleHeader(_ header: UITableViewHeaderFooterView, section: Int)
}

final class InflationYearHeader: UITableViewHeaderFooterView {
    
    weak var toggleDelegate: CollapsibleTableViewHeaderDelegate?
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var section = 0
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        toggleDelegate?.toggleHeader(self, section: section)
    }
    
    func configure(with model: InflationYear, collapsed: Bool, section: Int) {
        arrowImageView.transform = CGAffineTransform(rotationAngle: collapsed ? 0 : .pi / 2)
        yearLabel.text = "\(model.year)"
        percentageLabel.text = model.inflation != nil ? "\(model.inflation!.percentageRepresentation)%": "-"
        self.section = section
    }
}
