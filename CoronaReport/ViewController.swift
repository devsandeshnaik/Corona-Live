//
//  ViewController.swift
//  CoronaReport
//
//  Created by Sandesh on 25/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import Charts
class ViewController: UIViewController {

    var countriesReport: [Country] = [] {
        didSet {
            if countriesReport.count > 0 {
                countriesReport.sort { $0.name < $1.name }
                setupStackView()
            }
        }
    }
    
    private var chartDataSet: LineChartDataSet! {
        didSet {
            if chartDataSet != nil {
                chartDataSet.setColors(.red)
                chartDataSet.lineCapType = .round
                chartDataSet.lineWidth = 2.5
                chartDataSet.mode = .cubicBezier
                chartDataSet.drawCirclesEnabled = false
                
                chartDataSet.fill = Fill(color: .red)
                chartDataSet.fillAlpha = 0.75
                chartDataSet.drawFilledEnabled = true
                chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
                chartDataSet.drawVerticalHighlightIndicatorEnabled = false
                
                let data = LineChartData()
                data.addDataSet(chartDataSet)
                data.setDrawValues(false)
                lineChartView.data = data
                lineChartView.animate(xAxisDuration: 2.3)
            }
        }
    }
    @IBOutlet private weak var countriesListStackView: UIStackView!
    @IBOutlet private weak var countriesListScrollView: UIScrollView!
    @IBOutlet private weak var lineChartView: LineChartView!
    
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet weak var confirmedCasesLabel: UILabel!
    @IBOutlet weak var recoverdCasesLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkUtility.fetchCovidUpdates() {
            self.countriesReport = $0
        }
        countriesListScrollView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        navigationItem.largeTitleDisplayMode = .always
        title = "Corona Status"
        
        setupChartView()
        
    }

    
    private func setupStackView() {
        
        setupChartDataForCounrty(at: 0)
        
        for (index,report) in countriesReport.enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
            button.tag = index
            button.backgroundColor = .systemRed
            button.titleLabel?.textColor = .white
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            button.layer.cornerRadius = button.frame.height/2
            button.addTarget(self, action: #selector(countrySelected(_:)), for: .touchUpInside)
            button.setTitle(report.name, for: .normal)
            countriesListStackView.addArrangedSubview(button)
        }
    }
    
    private func setupChartDataForCounrty(at index: Int) {
        let countryDailyReport = countriesReport[index]
        var chartData: [ChartDataEntry] = []
        for (x,dailyReport) in countryDailyReport.dailyStatus.enumerated(){
            chartData.append(ChartDataEntry(x: Double(x), y: Double(dailyReport.confirmed)))
        }
        let firsDate = countriesReport[index].dailyStatus.first?.date
        let lastDate = countriesReport[index].dailyStatus.last?.date
        chartDataSet = nil
        chartDataSet = LineChartDataSet(entries: chartData, label: "\(firsDate ?? "-") to \(lastDate ?? "-")")
        
        countryLabel.text = ": \(countriesReport[index].name)"
        let dailyReports = countriesReport[index].dailyStatus
        
        let confirmedDeaths = dailyReports.last?.confirmed
        let recovered = dailyReports.last?.recoverd
        let deaths = dailyReports.last?.deaths
        
        confirmedCasesLabel.text = ": \(confirmedDeaths ?? 0)"
        recoverdCasesLabel.text = ": \(recovered ?? 0)"
        deathsLabel.text = ": \(deaths ?? 0)"
    }
    
    private func setupChartView() {
        lineChartView.rightAxis.enabled = false
        let yAxis = lineChartView.leftAxis
        yAxis.setLabelCount(8, force: false)
        yAxis.labelTextColor = .red
        yAxis.axisLineColor = .red
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.setLabelCount(8, force: false)
        lineChartView.xAxis.axisLineColor = .blue
        
        
    }
    
    @objc private func countrySelected(_ sender: UIButton) {
        setupChartDataForCounrty(at: sender.tag)
    }
    

}

