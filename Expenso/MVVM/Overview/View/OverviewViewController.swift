//
//  OverviewViewController.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData
import Charts

class OverviewViewController: UIViewController {
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var errorLabel: UILabel!
    let viewModel = OverviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setup(pieChartView: chartView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateChartData()
    }
    
    func transactionInfo() -> [String : Double] {
        return viewModel.transactionInfo()
    }
    
    func updateView(info: [String : Double]){
        chartView.isHidden = info.isEmpty
        errorLabel.isHidden = !info.isEmpty
    }
    
    func updateChartData() {
        updateView(info: transactionInfo())
        viewModel.updateChartData(pieChartView: chartView)
    }
}
