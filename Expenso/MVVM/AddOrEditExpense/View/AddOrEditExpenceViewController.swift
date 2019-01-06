//
//  AddOrEditExpenceViewController.swift
//  Expenso
//
//  Created by Shivam Jaiswal on 04/01/19.
//  Copyright © 2019 App Street Software Pvt Ltd. All rights reserved.
//

import UIKit

class AddOrEditExpenceViewController: UITableViewController {

    var viewModel: AddOrEditExpenceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let save = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(onSaveTapped))
        navigationItem.rightBarButtonItem = save
        
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        CoreDataManager.sharedInstance.networkManagedContext.reset()
        navigationController?.popViewController(animated: true)
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
        
        if viewModel.transaction.icon != nil{
            let removeExisting = UIAlertAction.init(title: "Remove Icon", style: .default) {[weak self] (action) in
                self?.viewModel.transaction.icon = nil
                self?.tableView.reloadData()
            }
            alertController.addAction(removeExisting)
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
        
        DispatchQueue.main.async { [weak self] () in
             self?.present(photoController, animated: true, completion: nil)
        }
    }
    
    func pushCategoriesViewController(){
        let viewModel = AllCategoryViewModel.init()
        viewModel.selectedItem = Category.init(rawValue: self.viewModel.transaction.category ?? "")
        let vc = CategoriesViewController.init(viewModel: viewModel) { [weak self] (controller, category) in
            controller.navigationController?.popViewController(animated: true)
            self?.viewModel.transaction.category = category.rawValue
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectDate(_ date: Date) {
        self.viewModel.transaction.date = date as NSDate
    }
    
    @objc func onSaveTapped(){
        view.endEditing(true)
        guard viewModel.isTransactionSaveEligible else { showErrorAlertOnSave(); return }
        viewModel.saveTransaction()
        navigationController?.popViewController(animated: true)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.items[indexPath.section][indexPath.row]
        return viewModel.height(for: item)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.items[indexPath.section][indexPath.row]
        switch item {
        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionImageCell", for: indexPath) as! TrasactionImageCell
            cell.setImage(viewModel.iconImage())
            cell.tapHandler = {[weak self]() in self?.hadleImageTap()}
            return cell
        case .Category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionCategoryCell", for: indexPath)
            cell.textLabel?.text = "Category"
            cell.detailTextLabel?.text = viewModel.transaction.category
            return cell
        case .Amount:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionAmountCell", for: indexPath) as! TrasactionAmountCell
            cell.textfield.delegate = self
            cell.textfield.text = viewModel.amount()
            return cell
        case .Date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionDateCell", for: indexPath) as! TrasactionDateCell
            cell.setDate((viewModel.transaction.date ?? Date() as NSDate) as Date)
            cell.dateCompletionHandler = {[weak self](date) in self?.didSelectDate(date)}
            return cell
        case .Detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrasactionDescriptionCell", for: indexPath) as! TrasactionDescriptionCell
            cell.setText(viewModel.transaction.details)
            cell.keyboardDismissHandler = {[weak self](text) in self?.viewModel.transaction.details = text}
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
        viewModel.transaction.amount = Double(textField.text ?? "") ?? 0.0
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
        let newImage = image.resizeImage()
        viewModel.transaction.icon = newImage.pngData() as NSData?
        tableView.reloadData()
    }
}

extension AddOrEditExpenceViewController{
    
    private func showErrorAlertOnSave() {
        let message = "Categry and Amount are mandotary!!"
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Okay", style: .default) {(_) in }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}
