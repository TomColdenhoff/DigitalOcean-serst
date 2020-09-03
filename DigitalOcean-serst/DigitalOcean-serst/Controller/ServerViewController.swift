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
    var cachedDropletInfo: CachedDroplet?
    
    var prometheusManager: PrometheusManager?
    @IBOutlet weak var cpuChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let safeDroplet = droplet else {
            return
        }
        
        navigationItem.title = safeDroplet.name
        
        if cachedDropletInfo?.prometheusApiUrl != nil {
            SetPrometheusManager(apiUrl: cachedDropletInfo!.prometheusApiUrl!)
            updateCharts()
        } else {
            presentAddPrometheusUrlAlert()
        }
    }
    
    private func presentAddPrometheusUrlAlert() {
        var urlTextField = UITextField()
        let alertController = UIAlertController(title: "Add Prometheus Api Url", message: "Add a prometheus api url", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "url"
            urlTextField = textField
        }
        let alertAddAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if let url = urlTextField.text {
                self.cachedDropletInfo?.setPrometheusApiUrl(url)
                self.SetPrometheusManager(apiUrl: self.cachedDropletInfo!.prometheusApiUrl!)
                self.updateCharts()
            }
        }
        alertController.addAction(alertAddAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        presentUpdatePrometheusUrlAlert()
    }
    
    private func presentUpdatePrometheusUrlAlert() {
        var urlTextField = UITextField()
        let alertController = UIAlertController(title: "Update Prometheus Api Url", message: "Update the prometheus api url for this droplet.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = self.cachedDropletInfo?.prometheusApiUrl
            urlTextField = textField
        }
        let alertUpdateAction = UIAlertAction(title: "Update", style: .default) { (updateAction) in
            if let url = urlTextField.text {
                self.cachedDropletInfo?.setPrometheusApiUrl(url)
                self.SetPrometheusManager(apiUrl: self.cachedDropletInfo!.prometheusApiUrl!)
                self.updateCharts()
            }
        }
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(alertUpdateAction)
        alertController.addAction(alertCancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func SetPrometheusManager(apiUrl: String) {
        prometheusManager = PrometheusManager(apiUrl: apiUrl)
        prometheusManager?.delegate = self
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
    
    private func updateCharts() {
        prometheusManager?.LoadAllQueries()
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

extension ServerViewController: PrometheusManagerDelegate {
    
}
