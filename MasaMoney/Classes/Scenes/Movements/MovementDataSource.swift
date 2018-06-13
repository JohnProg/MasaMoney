//
//  MovementDataSource.swift
//  MasaMoney
//
//  Created by Maria Lopez on 20/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

// TODO: - Uncomment and edit movement

protocol MovementDataSourceDelegate: class {
//    func didSelectAccountAtIndexPath(_ indexPath: IndexPath)
    func didSelectImage(with url: String)
}

class MovementDataSource: NSObject {
    
    // MARK: -Properties
    weak var delegate: MovementDataSourceDelegate?
    //received from MovementVC
    var movementArray: [Movement] = []
    
    var titleAccount : String = ""
    
    var dateStringArray : [String] = []
    
    var datesDate: [Date] = []
    
    var datesDateOrdered: [Date] = []
    
    let dateFormatter = DateFormatter()
    
    // MARK: - Init
    //sending the delegate when initializate
    required init(movementArray: [Movement], delegate: MovementDataSourceDelegate) {
        self.movementArray = movementArray
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
    //Get array of sections
    func getSectionArray() -> [Date]{
        dateFormatter.dateFormat = "dd MM yyyy"
        
        //Go through the movementArray and get the differents dates and set them in dateStringArray array
        for mov in movementArray {
            if !dateStringArray.contains(mov.date) {
                let date = dateFormatter.date(from: mov.date)
                datesDate.append(date!)
                dateStringArray.append(mov.date)
            }
        }
        //order the dates in the array
        datesDateOrdered = datesDate.sorted(by: { $0.compare($1) == .orderedDescending })
        return datesDateOrdered
    }
    
    //Calculate number of sections
    func getMovementsPerSectionArray(section: Int) -> [Movement] {
        var sectionMovementsArray = [Movement]()
        
        //Go through the movementArray to get the items for this sections's date
        for mov in movementArray {
            let date = dateFormatter.date(from: mov.date)
            if date == datesDateOrdered[section] {
                sectionMovementsArray.append(mov)
            }
        }
        return sectionMovementsArray
    }
}

extension MovementDataSource : UITableViewDelegate, UITableViewDataSource {
    
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMovementsPerSectionArray(section: section).count
    }
    //cellForRowAt indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementCell", for: indexPath) as? MovementCell
            else {
                return UITableViewCell()
        }
        // get the items in this section
        let sectionItems = self.getMovementsPerSectionArray(section: indexPath.section)
        // get the item for the row in this section
        let movement = sectionItems[indexPath.row]
        
        cell.configure(movement: movement, titleAccount: titleAccount)
        cell.delegate = self
        
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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        movementDatasourceDelegate?.didSelectAccountAtIndexPath(indexPath)
//        print(movementArray[indexPath.row].picture)
//    }
}

extension MovementDataSource: MovementCellDelegate {
    func didSelectImage(with url: String) {
        delegate?.didSelectImage(with: url)
    }
}
