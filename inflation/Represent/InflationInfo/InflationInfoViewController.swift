//
//  InflationInfoViewController.swift
//  inflation
//
//  Created by Maxim MAMEDOV on 13/03/2019.
//  Copyright © 2019 ServiceGuru. All rights reserved.
//

import UIKit
import RealmSwift

final class InflationInfoViewController: UIViewController {
    
    var presenter: InflationInfoPresenterInput!
    var adapter: InflationInfoTableViewAdapterInput!

    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.inflationInfoTitle()
        repeatButton.setTitle(R.string.localizable.errorRepeatButton(), for: .normal)
        adapter.set(tableView: tableView)
        presenter.didLoad()
    }
    
    @IBAction func repeatButtonDidTapped(_ sender: Any) {
        presenter.didPressedRepeatButton()
    }
    
}


//MARK: Adapter output
extension InflationInfoViewController: InflationInfoTableViewAdapterOutput {
    
}

//MARK: Presenter input
extension InflationInfoViewController: InflationInfoPresenterOutput {
    
    func show(error: String) {
        self.errorView.isHidden = false
        self.errorLabel.text = error
    }
    
    func showLoader() {
        self.loadingView.isHidden = false
    }
    
    func dismissLoader() {
        self.loadingView.isHidden = true
    }
    
    func dismissError() {
        self.errorView.isHidden = true
    }
    
    
    func set(data: Results<InflationYear>) {
        self.errorView.isHidden = true
        self.loadingView.isHidden = true
        adapter.set(data: data)
    }
    
}
