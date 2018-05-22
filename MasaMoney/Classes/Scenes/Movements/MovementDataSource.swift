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

class MovementDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var movementDatasourceDelegate: MovementDataSourceOutput?
    
    var movementArray: [Movement] = []
    
    required init(movementArray: [Movement]) {
        self.movementArray = movementArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movementArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovementCell", for: indexPath) as? MovementCell
            else {
                return UITableViewCell()
        }
        cell.configure(movement: movementArray[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movementDatasourceDelegate?.didSelectAccountAtIndexPath(indexPath)
    }
}
