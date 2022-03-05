//
//  MapViewForSegment.swift
//  TravelerApp
//
//  Created by Sezgin Çiftci on 26.02.2022.
//

import UIKit
import MapKit

class MapViewForSegment: UIViewController {
    
    fileprivate var locationManager = CLLocationManager()
    fileprivate var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()

    private var backgroundView = UIView()

    private var coreVM: CoreDataViewModel?
    fileprivate var titleArray = [String]()
    fileprivate var latArray = [Double]()
    fileprivate var longArray = [Double]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        configureMapUI()
        confiigureAnnotations()
    }
    
    private func confiigureAnnotations() {
        for (index, name) in titleArray.enumerated() {
           configureMapValues(title: name,
                               locaiton: CLLocationCoordinate2D(latitude: latArray[index],
                                                                longitude: longArray[index]))
        }
    }
 
    private func configureMapValues(title: String, locaiton: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2D(latitude: locaiton.latitude, longitude: locaiton.longitude)
        self.mapView.addAnnotation(annotation)
    }
    
    
    private func getData() {
        CoreDataManager.shared.loadData { viewModel in
            self.coreVM = viewModel
            self.titleArray = viewModel.titleArray
            self.latArray = viewModel.latArray
            self.longArray = viewModel.longArray
        }
    }
    
    
    @objc private func changeMapToList(_ segmentControl: UISegmentedControl) {
        
        let main = MainViewController()
        let navVC = UINavigationController(rootViewController: main)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        present(navVC, animated: true, completion: nil)
        
    }
    
    @objc private func addButtonItem() {
        let mapVC = MapViewController()
        present(Router.routeTo(mapView: mapVC), animated: true, completion: nil)
    }
    
    private func configureMapUI() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Traveler App"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItem))
        
        view.backgroundColor = UIColor(red: 0, green: 255/255, blue: 127/255, alpha: 1)
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.backgroundColor = .secondarySystemBackground
        
        let segmentItems = ["List", "Map"]
        let changeSegment = UISegmentedControl(items: segmentItems)
        backgroundView.addSubview(changeSegment)
        changeSegment.translatesAutoresizingMaskIntoConstraints = false
        changeSegment.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        changeSegment.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        changeSegment.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        changeSegment.selectedSegmentTintColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1)
        changeSegment.addTarget(self, action: #selector(changeMapToList), for: .valueChanged)
        changeSegment.backgroundColor = .secondarySystemBackground
        changeSegment.tintColor = .secondarySystemBackground
        changeSegment.selectedSegmentIndex = 1
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        backgroundView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: changeSegment.bottomAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        
    }
}

extension MapViewForSegment: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }

}


class Router {
    
    static func routeTo(mapView controller: UIViewController) -> UINavigationController {
        
        let controller = controller
        let navVC = UINavigationController(rootViewController: controller)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        return navVC
        
    }
}

