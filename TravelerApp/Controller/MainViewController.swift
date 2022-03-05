//
//  MainViewController.swift
//  TravelerApp
//
//  Created by Sezgin Çiftci on 5.01.2022.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    
    fileprivate var backgroundView = UIView()
    fileprivate var tableViewMenu : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TableViewCell.self, forCellReuseIdentifier: "tableCell")
        return tv
    }()

    fileprivate var coreVM: CoreDataViewModel?
    fileprivate var chosenId = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getData()

    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    
    @objc func changeListToMap(_ segmentControl: UISegmentedControl) {
        
        let map = MapViewForSegment()
        let navVC = UINavigationController(rootViewController: map)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        present(navVC, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func getData() {
        
        CoreDataManager.shared.loadData { viewModel in
            self.coreVM = viewModel
            self.tableViewMenu.reloadData()
        }
        
    }
 
    fileprivate func setUI() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Traveler App"
        
        view.backgroundColor = UIColor(red: 0, green: 255/255, blue: 127/255, alpha: 1)
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.backgroundColor = .secondarySystemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItem))
        
        let segmentItems = ["List", "Map"]
        let changeSegment = UISegmentedControl(items: segmentItems)
        backgroundView.addSubview(changeSegment)
        changeSegment.translatesAutoresizingMaskIntoConstraints = false
        changeSegment.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        changeSegment.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        changeSegment.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        changeSegment.selectedSegmentTintColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1)
        changeSegment.addTarget(self, action: #selector(changeListToMap), for: .valueChanged)
        changeSegment.backgroundColor = .secondarySystemBackground
        changeSegment.tintColor = .secondarySystemBackground
        changeSegment.selectedSegmentIndex = 0
        
        
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        backgroundView.addSubview(tableViewMenu)
        tableViewMenu.topAnchor.constraint(equalTo: changeSegment.bottomAnchor).isActive = true
        tableViewMenu.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        tableViewMenu.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        tableViewMenu.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        tableViewMenu.backgroundColor = .secondarySystemBackground
        tableViewMenu.rowHeight = 80
        
   
    }
   
    @objc private func addButtonItem() {
        let mapVC = MapViewController()
        present(Router.routeTo(mapView: mapVC), animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((self.coreVM?.titleArray.isEmpty) != nil) {
            return self.coreVM?.titleArray.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.configureUI()
        cell.cellTitle.text = self.coreVM?.titleArray[indexPath.row]
        cell.cellComment.text = self.coreVM?.commentArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let mapVC = MapViewController()
        Constants.chosenLatitude = (self.coreVM?.latArray[indexPath.row])!
        Constants.chosenLongitude = (self.coreVM?.longArray[indexPath.row])!
        mapVC.titleText.isUserInteractionEnabled = false
        mapVC.commentText.isUserInteractionEnabled = false
        mapVC.titleText.text = self.coreVM?.titleArray[indexPath.row]
        mapVC.commentText.text = self.coreVM?.commentArray[indexPath.row]
        mapVC.displayAnnotation()
        
        let navVC = UINavigationController(rootViewController: mapVC)
        navVC.modalTransitionStyle = .crossDissolve
        navVC.modalPresentationStyle = .fullScreen
        
        present(navVC, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let id = self.coreVM?.idArray[indexPath.row] {
                self.chosenId = id
                
                CoreDataManager.shared.deleteCountry(chosenId: chosenId) { viewModel in
                    
                    self.coreVM?.idArray.remove(at: indexPath.row)
                    self.coreVM?.latArray.remove(at: indexPath.row)
                    self.coreVM?.longArray.remove(at: indexPath.row)
                    self.coreVM?.titleArray.remove(at: indexPath.row)
                    self.coreVM?.commentArray.remove(at: indexPath.row)
            
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableViewMenu.reloadData()
                }
            }
        }
    }
}

class Constants {
    
    static var chosenLatitude: Double?
    static var chosenLongitude: Double?
}
