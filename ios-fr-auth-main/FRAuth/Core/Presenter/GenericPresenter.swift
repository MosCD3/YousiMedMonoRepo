//
//  GenericPresenter.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-17.
//
import Combine

protocol GenericPresenter: AnyObject {
    var isBusyPublisher: Published<Bool>.Publisher { get }
    func validate(for: FieldType, input: String) -> FRGenericOPResult
    func viewDidLoad()
    func viewWillAppear()
}

protocol LoginPresenterProtocol: GenericPresenter {
    func login(username: String, password: String, callback:@escaping AuthGenericOPResult)
    func tappedCreateAccount()
    func tappedForgotPass()
}

protocol RegisterPresenterProtocol: GenericPresenter {
    func register(username: String, password: String, callback: @escaping AuthGenericOPResult)
}

//TIP: Combine 2 methods of 2 protocols to one protocol
//typealias AuthPresenterProtocol = GenericPresenter & LoginPresenterProtocol & RegisterPresenterProtocol

