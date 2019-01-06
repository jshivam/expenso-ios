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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(pieChartView: chartView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateChartData()
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "\(transactionDate().stringValue(.MMM_YYYY))")
        centerText.setAttributes([.font : UIFont.systemFont(ofSize: 13, weight: .thin),
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true

        let l = chartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = true
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 10
        l.xOffset = 1
        chartView.legend.enabled = true
        chartView.setExtraOffsets(left: 20, top: 0, right: 20, bottom: 0)

        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
    }
    
    func transactionInfo() -> [String : Double] {
        var transactionInfo = [String : Double]()
        let predicate = NSPredicate(format: "date >= %@ && date <= %@", transactionDate().startOfMonth() as CVarArg, transactionDate().endOfMonth() as CVarArg)
        let transactions = CoreDataManager.sharedInstance.fetchData(from: Transaction.self, predicate: predicate)
        
        for category in Category.allCases {
            let categoryName = category.rawValue
            let filteredTransactions = transactions.filter { (t) -> Bool in t.category ?? "" == categoryName }
            if filteredTransactions.isEmpty{
                continue
            }
            let expensePerCategory = filteredTransactions.reduce(0) { $0 + $1.amount }
            transactionInfo[categoryName] = expensePerCategory
        }
        
        return transactionInfo
    }
    
    func updateView(info: [String : Double]){
        chartView.isHidden = info.isEmpty
        errorLabel.isHidden = !info.isEmpty
    }
    
    func updateChartData() {
        let info = transactionInfo()
        updateView(info: info)
        
        let entries = info.map { (item) -> PieChartDataEntry in
            return PieChartDataEntry(value: item.value,
                                     label: item.key,
                                     icon: #imageLiteral(resourceName: "placeholder"))
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        set.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    

    func transactionDate() -> Date {
        guard let controllers = tabBarController?.viewControllers?.first as? UINavigationController, let transactionController = controllers.viewControllers.first as? TransactionsPageViewController, let date = transactionController.transactionDate() else {return Date()}
        return date
    }
}
