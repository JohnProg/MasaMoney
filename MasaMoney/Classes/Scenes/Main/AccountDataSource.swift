//
//  AccountDataSource.swift
//  MasaMoney
//
//  Created by Maria Lopez on 07/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

enum ResultsCellStyle {
    case income
    case outcome
}

protocol AccountDataSourceOutput: class {
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath, tag: Int)
}

class AccountDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var accountDatasourceDelegate: AccountDataSourceOutput?
    
    var accountArray: [Account] = []
    
    required init(accountArray: [Account]) {
        self.accountArray = accountArray
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountsViewCell", for: indexPath) as? AccountsViewCell
            else {
                return UICollectionViewCell()
        }
        cell.configure(account: accountArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        accountDatasourceDelegate?.didSelectAccountAtIndexPath(indexPath, tag: collectionView.tag)
    }
}
