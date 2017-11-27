//
//  MealListTableViewController.swift
//  SwiftBasics
//
//  Created by aashish chadha on 20/10/17.
//  Copyright © 2017 vishalb. All rights reserved.
//

import UIKit
import os.log

import Alamofire
import Kingfisher

class MealListTableViewController: UITableViewController  {
    
    var meals = [Meals]()
    var movieList = [MovieDetails]()
    var movieSearchList = [MovieDetails]()
    let searchController = UISearchController(searchResultsController: nil)
    var numOfSections: Int = 0
    var errorMessage : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        //getAllMovieList(param : "all")
        
        
         getOrders(param : "all") { responseObject, error in
            guard let value = responseObject  else {
                print("Malformed data received from fetchAllRooms service")
                return
                
            }
            
         self.setValue(value)
            return
        }
        
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }else{
      addMealImages()
        }
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//
        return setSectionValue()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchController.isActive && !searchBarIsEmpty() {
            return movieSearchList.count
        } else {
            return movieList.count
        }
        
    }
    
    func setSectionValue() -> Int
    {
        var numOfSections: Int = 0
                var movieL: Int = 0
        
                if searchController.isActive && !searchBarIsEmpty() {
                    movieL = movieSearchList.count
                }
                else
                {
                    movieL = movieList.count
                }
        
                if  movieL > 0
                {
                    tableView.separatorStyle = .singleLine
                    numOfSections            = 1
                    tableView.backgroundView = nil
                }
                else
                {
                    let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                    noDataLabel.text = errorMessage
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    tableView.backgroundView  = noDataLabel
                    tableView.separatorStyle  = .none
                    numOfSections            = 0
        
                }
                return numOfSections
    }
    
   
    func setValue(_ val : NSDictionary )
    {
        guard let value = val as? [String: Any] else {
            print("Malformed data received from fetchAllRooms service")
            return
            
        }
        // use responseObject and error here
        var existingItems = value["Search"] as? [[String: String]] ?? [[String: String]]()
        let error = value["Error"] as? String ?? String()
        errorMessage = error
        print(existingItems)
        
        for i in 0..<existingItems.count
        {
            
            
            let title = existingItems[i]["Title"] ?? String()
            let Poster = existingItems[i]["Poster"] ?? String()
            let Type = existingItems[i]["Type"] ?? String()
            let Year = existingItems[i]["Year"] ?? String()
            let imdbID = existingItems[i]["imdbID"] ?? String()
            
            guard let movies = MovieDetails(Title: title, Poster: Poster, Type: Type, Year: Year, imdbID: imdbID) else
            {
                fatalError("Unable to instantiate meal1")
                
            }
            
            if self.searchController.isActive && !self.searchBarIsEmpty() {
                self.movieSearchList += [movies]
            }
            else{
                self.movieList += [movies]
            }
            
            
            
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        movieSearchList = movieList.filter({( movie : MovieDetails) -> Bool in
            return movie.Title.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cellIdentifier = "MealListTableViewCell"
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealListTableViewCell  else {
//            fatalError("The dequeued cell is not an instance of MealListTableViewCell.")
//        }
//
//
//        let meal = meals[indexPath.row]
//
//
//
//        cell.mealName.text  = meal.name
//        cell.mealImage.image = meal.photo
//        cell.mealRating.rating = meal.rating
//
//        return cell
        let cellIdentifier = "MealListTableViewCell"
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealListTableViewCell  else {
//            fatalError("The dequeued cell is not an instance of MealListTableViewCell.")
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MealListTableViewCell
//
//        var arrayOfSpecies:[MovieDetails]
//        if searchController.isActive && !searchBarIsEmpty() {
//            arrayOfSpecies = movieSearchList
//        } else {
//            arrayOfSpecies = movieList
//        }
        let cell : MealListTableViewCell = {
            guard let cellList = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? MealListTableViewCell else {
                return MealListTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        }
            return cellList
        }()

        let movieL : MovieDetails
        
        if searchController.isActive && !searchBarIsEmpty() {
             movieL = movieSearchList[indexPath.row]
        }
        else
        {
         movieL = movieList[indexPath.row]
        }
        
         if  let moviePoster = movieL.Poster
           {
            let url = URL(string: moviePoster)
            cell.mealImage.kf.setImage(with: url)
        }
        cell.mealName.text  = movieL.Title
        cell.movieYear.text = movieL.Year
        //cell.mealRating.rating = meal.rating
        
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if searchController.isActive && !searchBarIsEmpty() {
                movieSearchList.remove(at: indexPath.row)

            }
            else{
                movieList.remove(at: indexPath.row)

            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        saveMeals()
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealListTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeal : MovieDetails
            
            if searchController.isActive && !searchBarIsEmpty() {
                selectedMeal = movieSearchList[indexPath.row]
            }
            else
            {
                selectedMeal = movieList[indexPath.row]
            }
            
            mealDetailViewController.movie = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }
    

  private  func addMealImages()
    {
        let photo1 = UIImage(named: "meal 1")
        let photo2 = UIImage(named: "meal 2")
        let photo3 = UIImage(named: "meal 3")
        
        guard let meal1 = Meals(name: "Caprese Salad", photo: photo1) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meals(name: "Chicken and Potatoes", photo: photo2) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meals(name: "Pasta with Meatballs", photo: photo3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        meals += [meal1 , meal2 ,meal3]
        
    }
    
    //MARK : Action
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveMeals()
        }
    }
    
    private func saveMeals()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meals.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meals]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meals.ArchiveURL.path) as? [Meals]
    }
    
    
    
    //Fetch movie list
    private func getAllMovieList(param : String)
    {
        
        //  http://www.omdbapi.com/?s=all&apikey=2f1f995d
        let strURL = "http://www.omdbapi.com/"
        let param = ["s": param, "apikey": "2f1f995d"]
        // Alamofire.request(strURL, method: .GET, parameters: param, encoding:.UTF8, headers: nil).responseJSON(completionHandler: <#T##(DataResponse<Any>) -> Void#>)
       
        Alamofire.request( URL(string: strURL)!, method: .get, parameters: param) .validate() .responseJSON {
            (response) -> Void in
            guard response.result.isSuccess
                else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    return
            }
            print(response.result.value!)
           // let dict: [String: Any] = ["Search": response.result.value]

            guard let value = response.result.value as? [String: Any] else {
                print("Malformed data received from fetchAllRooms service")
                return
                
            }
           
            // get existing items, or create new array if doesn't exist
            var existingItems = value["Search"] as? [[String: String]] ?? [[String: String]]()
            
            print(existingItems)
            
            for i in 0..<existingItems.count
                {
                   
                    
                    let title = existingItems[i]["Title"] ?? String()
                    let Poster = existingItems[i]["Poster"] ?? String()
                    let Type = existingItems[i]["Type"] ?? String()
                    let Year = existingItems[i]["Year"] ?? String()
                    let imdbID = existingItems[i]["imdbID"] ?? String()
                    
                guard let movies = MovieDetails(Title: title, Poster: Poster, Type: Type, Year: Year, imdbID: imdbID) else
                {
                    fatalError("Unable to instantiate meal1")

                    }

                    if self.searchController.isActive && !self.searchBarIsEmpty() {
                        self.movieSearchList += [movies]
                    }
                    else{
                        self.movieList += [movies]
                    }
                    
                    

            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }

            
            //            guard let rows = value["rows"] as? [[String: Any]] else{
//                print("Malformed data received from fetchAllRooms service")
//                return
//
//            }
            
           // print(rows)
        }
    
    }
}
func getOrders(param : String,completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
    makeCall(param, completionHandler: completionHandler)
}
func makeCall(_ section: String, completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
    let params = ["s": section, "apikey": "2f1f995d"]
    let strURL = "http://www.omdbapi.com/"
    Alamofire.request(strURL, parameters: params)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
    }
}

extension MealListTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
        getOrders(param : searchController.searchBar.text!) { responseObject, error in
            guard let value = responseObject  else {
                print("Malformed data received from fetchAllRooms service")
                return
                
            }
            
            self.setValue(value)
            return
        }
    }
}


