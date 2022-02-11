//
//  YMUser.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-16.
//


class User: Storable {
    
    var id: String
    var email: String?
    var firstName: String?
    var lastName: String?
    var memberSince: Int = 0
    var lastLogin: Int = 0
    
    init(id: String) {
        self.id = id
    }
    convenience init(id: String, email:String) {
        self.init(id: id)
        self.email = email
    }
    
    convenience init(id: String,
                     email:String,
                     memberSince: Int) {
        self.init(id: id)
        self.email = email
        self.memberSince = memberSince
    }
    
    required init(representation: [String : Any]) {
        self.id = representation["id"] as? String ?? ""
        self.email = representation["email"] as? String ?? ""
        self.firstName = representation["firstName"] as? String ?? ""
        self.lastName = representation["lastName"] as? String ?? ""
        self.memberSince = representation["memberSince"] as? Int ?? 0
        self.lastLogin = representation["lastLogin"] as? Int ?? 0
    }
    
    
    func representation() -> [String : Any] {
        let rep: [String : Any] = [
            "id": id,
            "email": email ?? "",
            "firstName": firstName ?? "",
            "lastName": lastName ?? "",
            "memberSince": memberSince ,
            "lastLogin": lastLogin ,
            ]
        return rep
    }
    
}
