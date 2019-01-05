//
//  AddOrEditExpenceViewController.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class AddOrEditExpenceViewController: UITableViewController {

    let viewModel = AddOrEditExpenceViewModel()
    
    var cat: Category?
    var amount: String?
    var date = Date()
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 50.0;
        
        let save = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(onSaveTapped))
        navigationItem.rightBarButtonItem = save
    }

    // MARK: - User Actions
    func hadleImageTap(){
        showImagePickerActionSheet()
    }
    
    func showImagePickerActionSheet()
    {
        let cameraButton = "Take Photo"
        let alertController = UIAlertController.init(title: cameraButton, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let album = UIAlertAction.init(title: "Choose Existing", style: .default) {[weak self] (action) in
            self?.showPicker(.photoLibrary)
        }
        let camera = UIAlertAction.init(title: "Camera", style: .default) {[weak self] (action) in
            self?.showPicker(.camera)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(album)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(camera)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func showPicker(_ sourceType: UIImagePickerController.SourceType){
        let photoController = UIImagePickerController()
        photoController.sourceType = sourceType;
        photoController.delegate = self;
        present(photoController, animated: true, completion: nil)
    }
    
    func pushCategoriesViewController(){
        let vm = AllCategoryViewModel.init()
        vm.selectedItem = cat
        let vc = CategoriesViewController.init(viewModel: vm) { [weak self] (controller, category) in
            controller.navigationController?.popViewController(animated: true)
            self?.cat = category
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectDate(_ date: Date) {
        self.date = date
    }
    
    @objc func onSaveTapped(){
        self.view.endEditing(true)
        guard let cat = cat, let amount = amount, let amountInDouble = Double(amount), let image = image, let data = image.pngData() as NSData?, !amount.isEmpty else { return }
        let transaction = CoreDataManager.sharedInstance.createObject(classs: Transaction.self)
        transaction.amount = amountInDouble
        transaction.icon = data
        transaction.category = cat.rawValue
        transaction.details = ""
        transaction.date = date as NSDate
        transaction.createdAt = Date() as NSDate
        CoreDataManager.sharedInstance.saveContext()
    }
}

extension AddOrEditExpenceViewController
{
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        switch item {
        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionImageCell", for: indexPath) as! TrasactionImageCell
            cell.setImage(image)
            cell.tapHandler = {[weak self]() in self?.hadleImageTap()}
            return cell
        case .Category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionCategoryCell", for: indexPath)
            cell.textLabel?.text = "Category"
            cell.detailTextLabel?.text = cat?.rawValue
            return cell
        case .Amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionAmountCell", for: indexPath) as! TrasactionAmountCell
            cell.textfield.delegate = self
            cell.textfield.text = amount
            return cell
        case .Date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionDateCell", for: indexPath) as! TrasactionDateCell
            cell.setDate(date)
            cell.dateCompletionHandler = {[weak self](date) in self?.didSelectDate(date)}
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        switch item {
        case .Category:
            pushCategoriesViewController()
        default:
            break
        }
    }
}

extension AddOrEditExpenceViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        amount = textField.text
    }
}

extension AddOrEditExpenceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
        processImage(chosenImage)
    }
    func processImage(_ image: UIImage){
        self.image = image
        tableView.reloadData()
    }
}
