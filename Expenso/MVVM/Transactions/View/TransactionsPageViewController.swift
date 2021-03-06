//
//  TransactionsPageViewController.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 06/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class TransactionsPageViewController: UIViewController {

    var pageViewController: UIPageViewController!
    let viewModel = TransactionsPageViewModel()
    var visibleController: TransactionsViewController {
        let viewController = pageViewController.viewControllers?.first as! TransactionsViewController
        return viewController
    }
    
    lazy var navLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let save = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = save

        pageControllerSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let rect = view.bounds
        pageViewController?.view.frame = CGRect.init(x: 0, y: 0, width: rect.width, height: rect.height)
    }
    
    @objc func addTapped() {
        let controller = addOrEditExpenceViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateView(date: String, total: String){
        let lightFont = UIFont.systemFont(ofSize: 14, weight: .thin)
        let navTitle = NSMutableAttributedString(string: "\(date)\n", attributes:[:])
            navTitle.append(NSMutableAttributedString(string: "Total Expense this Month: \(total)", attributes:[NSAttributedString.Key.font: lightFont]))
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
    }
    
    func pageControllerSetup()
    {
        pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self;
        pageViewController.delegate = self;

        if let controller = viewController(at: 0)
        {
            updateView(date: controller.viewModel.month(), total: controller.viewModel.monthlyExpense())
            pageViewController.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
            addChild(pageViewController!)
            view.insertSubview(pageViewController!.view, at: 0)
            didMove(toParent: self)
        }
    }
    
    func viewController(at index: Int) -> TransactionsViewController? {
        if (viewModel.pageRange.contains(index)){
            let date = Date()
            let controller = storyboard?.instantiateViewController(withIdentifier: "TransactionsViewController") as! TransactionsViewController
            controller.viewModel.date = date.month(after: index)
            controller.viewModel.currentIndex = index
            controller.viewModel.expenseUpdateHandler = {[unowned self] (transactionController, date, expense) in
                if self.visibleController.viewModel.currentIndex == transactionController.viewModel.currentIndex{
                    self.updateView(date: date, total: expense)
                }
            }
            return controller;
        }
        return nil
    }

}

extension TransactionsPageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let viewController = viewController as! TransactionsViewController
        let index = viewController.viewModel.currentIndex;
        let controller = self.viewController(at: index - 1)
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! TransactionsViewController
        let index = viewController.viewModel.currentIndex;
        let controller = self.viewController(at: index + 1)
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateView(date: visibleController.viewModel.month(), total: visibleController.viewModel.monthlyExpense())
    }    
}

