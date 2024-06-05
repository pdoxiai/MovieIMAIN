//
//  ViewController.swift
//  A004IAI
//
//  Created by comsoft on 2024/05/01.
//

import UIKit

let name = ["aaa","bbb","ccc","ddd","eee"]
struct MovieData : Codable {
    let boxOfficeResult : BoxOfficeResult
}
struct BoxOfficeResult : Codable {
    let dailyBoxOfficeList : [DailyBoxOfficeList]
}
struct DailyBoxOfficeList : Codable {
    let movieNm : String
    let salesAmt : String
    let salesAcc : String
    let rank : String
}
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!
    var movieData : MovieData?
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=321b163129240f64cf9b7dabd028b14c&targetDt="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        movieURL += makeYesterdayString()
        getData()
    }
    func makeYesterdayString() -> String {
        let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyyMMdd"
        let day = dateF.string(from: y)
        return day
    }
    
    func getData(){
        guard let url = URL(string: movieURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            guard let JSONdata = data else { return }
            let dataString = String(data: JSONdata, encoding: .utf8)
            print(dataString!)
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(MovieData.self, from : JSONdata)
                print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
                self.movieData = decodedData
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }catch {
                print(error)
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailViewController
        dest.movieName = "영화 이름"
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
        print(row)
        dest.movieName = (movieData?.boxOfficeResult.dailyBoxOfficeList[row].movieNm)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        guard let mRank = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].rank else {return UITableViewCell()}
        guard let mName = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm else {return UITableViewCell()}
        
        cell.movieName.text = "[\(mRank)위] \(mName)"
        
        if let sAmt = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].salesAmt {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let sAmount = Int(sAmt)!
            let result = numF.string(for: sAmount)!+"원"
            cell.salesAmount.text = "어제 : \(result)"
        }
        if let sAcc = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].salesAcc {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let sAcc1 = Int(sAcc)!
            let result = numF.string(for: sAcc1)!+"원"
            cell.salesAccumulate.text = "누적 : \(result)"
        }
        // cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        // cell.salesAccumulate.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].salesAcc
        // cell.salesAmount.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].salesAmt
        return cell
    }
    
    struct MovieData : Codable {
        let boxOfficeResult : BoxOfficeResult
    }
    struct BoxOfficeResult : Codable {
        let dailyBoxOfficeList : [DailyBoxOfficeList]
    }
    struct DailyBoxOfficeList : Codable {
        let movieNm : String
        let salesAmt : String
        let salesAcc : String
        let rank : String
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "🍿박스오피스매출액(영화진흥위원회제공:"+makeYesterdayString()+")🍿"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "🏀🏀🏀🏀🏀🏀🏀by Ain IM🏀🏀🏀🏀🏀🏀🏀"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }
    
}
