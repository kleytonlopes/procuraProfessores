//
//  ViewControllerFindTeachers.swift
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 07/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.
//

import UIKit

class ViewControllerFindTeachers: UIViewController ,UISearchBarDelegate {

    @IBOutlet var tableViewTeachers: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var teachers = [Teacher]()
    var teacherApi = TeacherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchController()
        setDelegates()
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

}
extension ViewControllerFindTeachers : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCellTeacher
        let teacher: Teacher
        teacher = teachers[indexPath.row]
        cell?.labelName.text = teacher.name
        cell?.labelMateria.text = teacher.materia
        cell?.imageViewPhoto.image = teacher.imagem
        cell?.labelNota.text = "\(teacher.nota!)"
        cell?.floatRatingView.rating = teacher.nota
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentViewController: UIViewController = self
        if searchController.searchBar.isFirstResponder {
            currentViewController = self.searchController
        }
        AlertUtil.presentOKAlert(withTitle: "Currículo", andMessage: self.teachers[indexPath.row].curriculo, originController: currentViewController)
   
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
        teacherApi.requestList(withFilters: ["prefix":searchText]) { (teachers, errors) in
            self.teachers = teachers!
            self.tableViewTeachers.reloadData()
        }
    }
}
extension ViewControllerFindTeachers : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
