//
//  ViewController.swift
//  BookXpertAssignment
//
//  Created by Avinash Verma on 24/05/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import CoreData

class SignInVC: UIViewController, ProductViewModelProtocol {
 
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    var productViewModel = ProductViewModel()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        
        googleBtn.layer.borderWidth = 1
        googleBtn.layer.borderColor = UIColor(named: "TxtColor")?.cgColor
        productViewModel.delegate = self
    }
    
    // Google Sign In using Firebase Auth.............................................
    @IBAction func googleSignInTapped(_ sender: UIButton) {
        self.loader.isHidden = false
        self.loader.startAnimating()
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                self.loader.isHidden = true
                print("Google Sign-In error: \(error.localizedDescription)")
                showAlert(title: "Google Sign-In", message: "Google Sign-In error: \(error.localizedDescription)", vc: self)
                return
            }
            
            guard
                let user = signInResult?.user,
                let idToken = user.idToken?.tokenString
            else {
                print("Missing token info from Google Sign-In result")
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In error: \(error.localizedDescription)")
                    showAlert(title: "Firebase Sign-In", message: "Firebase Sign-In error: \(error.localizedDescription)", vc: self)
                } else {
                    print("Successfully signed in with Firebase: \(authResult?.user.email ?? "")")
                    isLogin = true
                    self.productViewModel.getProducts(url: "https://api.restful-api.dev/objects")
                   
                    //  Save user info to Core Data
                    if let userData = authResult?.user{
                        self.saveUserToCoreData(authUser: userData)
                    }
                }
            }
        }
    }
    
    func saveUserToCoreData(authUser: UserInfo) {
        
        let newUser = AppUser(context: context)
        newUser.name = authUser.displayName
        newUser.email = authUser.email
        newUser.uid = authUser.uid
        
        do {
            try context.save()
            print("✅ User saved to Core Data")

        } catch {
            print("❌ Failed to save user: \(error.localizedDescription)")
            
        }
    }
    
    func saveDataToCoreData(isSaved: Bool) {
       
        if isSaved{
            DispatchQueue.main.async{
                self.loader.isHidden = true
                self.loader.stopAnimating()
                let scene = UIApplication.shared.connectedScenes.first
                if let sd: SceneDelegate = scene?.delegate as? SceneDelegate{
                    sd.SetupRootViewController()
                }
            }
        }else{
            print("Not Saved")
        }
        
    }
    
}


