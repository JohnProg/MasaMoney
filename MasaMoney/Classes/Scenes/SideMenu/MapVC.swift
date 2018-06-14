//
//  MapVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 01/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapVC: UIViewController, CLLocationManagerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    var results = [Results]()
    
    //Set and address by default
    var completedUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.173417,-3.599750&radius=4000&type=atm&key=AIzaSyAzmfKoVRy8PVXp43dWj0qGjRMyzY828Vc"
    private var apiCallMade = false
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        // Check for Location Services
        checkLocationAuthorizationStatus()
        
        // Use custom annotation
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Check connection
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(style: .alert, title: Strings.noConnection, message: Strings.noConnectionMessage)
            alert.addAction(title: Strings.cancel, style: .cancel)
            alert.show()
        }
    }
    
    //MARK: - Functions
    
    func centerMapOnLocation(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func alamofireRequest(url: String) {
        Alamofire.request(url)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    //retrieving the response as data to decode it
                    guard let result = response.data else { return }
                    do{
                        if let atm = try JSONDecoder().decode(ATM.self, from: result) as? ATM
                        {
                            self.results = atm.results!
                            self.addMarkers()
                        }
                    } catch let error {
                        print ("Error JSONDecoder ->\(error)")
                    }
                    
                case .failure(_):
                    print("Error-> request = failure")
                }
        }
    }

    //MARK: - Map Annotations
    func addMarkers(){
        //Run through results creatting annotations
        for atm in results {
            var placeName = ""
            var placeAddress = ""
            var latitude = 0.0
            var longitude = 0.0

            placeName = atm.name!
            placeAddress = atm.vicinity!
            latitude = (atm.geometry?.location?.lat!)!
            longitude = (atm.geometry?.location?.lng!)!

            let marker = Annotation(title: "\(placeName)",
                address: "\(placeAddress)",
                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))

            var markers = [Annotation]()
            markers.append(marker)
            //Set all the annotations in the map
            mapView.addAnnotations(markers)
        }
    }

    // custom annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView
        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.markerTintColor = .purple
        view.glyphImage = #imageLiteral(resourceName: "atm-1")
        view.clusteringIdentifier = "atm"

        return view
    }
    
    // Launching the Maps App/ Route
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Annotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

extension MapVC :  MKMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.showsUserLocation = true
        //Do api call with user Location just once using bool: apiCallMade
        if mapView.isUserLocationVisible, apiCallMade == false  {
            self.centerMapOnLocation(region: region)
            completedUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(mapView.userLocation.coordinate.latitude),\(mapView.userLocation.coordinate.longitude)&radius=9000&type=atm&key=AIzaSyAzmfKoVRy8PVXp43dWj0qGjRMyzY828Vc"
            alamofireRequest(url: completedUrl)
            apiCallMade = true
        }
    }
}
