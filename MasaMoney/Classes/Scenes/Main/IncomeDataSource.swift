//
//  IncomeDataSource.swift
//  MasaMoney
//
//  Created by Maria Lopez on 13/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

protocol IncomeDataSourceOutput: class {
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath)
}

class IncomeDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var incomeDatasourceDelegate: IncomeDataSourceOutput?
    
    var incomeArray: [Account] = []
    
    required init(incomeArray: [Account]) {
        self.incomeArray = incomeArray
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return incomeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountsViewCell", for: indexPath) as? AccountsViewCell
            else {
                return UICollectionViewCell()
        }
        cell.configure(account: incomeArray[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        incomeDatasourceDelegate?.didSelectAccountAtIndexPath(indexPath)
    }
}



