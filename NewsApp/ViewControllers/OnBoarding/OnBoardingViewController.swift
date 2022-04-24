//
//  OnBoardingViewController.swift
//  NewsApp
//
//  Created by Esraa Hamed on 22/04/2022.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var countriesPickerView: UIPickerView!
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    
    @IBOutlet weak var continueBtn: UIButton!
    var categoriesList: [String] = []
    var countriesList: [CountryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    func initialSetup() {
        setDelegates()
        setUISetup()
        
        categoriesList = Categories.categories
        countriesList = CountriesNames.countriesName
        
        if !countriesList.isEmpty && !categoriesList.isEmpty {
            UserDefaults.standard.set(countriesList[0].countryCode, forKey: "countryCode")
            UserDefaults.standard.set(categoriesList[0], forKey: "category")
        }
        
    }
    
    func setDelegates() {
        countriesPickerView.delegate = self
        countriesPickerView.dataSource = self
        
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
    }
    
    func setUISetup() {
        continueBtn.layer.cornerRadius = 25
        
        categoriesPickerView.setValue(UIColor(red: 0.20, green: 0.35, blue: 0.65, alpha: 1.0), forKeyPath: "textColor")
        countriesPickerView.setValue(UIColor(red: 0.20, green: 0.35, blue: 0.65, alpha: 1.0), forKeyPath: "textColor")
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        showConfirmationAlert()
        
    }
    
    /// Adding confirmation alert for confirm user before navigating to the main screen
    func showConfirmationAlert() {
        let alert = UIAlertController(title: "Are you sure?", message: "By pressing continue, you can see your country, favortie category news", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:  { [weak self] _ in
            if let newsHeadlinesScreen =
                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as? UINavigationController {
                newsHeadlinesScreen.modalPresentationStyle = .fullScreen
                newsHeadlinesScreen.modalTransitionStyle = .flipHorizontal
                self?.present(newsHeadlinesScreen, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension OnBoardingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countriesPickerView {
            return countriesList.count
        } else if pickerView == categoriesPickerView {
            return categoriesList.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countriesPickerView {
            UserDefaults.standard.set(countriesList[row].countryCode, forKey: "countryCode")
        } else if pickerView == categoriesPickerView {
            UserDefaults.standard.set(categoriesList[row], forKey: "category")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->String? {
        let titleForRow  = "Not Found"
        if pickerView == countriesPickerView {
            return countriesList[row].countryName
            
        } else if pickerView == categoriesPickerView {
            return categoriesList[row].capitalized
        }
        return titleForRow
    }
    
}
