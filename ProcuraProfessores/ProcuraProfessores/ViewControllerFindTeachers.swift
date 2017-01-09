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
    let searchController = UISearchController(searchResultsController: nil)
    var teachers = [Teacher]()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCellTeacher
        let teacher: Teacher
        teacher = teachers[indexPath.row]
        cell?.labelName.text = teacher.name
        cell?.labelMateria.text = teacher.materia
        if(cell?.imageViewPhoto.image == nil){
            cell?.imageViewPhoto.image = teacher.imagem
        }
        cell?.imageViewPhoto.image = teacher.imagem
        cell?.labelNota.text = "\(teacher.nota!)"
        cell?.floatRatingView.rating = teacher.nota
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AlertUtil.presentOKAlert(withTitle: "Currículo", andMessage: self.teachers[indexPath.row].curriculo, originController: self.currentViewController)
   
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return teachers.count
        }
        return teachers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func filterContentForSearchText(searchText: String) {
        teacherApi.requestListOfObjects(withPrefix: searchText,key: TeacherAPI.apiKeys.nome,className: TeacherAPI.apiKeys.className) { (teachers,pFobjects, error) in
            if(error == nil){
                self.teachers = teachers!
                self.tableViewTeachers.reloadData()
                self.loadImages(with: pFobjects!)
            }
            else{
                AlertUtil.presentOKAlert(withTitle: "Erro", andMessage:
                    error!.localizedDescription, originController: self.currentViewController)
            }
            
        }
  
    }
    
    func loadImages(with pFObjects: [PFObject]){
        for index in 0...pFObjects.count {
            teacherApi.requestImage(withPFObject: pFObjects[index], completionHandler: { (image, error) in
                if(error == nil){
                    self.teachers[index].imagem = image
                    self.tableViewTeachers.reloadData()
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
