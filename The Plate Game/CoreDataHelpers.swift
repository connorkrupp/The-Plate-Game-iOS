//
//  CoreDataHelpers.swift
//  The Plate Game
//
//  Created by Connor Krupp on 10/4/16.
//  Copyright © 2016 Napp Development. All rights reserved.
//

import Foundation
import CoreData

private let stateDataFile = (name: "StateData", type: "json")

func importJSONData(context: NSManagedObjectContext) {
    guard let path = Bundle.main.path(forResource: stateDataFile.name, ofType: stateDataFile.type) else {
        print("Invalid Filename or Path: \(stateDataFile)")
        return
    }
    
    if let json = getJSON(fromPath: path) {
        
        for (_, value) in json["states"] {
            if let stateName = value.first?.0 {
                let newState = State(context: context)
                newState.name = stateName
                newState.capital = value.first?.1["capital"].string!
                newState.abbreviation = value.first?.1["abbreviation"].string!
                newState.largestCity = value.first?.1["largestCity"].string!
                newState.residentNickname = value.first?.1["residentNickname"].string!
                newState.nickname = value.first?.1["nickname"].string!
               
                newState.year = (value.first?.1["year"].int16)!
                newState.area = (value.first?.1["area"].int32)!
                newState.elevation = (value.first?.1["elevation"].int32)!
                newState.population = (value.first?.1["population"].int64)!
                
                // Save the context.
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

func getJSON(fromPath path: String) -> JSON? {
    do {
        let data = try NSData(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
        let jsonObj = JSON(data: data as Data)
        guard jsonObj != JSON.null else {
            print("Could not get json from file, make sure that file contains valid json.")
            return nil
        }
        
        return jsonObj
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    return nil
}
