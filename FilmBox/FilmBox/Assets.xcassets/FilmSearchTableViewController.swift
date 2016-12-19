//
//  FilmSearchTableViewController.swift
//  FilmBox
//
//  Created by Alexander Shipunov on 19/12/2016.
//  Copyright © 2016 Alexander Shipunov. All rights reserved.
//

import UIKit
import Alamofire

class foundFilm {
    let title : String
    let year : String
    let imdbID : String
    var saved = false
    
    init(title: String, year: String, imdbID: String) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
    }
}

class FilmSearchTableViewController: UITableViewController {
    
    var films = [foundFilm]()
    
    var searchUrl = "http://www.omdbapi.com/?s=Interstellar&y=&plot=short&r=json"
    
    typealias JSONtype = [String : AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSearchData(url: searchUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSearchData(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: { response in
            
            self.parseData(JSONData: response.data!)
            
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONtype
            if let items = readableJSON["Search"] {
                for i in 0..<items.count {
                    let film = items[i] as! JSONtype
                    
                    print(film["Title"]!)
                    print(film["Year"]!)
                    print(film["imdbID"]!)
                    
                    films.append(foundFilm.init(title: film["Title"] as! String!, year: film["Year"] as! String!, imdbID: film["imdbID"] as! String!))
                    
                    self.tableView.reloadData()
                }
            }
     //       print(readableJSON)
        } catch {
            print(error)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return films.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "filmSearchCell")
        
        let titleLable = cell?.viewWithTag(1) as! UILabel
        let yearLable = cell?.viewWithTag(2) as! UILabel
        
        titleLable.text = films[indexPath.row].title
        yearLable.text = films[indexPath.row].year

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let foundFilm = films[indexPath.row]
        
        foundFilm.saved = !foundFilm.saved
        
        if foundFilm.saved {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
