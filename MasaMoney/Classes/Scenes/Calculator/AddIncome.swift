//
//  AddIncomeViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 13/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

class AddIncome: UIViewController{
    
    internal var screenName = "AddIncome"
    
    // MARK: -Outlets
    @IBOutlet weak var chooseIncomeLabel: UILabel!{
        didSet {
            chooseIncomeLabel.font = UIFont.mmLatoBoldFont(size: 16)
            chooseIncomeLabel.textColor = UIColor.darkGray
            chooseIncomeLabel.text = Strings.addIncomeTitle
        }
    }
    
    @IBOutlet weak var incomeCollectionView: UICollectionView!
    
    // MARK: -Properties
    var incomeArray: [Account] = []
    var incomeDataSource = AccountDataSource(accountArray: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Strings.income
        setupCollectionView()
        incomeDataSource.accountArray = self.incomeArray
        incomeDataSource.accountDatasourceDelegate = self
        incomeCollectionView.reloadData()
    }
    
    func setupCollectionView(){
        let nibAccountViewCell = UINib(nibName: "AccountsViewCell", bundle:nil)
        incomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
 
        incomeCollectionView.delegate = incomeDataSource
        incomeCollectionView.dataSource = incomeDataSource
    }    
}

extension AddIncome: AccountDataSourceDelegate {
    func drag(_ indexPath: IndexPath) -> [UIDragItem] {
        //get the account from the array
        let provider = NSItemProvider(object: incomeDataSource.accountArray[indexPath.row])
        let dragItem = UIDragItem(itemProvider: provider)
        return [dragItem]
    }
    
    func performDropWith(_ coordinator: UICollectionViewDropCoordinator, tag: Int) {
    }
    
    func canHandle() -> Bool {
        return true
    }
    
    func dropSessionDidUpdate() -> UICollectionViewDropProposal {
        let proposal = UICollectionViewDropProposal(operation: .copy, intent: .insertIntoDestinationIndexPath)
        return proposal
    }
    
    func didSelectAccountDrop(_ coordinator: UICollectionViewDropCoordinator, tag: Int) {
    }
    // SELECT ITEM
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath, tag: Int) {
        let incomeAccount = Account()
        incomeAccount.name = "Income"
        incomeAccount.id = "External"
        incomeAccount.balance = 0
        
        let vc: CalculatorVC = UIStoryboard(.AddIncome).instantiateViewController()
        vc.accountDestination = incomeDataSource.accountArray[indexPath.row]
        vc.accountOrigin = incomeAccount
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
