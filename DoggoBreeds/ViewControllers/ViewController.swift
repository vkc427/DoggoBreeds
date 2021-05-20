//
//  ViewController.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/18/21.
//

import UIKit
import MBProgressHUD

class ViewController: UITableViewController {
    var breedsData = DogBreed()
    var breedsImage = DogBreedImage()
    var images = [DogBreedImage?](repeating: nil, count: 100)
    let pulltoRefresh = UIRefreshControl()
    @IBOutlet weak var lblNoData: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoData.isHidden = true
        getBreeds()
        addPTR()
    }
    
    
    func addPTR() {
        tableView.addSubview(pulltoRefresh)
        pulltoRefresh.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        pulltoRefresh.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        pulltoRefresh.attributedTitle = NSAttributedString(string: "Fetching Doggo Data")
    }
    
    func getBreeds() {
        DoggoService().downloadBreeds { (result) in
            switch result {
            case .success(let data):
                self.breedsData = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.pulltoRefresh.endRefreshing()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.tableView.isHidden = true
                self.lblNoData.isHidden = false
                self.showAlert(message: Messages.ErrorMessage)
            }
        }
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
        return self.breedsData.message?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogViewTableViewCell") as! DogViewTableViewCell
        let breed = self.breedsData.message?[indexPath.row]
        let kempty = "-"
        cell.lblBreedName.text = breed?.uppercased() ?? kempty
        cell.imgBreed.image = nil
        DoggoService().downloadImage(breedName: (self.breedsData.message?[indexPath.row])!) { result in
            let hud = MBProgressHUD.showAdded(to: cell.imgBreed, animated: true)
            hud.show(animated: true)
            switch result {
                case .success(let data):
                    self.breedsImage = data
                    guard let imgURL = self.breedsImage.message, let url = URL(string: imgURL) else {
                        return
                    }
                    cell.imgBreed.downloadedFrom(url: url)
                    hud.hide(animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breedName = self.breedsData.message?[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(identifier: "DoggoImagesViewController") as? DoggoImagesViewController {
            vc.breedName = breedName
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
   }
    

}

