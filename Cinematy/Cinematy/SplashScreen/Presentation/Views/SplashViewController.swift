//
//  SplashViewController.swift
//  Cinematy
//
//  Created by Mohamed Youssef Al-Azizy on 11/05/2025.
//


import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!

    @IBOutlet weak var movieLabel: UILabel!
    
    var viewModel: SplashViewModelContract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = Localize.Splash.welcomeTo
        movieLabel.text = Localize.appName
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.navigateTo(to: .Home)
        }
        
    }
}
