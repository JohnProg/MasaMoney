////
////  AccountsDataSource.swift
////  MasaMoney
////
////  Created by Maria Lopez on 02/05/2018.
////  Copyright © 2018 Maria Lopez. All rights reserved.
////
//
//import UIKit
//
//protocol AccountsDataSourceOutput: class {
//    func didSelectBadgeAtIndexPath(_ indexPath: IndexPath)
//}
//
//class AccountsDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    weak var accountsDatasourceDelegate: AccountsDataSourceOutput?
//    
//    var accounts: [Account] = []
//    
//    required init(accounts: [Account]) {
//        self.accounts = accounts
//        print ("entra en el init")
//        print (accounts.count)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return accounts.count
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountsViewCell", for: indexPath) as? AccountsViewCell
//            else {
//                return UICollectionViewCell()
//        }
//        cell.configure(account: accounts[indexPath.item])
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //accountsDatasourceDelegate?.didSelectBadgeAtIndexPath(indexPath)
//        print("Cuenta tocada")
//    }
//}
