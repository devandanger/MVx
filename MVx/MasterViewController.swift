//
//  MasterViewController.swift
//  MVx
//
//  Created by Evan Anger on 12/2/18.
//  Copyright © 2018 Mighty Strong Software. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    var examples: [Example] = Example.allCases


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError("Unable to dequeue at: \(indexPath)")
        }

        let example = examples[indexPath.row]
        cell.textLabel?.text = example.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        
        let vc = example.viewcontroler
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

