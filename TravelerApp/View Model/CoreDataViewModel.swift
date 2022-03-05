//
//  CoreDataViewModel.swift
//  TravelerApp
//
//  Created by Sezgin Çiftci on 24.02.2022.
//

import UIKit
import CoreLocation
import MapKit

struct CoreDataViewModel {
    
    var titleArray = [String]()
    var commentArray = [String]()
    var longArray = [Double]()
    var latArray = [Double]()
    var idArray = [UUID]()
    
    
}

struct CoreDetailViewModel {
    
    var title: String?
    var comment: String?
    var long: Double?
    var lat: Double?
    var id: UUID?
}


