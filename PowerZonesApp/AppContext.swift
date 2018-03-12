import Foundation

class AppContext {
    ///Reference to AppStorage
    static var storage: AppStorage?
    
    ///UserDefaults to store and load data
    static var userDefaults: UserDefaultProtocol = UserDefaults.standard
}
