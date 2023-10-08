//
//  ViewController.swift
//  testIntUIKIT
//
//  Created by Hassan Aljanahi on 08/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var pageCollectionController: UIPageControl!
    @IBOutlet private var searchBar: UISearchBar!
    
    var data = [[example]]()
    var filterdata = [[example]]()
    var exampleImages = ExampleImages()
    var startIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setup()
        self.fetchExamples()
    }
    
    func setup() {
        self.setupTableView()
        self.setupCollectionView()
        self.searchBar.delegate = self
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func fetchExamples() {
        exampleImages.getData { data in
            DispatchQueue.main.async {
                self.data = data.chunked(into: 100)
                self.filterdata = data.chunked(into: 100)
                self.pageCollectionController.numberOfPages = self.filterdata.count
                self.pageCollectionController.currentPage = 0
                self.collectionView.reloadData()
                self.tableView.reloadData()
                
            }
        }
       
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterdata.isEmpty {
            return 0
        }
        return filterdata[self.pageCollectionController.currentPage].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        let data = filterdata[self.pageCollectionController.currentPage]
        cell.setup(url: data[indexPath.row].url, title: data[indexPath.row].title)
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageCollectionController.numberOfPages = filterdata.count
        return filterdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCarousel", for: indexPath) as! ImageCarouselCell
        if !filterdata[self.pageCollectionController.currentPage].isEmpty {
            cell.setup(url: filterdata[self.pageCollectionController.currentPage].first?.url ?? "")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            return
        }
        if scrollView.contentOffset.x == 0 {
            return
        }
        let last = self.pageCollectionController.currentPage
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        self.pageCollectionController.currentPage = Int(offSet + horizontalCenter) / Int(width)
        if last == self.pageCollectionController.currentPage {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    
    }
    
}


extension ViewController: UISearchBarDelegate {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdata.removeAll()
        
        if searchText.isEmpty {
            filterdata = data
        } else {
            
            for exampleArr in data {
                var arr = [example]()
                for (index, example) in exampleArr.enumerated() {
                    if example.title.lowercased().contains(searchText.lowercased()) {
                        
                        arr.append(example)
                    }
                    if index == exampleArr.count - 1 {
                        self.filterdata.append(arr)
                    }
                }
            }
        }
        self.pageCollectionController.numberOfPages = self.filterdata.count
        self.pageCollectionController.currentPage = 0
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
