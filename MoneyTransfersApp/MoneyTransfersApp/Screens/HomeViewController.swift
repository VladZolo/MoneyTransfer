
import UIKit

class HomeViewController: UIViewController {
    
    let authenticationManager: AuthenticationManager
    let transfer = Transfer()
    
    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var greetingsTextLabel: UILabel!
    @IBOutlet weak var balanceTextLabel: UILabel!
    @IBOutlet weak var receiverTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var actionButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
    }
    
    func setupUI() {
        receiverTextField.borderStyle = UITextField.BorderStyle.roundedRect
        amountTextField.borderStyle = UITextField.BorderStyle.roundedRect
        let currentUser = authenticationManager.currentUser
        greetingsTextLabel.text = "Hello, \(currentUser.userID)!"
        setupBalanceAmountLabel()
        cleanFields()
        receiverTextField.placeholder = "Enter receiver ID"
        amountTextField.placeholder = "0.00"
        actionButtonLabel.setTitle("Make transfer", for: .normal)
    }
    
    func cleanFields() {
        receiverTextField.text = ""
        amountTextField.text = ""
    }
    
    func setupBalanceAmountLabel() {
        let currentUser = authenticationManager.currentUser
        let formattedBalance = String(format: "%.2f $", currentUser.balance)
        balanceTextLabel.text = formattedBalance
    }
    
    func logout() {
        navigationController?.popToRootViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        let currentUser = authenticationManager.currentUser
        if
            let receiverID = receiverTextField.text,
            let amount = Double(amountTextField.text ?? "")
        {
            guard currentUser.userID != receiverID else {
                alertMessage(title: "Error", message: "You are trying to send yourself.\n\nSpecify another receiver.")
                return
            }
            guard amount > 0 else {
                return
            }
            guard currentUser.balance >= amount else {
                alertMessage(title: "Error", message: "Your balance is less than you trying to send.\n\nSpecify another amount.")
                return
            }
            if let receiver = authenticationManager.registeredUsers.first(where: { $0.userID == receiverID }) {
                alertMessage(title: "Succeeded", message: "Transfer completed successfully.")
                currentUser.balance -= amount
                receiver.balance += amount
                setupUI()
            } else {
                alertMessage(title: "Error", message: "Specified receiver not exist.\n\nTry again.")
            }
        } else {
            alertMessage(title: "Error", message: "All fields must be filled and amount should be only numbers.\n\nCheck and try again.")
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logout()
    }
}
