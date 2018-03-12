import Foundation

class AppStorage {
    
    var ftp: Int? = AppContext.userDefaults.integer(forKey: "ftp") {
        didSet {
            AppContext.userDefaults.set(ftp, forKey: "ftp")
        }
    }
    
    var maxHR: Int? = AppContext.userDefaults.integer(forKey: "maxHR") {
        didSet {
            AppContext.userDefaults.set(maxHR, forKey: "maxHR")
        }
    }
}
