
import UIKit

class LoginViewController: UIViewController {
    
    let fillInDebugUser: Bool = true
    
    @IBOutlet weak var userIDTextLabel: UILabel!
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextLabel: UILabel!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var segmentControlLabel: UISegmentedControl!
    @IBOutlet weak var actionButtonLabel: UIButton!
    
    let authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if fillInDebugUser {
            authenticationManager.setDemoUser(userIDTextField: userIDTextField,
                                              passwordTextField: passwordTextField,
                                              repeatPasswordTextField: repeatPasswordTextField,
                                              emailTextField: emailTextField)
        }
        setupUI(isLogin: true)
    }
    
    func setupUI(isLogin: Bool) {
        userIDTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        repeatPasswordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        segmentControlLabel.setTitle("LOGIN", forSegmentAt: 0)
        segmentControlLabel.setTitle("REGISTRATION", forSegmentAt: 1)
//        cleanFields() 
        if isLogin {
            segmentControlLabel.selectedSegmentIndex = 0
            userIDTextLabel.text = "User ID:"
            userIDTextField.placeholder = "Enter your user ID"
            passwordTextLabel.text = "Password:"
            passwordTextField.placeholder = "Enter your password"
            repeatPasswordTextLabel.isHidden = true
            repeatPasswordTextField.isHidden = true
            emailTextField.isHidden = true
            emailTextLabel.isHidden = true
            actionButtonLabel.setTitle("Login", for: .normal)
        } else {
            repeatPasswordTextLabel.isHidden = false
            repeatPasswordTextField.isHidden = false
            emailTextField.isHidden = false
            emailTextLabel.isHidden = false
            repeatPasswordTextField.placeholder = "Repeat your password"
            repeatPasswordTextLabel.text = "Repeat password:"
            emailTextField.placeholder = "Enter your email"
            emailTextLabel.text = "E-mail:"
            actionButtonLabel.setTitle("Register", for: .normal)
        }
    }
    
    func cleanFields() {
        userIDTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
        emailTextField.text = ""
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToHomeScreen() {
        let homeViewController = HomeViewController(authenticationManager: authenticationManager)
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @IBAction func segmentControlOptionTapped(_ sender: UISegmentedControl) {
        switch segmentControlLabel.selectedSegmentIndex {
        case 0:
            setupUI(isLogin: true)
        case 1:
            setupUI(isLogin: false)
        default:
            break;
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        if
            let userID = userIDTextField.text,
            let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text,
            let email = emailTextField.text
        {
            switch segmentControlLabel.selectedSegmentIndex {
            case 0:
                if authenticationManager.isRegisteredUser(userID: userID, password: password) {
                    navigateToHomeScreen()
                } else {
                    alertMessage(title: "Error", message: "Invalid userID or password.\n\nTry again.")
                }
            case 1:
                guard userID != "" && password != "" && repeatPassword != "" && email != "" else {
                    alertMessage(title: "Error", message: "There are empty fields.\n\nTry again.")
                    return
                }
                guard userID.count >= 8 && password.count >= 8 else {
                    alertMessage(title: "Error", message: "UserID and password should have at least 8 symbols.\n\nTry again.")
                    return
                }
                guard (authenticationManager.registeredUsers.first(where: { $0.userID == userID }) == nil) else {
                    alertMessage(title: "Error", message: "The specified username already exists.\n\nTry another.")
                    return
                }
                guard email.contains("@") else {
                    alertMessage(title: "Error", message: "Email is incorrect.\n\nTry again.")
                    return
                }
                if password == repeatPassword {
                    authenticationManager.registerUser(userID: userID, password: password, email: email)
                    alertMessage(title: "Succeeded", message: "Registration completed.\n\nNow you can login.")
                    setupUI(isLogin: true)
                } else {
                    alertMessage(title: "Error", message: "Passwords don't match.\n\nTry again.")
                }
            default:
                break;
            }
        }
    }
}
