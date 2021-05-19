//
//  DogService.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/18/21.
//

import Foundation
import UIKit
import SystemConfiguration

class DoggoService {
    
    func downloadBreeds(completion: @escaping (Result<DogBreed, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: "\(DoogoURLs.kAPI_BreedsAPI)") else {
                return
            }
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let error = error {
                    completion(.failure(error.localizedDescription as! Error))
                }

                if let data = data  {
                    do {
                        let jsonBreeds = try JSONDecoder().decode(DogBreed.self, from: data)
                        completion(.success(jsonBreeds))
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        } else {
            print("Internet Connection not Available!")
        }
       
    }
    
    func downloadImage(breedName:String, completion: @escaping (Result<DogBreedImage, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            let urlString = String(format: DoogoURLs.kAPI_BreedsImageAPI, breedName,"random")
            guard let url = URL(string: urlString) else {
                return
            }
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let error = error {
                    completion(.failure(error.localizedDescription as! Error))
                }

                if let data = data  {
                    do {
                        let jsonBreedImage = try JSONDecoder().decode(DogBreedImage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(jsonBreedImage))
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        } else{
            print("Internet Connection not Available!")
        }
        
    }
    
    func downloadBreedImages(breedName:String, completion: @escaping (Result<DogBreed, Error>) -> Void) {
        if Reachability.isConnectedToNetwork(){
            let urlString = String(format: DoogoURLs.kAPI_BreedsImageAPI, breedName,"")
            guard let url = URL(string: urlString) else {
                return
            }
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let error = error {
                    completion(.failure(error.localizedDescription as! Error))
                }

                if let data = data  {
                    do {
                        let jsonBreedImage = try JSONDecoder().decode(DogBreed.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(jsonBreedImage))
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }  else{
            print("Internet Connection not Available!")
        }
      
    }
}


