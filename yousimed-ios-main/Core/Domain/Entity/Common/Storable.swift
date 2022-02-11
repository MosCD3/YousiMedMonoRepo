//
//  Storable.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-16.
//

protocol Storable {
    var id:String {get set}
    func representation() -> [String: Any] 
    init(representation: [String: Any])
}
