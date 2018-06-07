//
//  MovementDataSource.swift
//  MasaMoney
//
//  Created by Maria Lopez on 20/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

// En principio no se va a tocar las celdas del historico
protocol MovementDataSourceOutput: class {
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath)
}

class MovementDataSource: NSObject {
    
    // MARK: -Properties
    weak var movementDatasourceDelegate: MovementDataSourceOutput?
    
    var movementArray: [Movement] = []
    
    var datesString : [String] = []
    
    var datesDate: [Date] = []
    
    var datesDateOrdered: [Date] = []
    
    var dateFormatter = DateFormatter()
    
    required init(movementArray: [Movement]) {
        self.movementArray = movementArray
    }
    
    // MARK: - Functions
    
    //Get array of sections
    func getSectionArray() -> [String]{
        dateFormatter.dateFormat = "dd MM yyyy"// yyyy-MM-dd"
        
        for mov in movementArray {
            if !datesString.contains(mov.date) {
                let date = dateFormatter.date(from: mov.date)
                datesDate.append(date!)
                datesString.append(mov.date)
            }
        }
        datesDateOrdered = datesDate.sorted(by: { $0.compare($1) == .orderedDescending })
        return datesString
    }
    
    //Calculate number of sections
    func getSectionItems(section: Int) -> [Movement] {
        var sectionItems = [Movement]()
        
        // loop through the testArray to get the items for this sections's date
        for item in movementArray {
            let mov = item as Movement
            // if the item's date equals the section's date then add it
            if item.date == datesString[section] {
                sectionItems.append(mov)
            }
        }
        return sectionItems
    }
}

extension MovementDataSource : UITableViewDelegate, UITableViewDataSource {
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionItems(section: section).count
    }
    //cellForRowAt indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementCell", for: indexPath) as? MovementCell
            else {
                return UITableViewCell()
        }
        // get the items in this section
        let sectionItems = self.getSectionItems(section: indexPath.section)
        // get the item for the row in this section
        let movement = sectionItems[indexPath.row]
        
        cell.configure(movement: movement)
        
        return cell
    }
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return getSectionArray().count
    }
    //titleForHeaderInSection -- we use the ordered array to set the title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: datesDateOrdered[section])
    }
    //didSelectRowAt indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movementDatasourceDelegate?.didSelectAccountAtIndexPath(indexPath)
    }
}
