//
//  ViewControllerAPIHandler.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/25/21.
//

import Foundation

protocol ViewControllerAPIProtocol: AnyObject {
    
    func getDogBreed(onSuccess: @escaping (DogBreed) -> Void,
                         onFailure: @escaping (Error) -> Void)
    
    func getDogBreedImage(breedName: String,
                          onSuccess: @escaping (DogBreedImage) -> Void,
                          onFailure: @escaping (Error) -> Void)
    
}


class ViewControllerAPIHandler: ViewControllerAPIProtocol {
    
    func getDogBreed(onSuccess: @escaping (DogBreed) -> Void, onFailure: @escaping (Error) -> Void) {
        DoggoService().downloadBreeds { (result) in
            switch result {
            case .success(let data):
               onSuccess (data)
            case .failure(let error):
                onFailure (error)
            }
        }
    }
    
    func getDogBreedImage(breedName: String, onSuccess: @escaping (DogBreedImage) -> Void, onFailure: @escaping (Error) -> Void) {
        DoggoService().downloadImage(breedName: breedName) { result in
            switch result {
                case .success(let data):
                    onSuccess (data)
                case .failure(let error):
                    onFailure (error)
                }
        }
    }
}
