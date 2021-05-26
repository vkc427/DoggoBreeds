//
//  ViewController.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/18/21.
//

import UIKit
import MBProgressHUD

class ViewController: UITableViewController {
    var breedNames = [String]()
    let pulltoRefresh = UIRefreshControl()
    @IBOutlet weak var lblNoData: UILabel!
    
    let viewModel = ViewControllerViewModel(handler: ViewControllerAPIHandler())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBreeds()
        setViewModelCallbacks()
        self.lblNoData.isHidden = true
        addPTR()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setViewModelCallbacks() {
        viewModel.loadBreeds = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.show(animated: true)
                self.viewModel.getDogBreedImage()
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.pulltoRefresh.endRefreshing()
            }
        }
        
        viewModel.loadImage = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.pulltoRefresh.endRefreshing()
            }
        }
        
    }
    
    func addPTR() {
        tableView.addSubview(pulltoRefresh)
        pulltoRefresh.addTarget(self, action: #selector(refreshBreed(_:)), for: .valueChanged)
        pulltoRefresh.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        pulltoRefresh.attributedTitle = NSAttributedString(string: "Fetching Doggo Data")
    }
    
    func getBreeds() {
        viewModel.getDogBreeds()
    }
    
    @objc private func refreshBreed(_ sender: Any) {
        getBreeds()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error!!!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breedsData.message?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogViewTableViewCell") as! DogViewTableViewCell
        let breed = viewModel.breedsData.message?[indexPath.row]
        let kempty = "-"
        if let breedName = breed, !breedName.isEmpty {
            cell.lblBreedName.text = breedName.uppercased()
            if let imgURL = viewModel.images[indexPath.row]?.message, let url = URL(string: imgURL) {
                cell.imgBreed.downloadedFrom(url: url)
            }
        } else {
            cell.lblBreedName.text = kempty
        }
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breedName = viewModel.breedsData.message?[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(identifier: "DoggoImagesViewController") as? DoggoImagesViewController {
            vc.breedName = breedName
            self.navigationController?.pushViewController(vc, animated: true)
        }
   }
    
}

