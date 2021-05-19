//
//  DoggoImagesViewController.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/18/21.
//

import UIKit

class DoggoImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var breedName:String?
    var breedsData = DogBreed()
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        getBreedImages()
    }
    
    func getBreedImages() {
        guard let bName = breedName, !bName.isEmpty else {
            self.collectionView.isHidden = true
            return
        }
        DoggoService().downloadBreedImages(breedName: bName) { (result) in
            switch result {
            case .success(let data):
                self.breedsData = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(message: Messages.ErrorMessage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedsData.message?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoggoImagesCollectionViewCell", for: indexPath) as? DoggoImagesCollectionViewCell else {
             fatalError("Unable to dequeue.")
         }
        cell.imgBreed.image = nil
        let breeds = self.breedsData.message?[indexPath.row]
        guard let imgURL = breeds, let url = URL(string: imgURL) else {
            fatalError()
        }
        cell.imgBreed.downloadedFrom(url: url)
        cell.lblName.text = self.getBreedName(breed: breeds)
        return cell
    }
        
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error!!!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getBreedName(breed: String?) -> String {
        let arrBreedImages = breed?.components(separatedBy: "/")
        if let arrImages = arrBreedImages, !arrImages.isEmpty {
            return arrImages[arrImages.count - 2].uppercased()
        }
        return Messages.Empty
        
    }
}
