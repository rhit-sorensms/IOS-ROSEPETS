import UIKit
import Firebase
import FirebaseEmailAuthUI
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseEmailAuthUI
//import GoogleSignIn
class LoginViewController: UIViewController, FUIAuthDelegate {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var loginHandle: AuthStateDidChangeListenerHandle?
    
  
    
   
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        FirebaseApp.configure()
        super.viewDidLoad()
        setupSignUPButton()
    }
    
    func setupSignUPButton() {
           view.addSubview(signUpButton)
           signUpButton.addTarget(self, action: #selector(startSignInFlow), for: .touchUpInside)
       }
    
    @objc func startSignInFlow() {
                let authUI = FUIAuth.defaultAuthUI()
        let googleAuthProvider = FUIGoogleAuth(authUI: authUI!)
          let providers: [FUIAuthProvider] = [
              googleAuthProvider,
              FUIEmailAuth()
          ]
       
               
                authUI?.providers = providers
                let authViewController = authUI!.authViewController()
                self.present(authViewController, animated: true, completion: nil)
           
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHandle = AuthManager.shared.addLoginObserver {
             print("TODO: Fire the ShowListSegue! There is already someone signed in!")
           
            self.performSegue(withIdentifier: kHomeSegue, sender: self)         }
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(loginHandle)
    }
    @IBAction func pressedLoginExistingUser(_ sender: Any) {
        print("Log in existing user")
        let email = emailTextField.text!
        let password = passwordTextField.text!
        AuthManager.shared.loginExistingEmailPasswordUser(email: email, password: password)
    
        print("Pressed new user. Email: \(email) Password:\(password)")
    }

    @IBAction func pressedCreateNewUser(_ sender: Any) {
        print("pressed new user")
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        print("Pressed new user. Email: \(email) Password:\(password)")
        AuthManager.shared.signInNewEmailPasswordUser(email: email, password: password)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Make sure the segue identifier is correct
        print ("Segue identifier \(segue.identifier)")
        if segue.identifier == kHomeSegue {
            print("PhotoUrl = \( AuthManager.shared.currentUser!.photoURL)")
            
            UsersDocumentManager.shared.addNewUserMaybe(uid: AuthManager.shared.currentUser!.uid,
                                                        name:  AuthManager.shared.currentUser!.displayName,
                                                        photoUrl: AuthManager.shared.currentUser!.photoURL?.absoluteString)
        }
        // Get the new view controller using segue.destination.
    }
}
