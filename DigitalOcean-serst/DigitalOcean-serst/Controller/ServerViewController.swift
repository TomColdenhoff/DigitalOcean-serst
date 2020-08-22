//
//  ServerViewController.swift
//  DigitalOcean-serst
//
//  Created by Tom Coldenhoff on 18/08/2020.
//  Copyright © 2020 Tom Coldenhoff. All rights reserved.
//

import UIKit
import Charts

class ServerViewController: UIViewController {

    var droplet: Droplet?
    @IBOutlet weak var cpuChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let safeDroplet = droplet else {
            return
        }
        
        navigationItem.title = safeDroplet.name
        updateCpuChart()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Server.EmbeddedDropletInfoSegue {
            let dropletInfoViewController = segue.destination as! DropletInfoTableViewController
            dropletInfoViewController.dropletViewModel = droplet
            dropletInfoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    private func updateCpuChart() {
        let entry1 = ChartDataEntry(x: 0, y: 50)
        let entry2 = ChartDataEntry(x: 1, y:51)
        let entry3 = ChartDataEntry(x: 2, y: 40)
        let entry4 = ChartDataEntry(x: 3, y: 43)
        
        let dataSet = LineChartDataSet(entries: [entry1, entry2, entry3, entry4])
        cpuChart.data = LineChartData(dataSet: dataSet)
        cpuChart.chartDescription?.text = "CPU usage of your server"
        cpuChart.leftAxis.axisMinimum = 0
        cpuChart.leftAxis.axisMaximum = 100
        
        
        cpuChart.notifyDataSetChanged()
    }
}
