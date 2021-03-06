//
//  ViewControllerFindTeachers.swift
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 07/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "CellTeacher"

class ViewControllerFindTeachers: UIViewController ,UISearchBarDelegate {

    //MARK: Outlets
    @IBOutlet var tableViewTeachers: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var noDataLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Variables
    var teachers = [Teacher?]()
    var teacherApi = TeacherAPI()
    var currentContextViewController : UIViewController {
        if searchController.searchBar.isFirstResponder {
            return self.searchController
        }
        return self
    }
    
    //MARK: Views *** Load
    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchController()
        setDelegates()
        addKeyboardObservers()
        filterContentForSearchText(searchText: "")
        initNoDataLabel()
        self.activityIndicator.hidesWhenStopped = true
    }
    
    //Init Label that show message of "No Results" in TableViewTeachers.
    func initNoDataLabel(){
        self.noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewTeachers.bounds.size.width, height: self.tableViewTeachers.bounds.size.height))
        self.noDataLabel.text = NSLocalizedString(Project.Localizable.message.noResults.rawValue, comment: "")
        self.noDataLabel.textAlignment = NSTextAlignment.center
        self.tableViewTeachers.backgroundView = self.noDataLabel
        self.noDataLabel.alpha = 0
    }
    
    //MARK: Functions
    
    //Hidden Label with message of No Results
    func hiddenNoDataLabel(arrayCount: Int){
        if(arrayCount == 0){
            self.noDataLabel.alpha = 1
        }
        else{
            self.noDataLabel.alpha = 0
        }
    }
    
    //Delegates
    func setDelegates(){
        searchController.searchBar.delegate = self
        tableViewTeachers.delegate = self
        tableViewTeachers.dataSource = self
    }
    
    //Keyboard
    func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Adjusts the TableView's Size
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        tableViewTeachers.contentInset.bottom = keyboardSize
    }
    
    func keyboardWillHide(sender: NSNotification) {
        tableViewTeachers.contentInset.bottom = 0
    }
    
    //Search Controller
    func configSearchController(){
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableViewTeachers.tableHeaderView = searchController.searchBar
    }
}

//MARK: UITableViewDelegate and UITableViewDataSource
extension ViewControllerFindTeachers : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TableViewCellTeacher
        cell?.populateFieldsWithTeacher(teacher: teachers[indexPath.row]!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AlertUtil.presentOKAlert(withTitle: NSLocalizedString(Project.Localizable.title.curriculo.rawValue, comment: ""), andMessage: (self.teachers[indexPath.row]?.curriculo)!, originController: self.currentContextViewController)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Brings the results of the Parse according to the text entered in the search
    func filterContentForSearchText(searchText: String) {
        activityIndicator.startAnimating()
        teacherApi.requestListOfObjects(withPrefix: searchText,key: TeacherAPI.apiKeys.nome,className: TeacherAPI.apiKeys.className) { (teachers,pFobjects, error) in
            if(error == nil){
                self.teachers = teachers!
                self.hiddenNoDataLabel(arrayCount: self.teachers.count)
                self.activityIndicator.stopAnimating()
                self.tableViewTeachers.reloadData()
                self.loadImages(with: pFobjects!)
            }
            else{
                AlertUtil.presentOKAlert(withTitle: NSLocalizedString(Project.Localizable.title.error.rawValue, comment: ""), andMessage:
                    error!.localizedDescription, originController: self.currentContextViewController)
            }
        }
    }
    
    //Load the image for each PFObject
    func loadImages(with pFObjects: [PFObject]){
        if !pFObjects.isEmpty {
            for index in 0...pFObjects.count - 1 {
                teacherApi.requestImage(withPFObject: pFObjects[index], completionHandler: { (image, error) in
                    if(error == nil){
                        self.teachers[index]?.imagem = image
                        self.tableViewTeachers.beginUpdates()
                        self.tableViewTeachers.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.fade)
                        self.tableViewTeachers.endUpdates()
                    }
                    else{
                        AlertUtil.presentOKAlert(withTitle: NSLocalizedString(Project.Localizable.title.error.rawValue, comment: ""), andMessage:
                            error!.localizedDescription, originController: self.currentContextViewController)
                    }
                })
            }
        }
    }
}
//MARK: UISearchResultsUpdating
extension ViewControllerFindTeachers : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
