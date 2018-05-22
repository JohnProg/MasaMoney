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
            chooseIncomeLabel.text = "Select account where money comes to"
        }
    }
    
    @IBOutlet weak var incomeCollectionView: UICollectionView!
    
    // MARK: -Properties
    var incomeArray: [Account] = []
    var incomeDataSource = IncomeDataSource(incomeArray: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Choose income account"
        setupCollectionView()
        incomeDataSource.incomeArray = self.incomeArray
        incomeCollectionView.reloadData()
    }
    
    func setupCollectionView(){
        let nibAccountViewCell = UINib(nibName: "AccountsViewCell", bundle:nil)
        incomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
 
        incomeDataSource.incomeDatasourceDelegate = self 
        incomeCollectionView.delegate = incomeDataSource
        incomeCollectionView.dataSource = incomeDataSource
        
    }    
}

extension AddIncome: IncomeDataSourceOutput {
    func didSelectIncomeAccountAtIndexPath(_ indexPath: IndexPath) {
        let incomeAccount = Account()
        incomeAccount.name = "Income"
        incomeAccount.id = "External"
        incomeAccount.balance = 0
        
        let vc: IncomeCalculator = UIStoryboard(.AddIncome).instantiateViewController()
        vc.accountDestination = incomeDataSource.incomeArray[indexPath.row]
        vc.accountOrigin = incomeAccount
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
