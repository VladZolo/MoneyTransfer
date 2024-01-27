
import Foundation

class User {
    let userID: String
    let password: String
    let email: String
    var balance: Double
    
    init(userID: String, password: String, email: String, balance: Double) {
        self.userID = userID
        self.password = password
        self.email = email
        self.balance = balance
    }
}
