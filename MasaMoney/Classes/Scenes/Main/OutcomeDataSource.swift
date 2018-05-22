//
//  OutcomeDataSource.swift
//  MasaMoney
//
//  Created by Maria Lopez on 13/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

protocol OutcomeDataSourceOutput: class {
    func didSelectOutcomeAccountAtIndexPath(_ indexPath: IndexPath)
}

class OutcomeDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var outcomeDatasourceDelegate: OutcomeDataSourceOutput?
    
    var outcomeArray: [Account] = []
    
    required init(outcomeArray: [Account]) {
        self.outcomeArray = outcomeArray
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return outcomeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountsViewCell", for: indexPath) as? AccountsViewCell
            else {
                return UICollectionViewCell()
        }
        cell.configure(account: outcomeArray[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        outcomeDatasourceDelegate?.didSelectOutcomeAccountAtIndexPath(indexPath)
    }
}

