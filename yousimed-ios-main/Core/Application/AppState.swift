//
//  AppState.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-25.
//

protocol AppStateProtocol {
    var activeUser: User? {get set}
}

class AppState: AppStateProtocol {
    var activeUser: User?
}
