
import UIKit

class AuthenticationManager {
    var registeredUsers: [User] = []
    var currentUser = User(userID: "", password: "", email: "", balance: 0)
    
    func registerUser(userID: String, password: String, email: String) {
            let newUser = User(userID: userID, password: password, email: email, balance: 100)
            registeredUsers.append(newUser)
    }
    
    func isRegisteredUser(userID: String, password: String) -> Bool {
        if let user = registeredUsers.first(where: { $0.userID == userID && $0.password == password }) {
            currentUser = user
            return true
        } else {
            return false
        }
    }
}

extension AuthenticationManager {
    func setDemoUser(userIDTextField: UITextField, passwordTextField: UITextField, repeatPasswordTextField: UITextField, emailTextField: UITextField) {
        userIDTextField.text = "DemoUser"
        passwordTextField.text = "DemoPassword"
        repeatPasswordTextField.text = "DemoPassword"
        emailTextField.text = "demoEmail@demoHost.com"
    }
}
