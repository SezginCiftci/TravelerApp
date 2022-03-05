//
//  MapViewController.swift
//  TravelerApp
//
//  Created by Sezgin Çiftci on 6.01.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UIAlertViewDelegate {
    
    fileprivate var mapView = MKMapView()
    fileprivate var locationManager = CLLocationManager()
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()

    var commentText = UITextField()
    var titleText = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMap()
        
    }
    
    func displayAnnotation() {
        
        let annotation = MKPointAnnotation()
        annotation.title = titleText.text
        annotation.subtitle = commentText.text
        let coodinate = CLLocationCoordinate2D(latitude: Constants.chosenLatitude!,
                                               longitude: Constants.chosenLongitude!)
        annotation.coordinate = coodinate
        self.mapView.addAnnotation(annotation)
    }

    
    @objc fileprivate func handleGR(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchCoord = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoord
            annotation.title = titleText.text
            annotation.subtitle = commentText.text
            self.mapView.addAnnotation(annotation)
            
            chosenLatitude = touchCoord.latitude
            chosenLongitude = touchCoord.longitude
        }
        
        if gestureRecognizer.state == .ended {
           
            titleText.becomeFirstResponder()
            navigationItem.rightBarButtonItem?.isEnabled = true
       
        }
        
    }
    
    @objc func handleSave() {
        
        if titleText.text != "" && commentText.text != "" {
            print("saving")
          
            CoreDataManager.shared.saveData(title: titleText.text ?? "Not given",
                                            comment: commentText.text ?? "Not given",
                                            long: chosenLongitude,
                                            id: UUID(),
                                            lat: chosenLatitude)
            
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
            
            view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
            //keyboards and other things have to close and user has to be directed to main page
        } else {
            present(CustomProperties.alertMessage(title: "Error!",
                                                  message: "You should write title and comment!"),
                    animated: true,
                    completion: nil)
            
        }
        
       
    }
    

    
    fileprivate func setMap() {
        
        view.backgroundColor = UIColor(red: 0, green: 255/255, blue: 127/255, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(backToMainVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(handleSave))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.hidesBarsWhenKeyboardAppears = true
        self.navigationController?.hidesBarsWhenVerticallyCompact = true
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                             action: #selector(handleGR(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)

        
        mapView.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40).isActive = true
        titleText.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        titleText.widthAnchor.constraint(equalToConstant: 250).isActive = true
        titleText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleText.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1)
        titleText.textAlignment = .center
        titleText.alpha = 0.7
        titleText.layer.cornerRadius = 15
        titleText.clipsToBounds = true
        titleText.placeholder = "Write the title of place"
        
        mapView.addSubview(commentText)
        commentText.translatesAutoresizingMaskIntoConstraints = false
        commentText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20).isActive = true
        commentText.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        commentText.widthAnchor.constraint(equalToConstant: 250).isActive = true
        commentText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        commentText.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1)
        commentText.textAlignment = .center
        commentText.alpha = 0.7
        commentText.layer.cornerRadius = 15
        commentText.clipsToBounds = true
        commentText.placeholder = "Write your comment"
        
    }
  
    @objc func handleTextField() {
        becomeFirstResponder()
    }
    
    
    @objc fileprivate func backToMainVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//: MARK: - MapView and CLLocation

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "mapAnn"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .black
            
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let requestLocation = CLLocation(latitude: Constants.chosenLatitude!, longitude: Constants.chosenLongitude!)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemark, error in
            guard let placemark = placemark else { return }
            let newPlacemark = MKPlacemark(placemark: placemark[0])
            let item = MKMapItem(placemark: newPlacemark)
            item.name = view.annotation?.title ?? "no value"
            
            let launchOpt = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            item.openInMaps(launchOptions: launchOpt)
        }
    }
}
// Singelton pattern example 
class CustomProperties {
    
    static func makeTextField(_ placeholder: String) -> UITextField {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1)
        textfield.textAlignment = .center
        textfield.layer.cornerRadius = 15
        textfield.clipsToBounds = true
        textfield.placeholder = placeholder
        return textfield
    }
    
    static func alertMessage(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        return alert
    }
}
