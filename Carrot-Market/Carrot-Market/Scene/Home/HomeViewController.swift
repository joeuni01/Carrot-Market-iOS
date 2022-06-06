//
//  HomeViewController.swift
//  Carrot-Market
//
//  Created by 최영린 on 2022/06/01.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var productList : [ProductDataModel] = []

    // MARK: - @IBOutlet Properties
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var productAddButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProductList()
    }
    
    /// MARK: - Functions
    private func setTableView() {
        let productListNib = UINib(nibName: ProductTableViewCell.className, bundle: nil)
        productListTableView.register(productListNib, forCellReuseIdentifier: ProductTableViewCell.className)
        
        productListTableView.delegate = self
        productListTableView.dataSource = self
    }
    
    // MARK: - @IBAction Properties
    @IBAction func productAddButtonDidTap(_ sender: Any) {
        guard let productAddVC = UIStoryboard(name: "ProductAddStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ProductAddViewController") as? ProductAddViewController else { return }

        productAddVC.modalPresentationStyle = .fullScreen

        self.present(productAddVC, animated: true, completion: nil)
    }
    
    @IBAction func locationButtonDidTap(_ sender: Any) {
        print("지역 설정")
    }
}

// MARK: - Extensions
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.className, for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }
        cell.setProductData(productList[indexPath.row])
        return cell
    }
}

extension HomeViewController {
    private func fetchData() {
        
    }
    
    private func getProductList() {
        ProductListService.shared.getProductList() { networkResult in
            print(networkResult)
            switch networkResult {
            case .success(let res):
                guard let response = res as? [ProductDataModel] else { return }
                self.productList = response
                self.productListTableView.reloadData()
                print(response)
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
