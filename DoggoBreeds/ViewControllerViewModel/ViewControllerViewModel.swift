//
//  ViewControllerViewModel.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/25/21.
//

import Foundation

class ViewControllerViewModel: NSObject {
    private var apiHandler: ViewControllerAPIProtocol!
    var breedsData = DogBreed()
    var breedsImage = DogBreedImage()
    var loadBreeds: (() -> Void)?
    var loadImage: (() -> Void)?
    var didFailed: (() -> Void)?
    var images = [DogBreedImage?](repeating: nil, count: 100)

    required init(handler: ViewControllerAPIProtocol) {
        apiHandler = handler
    }
    
    func getDogBreeds() {
        apiHandler.getDogBreed(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.breedsData = response
            self.loadBreeds?()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.didFailed?()
        })
    }
    
    func getDogBreedImage() {
        if let breedsInfo = breedsData.message, !breedsInfo.isEmpty {
            for i in 0...breedsInfo.count - 1 {
                apiHandler.getDogBreedImage(breedName: breedsInfo[i], onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    self.images[i] = response
                    self.loadImage?()
                }, onFailure: { [weak self] _ in
                    guard let self = self else { return }
                    self.didFailed?()
                })
                
            }
        }
           
    }

}
