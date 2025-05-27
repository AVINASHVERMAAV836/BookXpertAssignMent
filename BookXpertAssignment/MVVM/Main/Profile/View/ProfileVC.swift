//
//  ProfileVC.swift
//  BookXpertAssignment
//
//  Created by Avinash Verma on 26/05/25.
//

import UIKit
import FirebaseAuth
import CoreData

class ProfileVC: UIViewController {
    
    @IBOutlet weak var displayImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var darkModeBtn: UISwitch!
    @IBOutlet weak var notificationBtn: UISwitch!
    
    var userData = AppUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImg.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        if let userdata = fetchUser(){
            userData = userdata
            nameLbl.text = userData.name ?? ""
            emailLbl.text = userData.email ?? ""
        }else{
            print("No user Data available")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySavedThemeOrSystemSetting()
    }
    
    func fetchUser() -> AppUser? {
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        do {
            return try context.fetch(request).first
        } catch {
            print("Fetch error: \(error)")
            return nil
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "logout", style: .default, handler: { _ in
            isLogin = false
            
                let scene = UIApplication.shared.connectedScenes.first
                if let sd: SceneDelegate = scene?.delegate as? SceneDelegate{
                    sd.SetupRootViewController()
                }
        }))

        present(alert, animated: true)
        
        
    }
    
    @IBAction func showPDFAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "PDFVC") as? PDFVC{
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @IBAction func notificationSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "notificationsEnabled")
    }
    
    @IBAction func darkmodeSwitchToggled(_ sender: UISwitch) {
        darkThemeBtnAction()
    }
    
    func darkThemeBtnAction(){
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.setAppTheme(.light)
        } else {
            self.setAppTheme(.dark)
        }
    }
        func setAppTheme(_ theme: UIUserInterfaceStyle) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = theme
                }
            }
            
            // Save the user's preference
            UserDefaults.standard.setValue(theme == .dark ? "dark" : "light", forKey: "appTheme")
            applySavedThemeOrSystemSetting()
        }
    
    func applySavedThemeOrSystemSetting() {
            // Check if there's a saved theme preference
            if let savedTheme = UserDefaults.standard.value(forKey: "appTheme") as? String {
                
                if savedTheme == "dark"{
                    darkModeBtn.isOn = true
                }else{
                    darkModeBtn.isOn = false
                }
                
            } else {
                
                if self.traitCollection.userInterfaceStyle == .dark {
                    darkModeBtn.isOn = true
                }else{
                    darkModeBtn.isOn = false
                }
                
            }
        
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        if notificationsEnabled {
            notificationBtn.isOn = true
        }else{
            notificationBtn.isOn = false
        }
        
        }
        
        
        
        @IBAction func selectImgeAction(_ sender: UIButton) {
            let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.presentImagePicker(sourceType: .camera)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .photoLibrary)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    //MARK: ImagePicker delegate..........................................
    extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = sourceType
            picker.allowsEditing = false
            present(picker, animated: true, completion: nil)
        }
        
        // MARK: - UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                displayImg.image = image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
