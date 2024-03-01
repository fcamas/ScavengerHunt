//
//  PlaceDetailViewController.swift
//  ScavengerHunt
//
//  Created by Fredy Camas on 2/29/24.
//

import UIKit
import MapKit
import PhotosUI

class PlaceDetailViewController: UIViewController {
    var completedImageView: UIImageView!
    var completedLabel: UILabel!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var attachPhotoButton: UIButton!
    var mapView: MKMapView!
    
    
    var place: Place!
    
    // Constants for attachPhotoButton
    let buttonTitle = "Attach Photo"
    let buttonBackgroundColor = UIColor.systemGreen
    let buttonCornerRadius: CGFloat = 8.0 // Adjust as needed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
        updateMapView()
    }
    
    private func setupUI(){
        completedImageView = UIImageView()
        completedLabel = UILabel()
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        attachPhotoButton = UIButton()
        mapView = MKMapView()
        
        completedImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completedImageView)
        
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completedLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0 // Allow multiple lines
        descriptionLabel.lineBreakMode = .byWordWrapping
        view.addSubview(descriptionLabel)
        
        // Set constants for attachPhotoButton
        attachPhotoButton.setTitle(buttonTitle, for: .normal)
        attachPhotoButton.backgroundColor = buttonBackgroundColor
        attachPhotoButton.layer.cornerRadius = buttonCornerRadius
        attachPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(attachPhotoButton)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            
            completedImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            completedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedImageView.widthAnchor.constraint(equalToConstant: 24),
            completedImageView.heightAnchor.constraint(equalToConstant: 24),
            
            completedLabel.topAnchor.constraint(equalTo: completedImageView.topAnchor),
            completedLabel.leadingAnchor.constraint(equalTo: completedImageView.trailingAnchor, constant: 16),
            completedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: completedImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            mapView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3),
            
            attachPhotoButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            attachPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            attachPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            attachPhotoButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            attachPhotoButton.heightAnchor.constraint(equalToConstant: 32),
            
            
            
        ])
        
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.identifier)
        mapView.delegate = self
        mapView.layer.cornerRadius = 12
        
        attachPhotoButton.addTarget(self, action: #selector(didTapAttachPhotoButton), for: .touchUpInside)
    }
    
    private func updateUI() {
        titleLabel.text = place.title
        descriptionLabel.text = place.description
        
        let completedImage = UIImage(systemName: place.isComplete ? "checkmark.circle": "circle")
        completedImageView.image = completedImage?.withRenderingMode(.alwaysTemplate)
        completedLabel.text = place.isComplete ? "Complete" : "Incomplete"
        
        let color: UIColor = place.isComplete ? .systemGreen : .systemRed
        completedImageView.tintColor = color
        completedLabel.textColor = color
        
        attachPhotoButton.isHidden = place.isComplete
        
    }
    
    @objc private func didTapAttachPhotoButton() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized{
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                
                switch status{
                case.authorized:
                    DispatchQueue.main.async {
                        self?.presentImagePicker()
                    }
                default:
                    DispatchQueue.main.async {
                        self?.presentGoToSettingsAlert()
                    }
                }
            }
        } else {
            presentImagePicker()
        }
    }
    
    private func presentImagePicker(){
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration:  config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentGoToSettingsAlert(){
        
        let alertController = UIAlertController(
            title: "Photo Access Required",
            message: "In order to post a photo to complete a task, we need access to your photo library. You can allow access in Settings",
            preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settigns", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl){
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlert(for error: Error? = nil) {
        let alertController = UIAlertController(title: "Ooops..", message: "\(error?.localizedDescription ?? "Please try again ...")", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    func updateMapView() {
        guard let imageLocation = place.imageLocation else { return }
        let coordinate = imageLocation.coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate  = coordinate
        mapView.addAnnotation(annotation)
    }
}


extension PlaceDetailViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PlaceAnnotationView.identifier, for: annotation) as? PlaceAnnotationView else {
            fatalError("Unable to dequeue TaskAnnotationView")
        }
        annotationView.configure(with: place.image)
        return annotationView
    }
}

extension PlaceDetailViewController: PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //This is where we'll get the picked image in the next step...
        
        //Dismiss the picker
        picker.dismiss(animated: true)
        
        //Get the selected image asset(we can grab the 1st item in the array since we only allowed a selection limit of 1
        let result = results.first
        
        //Get image location
        //PHAsset contains metadata about an image or video(ex. location, sizze, etc)
        
        guard let assetId = result?.assetIdentifier,
              let location = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject?.location else {
            return
        }
        print("📍 Image location coordinate: \(location.coordinate)")
        
        //Make sure we have a non-nil item provdier
        
        guard let provider = result?.itemProvider,
              //Make sure the provdier can load an UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        // Load a UIImage from the provdier
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            //Handle any error
            if let error =  error{
                DispatchQueue.main.async { [weak self] in self?.showAlert(for: error)}
            }
            
            //Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else { return }
            print(" 🥳We have an Image")
            
            // UI updates should be done on main thread, hence the user of 'DispatchQueue.main.async'
            
            DispatchQueue.main.async { [weak self] in
                
                //Set teh picked image and location on the task
                self?.place.set(image, with: location)
                
                //Update the Ui since we've updated the task
                self?.updateUI()
                
                //Update the map view sicne we now have an image an location
                self?.updateMapView()
            }
        }
    }
    
    
}

