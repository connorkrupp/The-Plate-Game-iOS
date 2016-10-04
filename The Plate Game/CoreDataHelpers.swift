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

func coredata(context: NSManagedObjectContext) {
    guard let path = Bundle.main.path(forResource: stateDataFile.name, ofType: stateDataFile.type) else {
        print("Invalid Filename or Path: \(stateDataFile)")
        return
    }
    
    if let json = getJSON(fromPath: path) {
        let names = json["State"].arrayValue.map({$0.stringValue})
        let years = json["Year"].arrayValue.map({$0.stringValue})
        let largestCity = json["LargestCity"].arrayValue.map({$0.stringValue})
        let area = json["Area"].arrayValue.map({$0.stringValue})
        let capital = json["Capital"].arrayValue.map({$0.stringValue})
        let pop = json["Population"].arrayValue.map({$0.stringValue})
        let elevation = json["Elevation"].arrayValue.map({$0.stringValue})
        let abbrev = json["Abbreviation"].arrayValue.map({$0.stringValue})
        let nick = json["Nickname"].arrayValue.map({$0.stringValue})
        let res = json["ResidentNickname"].arrayValue.map({$0.stringValue})
        // If appropriate, configure the new managed object.
        
        
        var states = [Any]()
        for index in 0..<names.count {
            let state = [names[index]: [
                "year": years[index],
                "largestCity": largestCity[index],
                "area": area[index],
                "elevation": elevation[index],
                "capital": capital[index],
                "population": pop[index],
                "abbreviation": abbrev[index],
                "nickname": nick[index],
                "residentNickname": res[index]
                ]]
            states.append(state)
        }

        let dict = ["states": states]
        var json = JSON(dict)
        let str = json.description
        let data = str.data(using: .utf8)!
        if let file = FileHandle(forUpdatingAtPath:path) {
            file.write(data)
        }
        
        
        
        
        
        return
        for stateData in names {
            let newState = Event(context: context)
            
            newState.name = stateData
            
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
