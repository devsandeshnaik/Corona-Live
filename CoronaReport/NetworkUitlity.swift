//
//  NetworkUitlity.swift
//  Corona
//
//  Created by Sandesh on 25/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation


struct NetworkUtility {
    
    
    
    static  func fetchCovidUpdates(_ completionHandler: @escaping ([Country]) -> ()) {
        guard let url = URL(string: "https://pomber.github.io/covid19/timeseries.json") else {
            fatalError("Invalid url")
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { data, response, error  in
            if error == nil {
                if data != nil {
                    do {
                        if let report = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? [String: Any] {
                            
                            DispatchQueue.main.async {
                                let report = generateLocalData(from: report)
                                completionHandler(report)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("Empty data")
                }
            } else {
                print(error!.localizedDescription)
            }
        }.resume()
    }
    
    
    private static func generateLocalData(from data: [String: Any]) -> [Country] {

        var contriesReport: [Country] = []
        
        for key in data.keys {
            if let dailyReport = data[key] as? [Any] {
                if let dailyReportData = try? JSONSerialization.data(withJSONObject: dailyReport, options: .fragmentsAllowed) {
                    let jsonDecoder = JSONDecoder()
                    guard let dailyReports = try? jsonDecoder.decode([DailyStatus].self, from: dailyReportData) else {
                        fatalError("Daily reports we not formatabble for \(key)")
                    }
                    contriesReport.append(Country(name: key, dailyStatus: dailyReports))
                }
            }
        }
        
        return contriesReport
    }
}
