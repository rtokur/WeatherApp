//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rumeysa Tokur on 16.03.2025.
//

import UIKit

class ViewController: UIViewController {

    var weatherViewModel = WeatherViewModel()
    var currentWeather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        Task{
            currentWeather = try await weatherViewModel.createRealtimeWeather()
        }
        
    }
    

}

