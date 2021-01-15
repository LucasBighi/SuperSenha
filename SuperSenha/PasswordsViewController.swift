//
//  PasswordsViewController.swift
//  SuperSenha
//
//  Created by Lucas Marques Bighi on 02/12/2018.
//  Copyright © 2018 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class PasswordsViewController: UIViewController {

    @IBOutlet weak var tableViewPasswords: UITableView!
    @IBOutlet weak var generateButton: UIButton!
    
    var numberOfCharacters: Int = 10
    var numberOfPasswords: Int = 1
    var userLetters: Bool!
    var useNumbers: Bool!
    var useCapitalLetters: Bool!
    var userSpecialCharacters: Bool!
    var mustShowStoredPasswords: Bool!
    
    var passwordGenerator: PasswordGenerator!
    var passwords: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewPasswords.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewPasswords.tableFooterView = UIView()
        tableViewPasswords.delegate = self
        tableViewPasswords.dataSource = self
        passwordGenerator = PasswordGenerator(numberOfCharacters: numberOfPasswords,
                                              useLetters: userLetters,
                                              useNumbers: useNumbers,
                                              useCapitalLetters: useCapitalLetters,
                                              useSpecialCharacters: userSpecialCharacters)
        generateButton.isHidden = mustShowStoredPasswords
        if mustShowStoredPasswords {
            getStoredPasswords()
        } else {
            generatePasswords()
        }
    }
    
    func getStoredPasswords() {
        if let storedPasswords = DB.getPasswords() {
            self.passwords = storedPasswords
            title = "Senhas Salvas: \(storedPasswords.count)"
            tableViewPasswords.reloadData()
        }
    }
    
    func generatePasswords() {
        title = "Total de Senhas: \(numberOfPasswords)"
        self.passwords = passwordGenerator.generate(total: numberOfPasswords)
        tableViewPasswords.reloadData()
    }
    
    @IBAction func generate(_ sender: UIButton) {
        generatePasswords()
    }
}

extension PasswordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        cell.textLabel?.textColor = #colorLiteral(red: 0.6677729487, green: 0.2258901596, blue: 0.4715791345, alpha: 1)
        cell.textLabel?.text = passwords?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPassword = passwords?[indexPath.row] {
            let alert = UIAlertController(title: "Salvar senha", message: "Deseja salvar a senha '\(selectedPassword)' ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salvar", style: .default, handler: {_ in
                DB.store(password: selectedPassword)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
