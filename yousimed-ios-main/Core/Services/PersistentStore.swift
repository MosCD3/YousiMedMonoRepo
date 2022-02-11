//
//  PersistentStore.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-05.
//
import Foundation

protocol PersistentStoreProtocol {
    func saveData(key: String, object: Any)
    func clearData(key: String)
    func getString(key: String) -> String?
    func getBool(key: String) -> Bool?
    func getInt(key: String) -> Int?
}

class PersistentStore: PersistentStoreProtocol {
    
    var defaults = UserDefaults.standard
    
    func saveData(key: String, object: Any) {
        let defaultsSize = PersistentStore.getSizeOfUserDefaults()
        if defaultsSize ?? 0 > PersistentStore.maxDefaults_Size {
            print("Defaults object size too high: \(defaultsSize ?? 0), Cannot Save!")
        }
        if let object_str = object as? String {
            let _size = object_str.count
            print("Size of saved string for key:\(key)  is:\(_size)")
            
            //TODO: if too large, save in app lifecycle
            if _size > PersistentStore.maxKeyValue_Size {
                print("Size of string for key:\(key) is:\(_size), this is too large for storing, (max:\(PersistentStore.maxKeyValue_Size))")
                return
            }
        }
        
        defaults.set( object, forKey: key)
    }
    
    func clearData(key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func getString(key: String) -> String? {
        var returned: String?
        guard
            let value = defaults.string(forKey: key)
            else { return returned }
        returned = value
        return returned
    }
    
    func getBool(key: String) -> Bool? {
        if let _ = defaults.value(forKey: key) {
            return defaults.bool(forKey: key)
        }
        return nil
    }
    
    func getInt(key: String) -> Int? {
        if let _ = defaults.value(forKey: key) {
            return defaults.integer(forKey: key)
        }
        return nil
    }
    
    
}

//MARK: Static Methods/Properties
extension PersistentStore {
    static let maxKeyValue_Size = 50000 //in bytes
    static let maxDefaults_Size = 1000000 //in bytes
    
    static func getSizeOfUserDefaults() -> Int? {
        guard let libraryDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
            return nil
        }
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return nil
        }
        
        let filepath = "\(libraryDir)/Preferences/\(bundleIdentifier).plist"
        let filesize = try? FileManager.default.attributesOfItem(atPath: filepath)
        let retVal = filesize?[FileAttributeKey.size]
        return retVal as? Int
    }
}
