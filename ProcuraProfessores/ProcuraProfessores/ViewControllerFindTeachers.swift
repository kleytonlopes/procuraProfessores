//
//  ViewControllerFindTeachers.swift
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 07/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.
//

import UIKit
import Parse

class ViewControllerFindTeachers: UIViewController ,UISearchBarDelegate {

    @IBOutlet var tableViewTeachers: UITableView!
    var noDataLabel: UILabel!
    let searchController = UISearchController(searchResultsController: nil)
    var teachers = [Teacher?]()
    var teacherApi = TeacherAPI()
    
    var currentViewController : UIViewController {
        if searchController.searchBar.isFirstResponder {
            return self.searchController
        }
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchController()
        setDelegates()
        addNotificationsKeyboard()
        filterContentForSearchText(searchText: "")
        initNoDataLabel()
    }
    
    func initNoDataLabel(){
        self.noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewTeachers.bounds.size.width, height: self.tableViewTeachers.bounds.size.height))
        self.noDataLabel.text = "No Results"
        self.noDataLabel.textAlignment = NSTextAlignment.center
        self.tableViewTeachers.backgroundView = self.noDataLabel
        self.noDataLabel.alpha = 0
    }
    
    func addNotificationsKeyboard(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setDelegates(){
        searchController.searchBar.delegate = self
        tableViewTeachers.delegate = self
        tableViewTeachers.dataSource = self
    }
    func configSearchController(){
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableViewTeachers.tableHeaderView = searchController.searchBar
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        tableViewTeachers.contentInset.bottom = keyboardSize
    }
    
    func keyboardWillHide(sender: NSNotification) {
        tableViewTeachers.contentInset.bottom = 0
    }

}
extension ViewControllerFindTeachers : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCellTeacher
        let teacher: Teacher
        teacher = teachers[indexPath.row]!
        cell?.labelName.text = teacher.name
        cell?.labelMateria.text = teacher.materia
        if(cell?.imageViewPhoto.image == nil){
            cell?.imageViewPhoto.image = teacher.imagem
            cell?.imageViewPhoto.roundToCircle()
           
        }
        cell?.imageViewPhoto.image = teacher.imagem
        cell?.labelNota.text = "\(teacher.nota!)"
        cell?.floatRatingView.rating = teacher.nota
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AlertUtil.presentOKAlert(withTitle: "Currículo", andMessage: (self.teachers[indexPath.row]?.curriculo)!, originController: self.currentViewController)
   
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func filterContentForSearchText(searchText: String) {
        teacherApi.requestListOfObjects(withPrefix: searchText,key: TeacherAPI.apiKeys.nome,className: TeacherAPI.apiKeys.className) { (teachers,pFobjects, error) in
            if(error == nil){
                self.teachers = teachers!
                self.hiddenNoDataLabel(arrayCount: self.teachers.count)
                self.tableViewTeachers.reloadData()
                self.loadImages(with: pFobjects!)
            }
            else{
                AlertUtil.presentOKAlert(withTitle: "Erro", andMessage:
                    error!.localizedDescription, originController: self.currentViewController)
            }
        }
    }
    
    func hiddenNoDataLabel(arrayCount: Int){
        if(arrayCount == 0){
            self.noDataLabel.alpha = 1
        }
        else{
            self.noDataLabel.alpha = 0
        }
    }
    
    func loadImages(with pFObjects: [PFObject]){
        for index in 0...pFObjects.count - 1 {
            teacherApi.requestImage(withPFObject: pFObjects[index], completionHandler: { (image, error) in
                if(error == nil){
                    self.teachers[index]?.imagem = image
                    self.tableViewTeachers.beginUpdates()
                    self.tableViewTeachers.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.fade)
                    self.tableViewTeachers.endUpdates()
                }
                else{
                    AlertUtil.presentOKAlert(withTitle: "Erro", andMessage:
                        error!.localizedDescription, originController: self.currentViewController)
                }
            })
        }
    }
}
extension ViewControllerFindTeachers : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
