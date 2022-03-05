//
//  CoreDataManager.swift
//  TravelerApp
//
//  Created by Sezgin Çiftci on 24.02.2022.
//

import UIKit
import CoreData
import MapKit

struct CoreDataManager {
    static var shared = CoreDataManager()
    
    func saveData(title: String, comment: String, long: Double, id: UUID, lat: Double) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let selectedCountry = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        selectedCountry.setValue(title, forKey: "title")
        selectedCountry.setValue(comment, forKey: "comment")
        selectedCountry.setValue(long, forKey: "longitude")
        selectedCountry.setValue(lat, forKey: "latitude")
        selectedCountry.setValue(id, forKey: "id")
        
        
//        if let imageData = image?.jpegData(compressionQuality: 0.5) {
//            selectedCountry.setValue(imageData, forKey: "image")
//        }
//
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
    }
    
    func loadData(completion: ((_ viewModel: CoreDataViewModel) -> ())) {
        
        var viewModel = CoreDataViewModel()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                viewModel.titleArray.removeAll(keepingCapacity: false)
                viewModel.idArray.removeAll(keepingCapacity: false)
                viewModel.latArray.removeAll(keepingCapacity: false)
                viewModel.longArray.removeAll(keepingCapacity: false)
                viewModel.commentArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        viewModel.titleArray.append(title)
                    }
                    if let comment = result.value(forKey: "comment") as? String {
                        viewModel.commentArray.append(comment)
                    }
                    if let lat = result.value(forKey: "latitude") as? Double {
                        viewModel.latArray.append(lat)
                    }
                    if let long = result.value(forKey: "longitude") as? Double {
                        viewModel.longArray.append(long)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        viewModel.idArray.append(id)
                    }
                    
//                    if let imageData = result.value(forKey: "image") as? Data {
//                        if let image = UIImage(data: imageData) {
//                            viewModel.imageArray.append(image)
//                        } else  {
//                            viewModel.imageArray.append(UIImage(named: "placeholder")!)
//                        }
//                    }
                }
            }
            completion(viewModel)
        } catch {
            completion(viewModel)
        }
        
    }

    
    func deleteCountry(chosenId: UUID, completion: ((_ viewModel: CoreDetailViewModel) -> ())) {
        
        var viewModel = CoreDetailViewModel()
        viewModel.id = chosenId
        
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        let idString = chosenId.uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
               
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        if id == chosenId {
                            context.delete(result)
                            
                            completion(viewModel)
                            do {
                                try context.save()
                            } catch {
                                print("error")
                            }
                            
                            break
                        }
                    }
                }
            }
        } catch {
            
        }
    }

}
