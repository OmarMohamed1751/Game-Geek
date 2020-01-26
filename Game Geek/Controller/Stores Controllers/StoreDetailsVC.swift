//
//  StoreDetailsVC.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/25/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import UIKit

class StoreDetailsVC: UIViewController {
    
    @IBOutlet weak var storeNameView: UIView!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeWebsiteLbl: UILabel!
    @IBOutlet weak var storeDescription: UITextView!
    
    var storeNameString = ""
    var storeImageURLString = ""
    var storeURLString = ""
    var storeDescriptionString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        basicUISetup()
    }
    
    func basicUISetup() {
        showIndicator(withTitle: "Loading..", and: "")
        storeImage.layer.cornerRadius = 10
        storeNameView.layer.cornerRadius = 10
        storeNameView.layer.borderWidth = 1
        storeNameView.layer.borderColor = #colorLiteral(red: 0, green: 0.7281640172, blue: 0.7614847422, alpha: 1)
        storeNameLbl.adjustsFontSizeToFitWidth = true
        storeNameLbl.text = storeNameString
        storeImage.kf.setImage(with: URL(string: storeImageURLString), placeholder: UIImage(systemName: "dollarsign.circle.fill"))
        storeDescription.text = storeDescriptionString
        storeDescription.layer.cornerRadius = 5
        storeWebsiteLbl.text = storeURLString
        hideIndicator()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func storeWebsiteTapped(_ sender: UIButton) {
        guard let url = URL(string: storeWebsiteLbl.text ?? "We Couldn't Find The Store Website!") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
