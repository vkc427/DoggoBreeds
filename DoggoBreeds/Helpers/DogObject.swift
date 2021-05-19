//
//  DogObject.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/18/21.
//

import Foundation

struct DogBreed: Codable {
    var status: String?
    var message: [String]?
}

struct DogBreedImage: Codable {
    var status: String?
    var message: String?
}
