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

//37.173428, -3.599765
class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var completedUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.173417,-3.599750&radius=2000&type=atm&key=AIzaSyAzmfKoVRy8PVXp43dWj0qGjRMyzY828Vc"
    var results = [Results]()
    
    var userLocation: MKUserLocation! {
        didSet {
            if userLocation != nil {
                completedUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&radius=2000&type=atm&key=AIzaSyAzmfKoVRy8PVXp43dWj0qGjRMyzY828Vc"
                print("url -> \(completedUrl)")
                alamofireRequest(url: completedUrl)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func ZoomIn(_ sender: Any) {
        userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }

    //MARK: - Map Annotations
    func addMarkers(){

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
            mapView.addAnnotations(markers)
        }
    }

    //MARK: - custom annotation
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
    //MARK: - Launching the Maps App/ Route
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Annotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }

    //MARK: - Alamofire
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
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]

        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)


        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}


