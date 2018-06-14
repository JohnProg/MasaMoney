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

protocol AccountDataSourceDelegate: class {
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath, tag: Int)
    func drag(_ indexPath: IndexPath) -> [UIDragItem]
    func performDropWith(_ coordinator: UICollectionViewDropCoordinator, tag: Int)
    func canHandle() -> Bool
    func dropSessionDidUpdate() -> UICollectionViewDropProposal
}

class AccountDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDropDelegate, UICollectionViewDragDelegate{
    
    weak var accountDatasourceDelegate: AccountDataSourceDelegate?
    
    var accountArray: [Account] = []
    
    required init(accountArray: [Account]) {
        self.accountArray = accountArray
    }
    
    // CONFIGURATION
    
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
    
    // TAP ITEM
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        accountDatasourceDelegate?.didSelectAccountAtIndexPath(indexPath, tag: collectionView.tag)
    }
    
    // DRAG
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//How do unwrap it? with if? guard is not possible, is it necessary?
        return (accountDatasourceDelegate?.drag(indexPath))!
    }
    
    // DROP
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if let canHandle = accountDatasourceDelegate?.canHandle() {
            return canHandle
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        accountDatasourceDelegate?.performDropWith(coordinator, tag: collectionView.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//here I unwrap it with an if
        if let proposal = accountDatasourceDelegate?.dropSessionDidUpdate() {
            return proposal
        }
        let proposal = UICollectionViewDropProposal(operation: .copy, intent: .insertIntoDestinationIndexPath)
        return proposal
    }
}
