//
//  InflationCell.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import UIKit

final class InflationCell: UITableViewCell {
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var inflationLabel: UILabel!
    
    func configure(with model: InflationMonth) {
        if model.isInvalidated {
            return
        }
        monthLabel.text = model.name
        inflationLabel.text = model.inflation != nil ? "\(model.inflation!.percentageRepresentation)%": "-"
    }
    
}
