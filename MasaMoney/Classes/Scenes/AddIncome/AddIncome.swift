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
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath) {
        
//        let vc = IncomeCalculator.storyboardInstance()
        let vc: IncomeCalculator = UIStoryboard(.AddIncome).instantiateViewController()
        vc.account = incomeDataSource.incomeArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
