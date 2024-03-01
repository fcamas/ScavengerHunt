//
//  TaskModel.swift
//  ScavengerHunt
//
//  Created by Fredy Camas on 2/28/24.
//

import UIKit
import CoreLocation

class Place{
    let title: String
    let description: String
    var image: UIImage?
    var imageLocation: CLLocation?
    var isComplete: Bool {
        image != nil
    }
    
    init(title:String, description:String){
        self.title = title
        self.description = description
    }
    
    func set(_ image: UIImage, with location: CLLocation){
        self.image = image
        self.imageLocation = location
    }
}

extension Place {
    static var mockedPlaces: [Place] {
        return [
            
            Place(title: "Golden Gate Park",
                 description: "One of San Francisco's most iconic attractions, Golden Gate Park offers stunning landscapes, botanical gardens, museums, and recreational activities for all ages."),
            Place(title: "Fisherman's Wharf",
                 description: "A bustling waterfront area known for its seafood restaurants, souvenir shops, and scenic views of the bay. Don't miss attractions like Pier 39 and the historic Hyde Street Pier."),
            Place(title: "Alcatraz Island",
                 description: "A historic island in the San Francisco Bay, famous for its former federal prison and intriguing history. Take a ferry ride to explore the island and its fascinating exhibits."),
            Place(title: "Chinatown",
                 description: "One of the largest and oldest Chinatowns in North America, offering vibrant streets filled with colorful shops, authentic cuisine, and cultural landmarks."),
            Place(title: "Lands End",
                 description: "A breathtaking natural area located along the rugged coastline of San Francisco. Enjoy scenic hiking trails, stunning views of the Golden Gate Bridge, and historic landmarks like the Sutro Baths ruins."),
            Place(title: "Coit Tower",
                 description: "An iconic landmark perched atop Telegraph Hill, offering panoramic views of the city skyline and the San Francisco Bay. Explore the art deco tower and its beautiful murals depicting scenes of local history."),
            Place(title: "Palace of Fine Arts",
                 description: "A stunning architectural masterpiece nestled in the Marina District. Marvel at the majestic rotunda, serene lagoon, and classical columns inspired by ancient Greek and Roman architecture."),
            Place(title: "The Painted Ladies",
                 description: "A row of colorful Victorian houses located near Alamo Square, often referred to as the 'Painted Ladies'. These picturesque homes provide a quintessential backdrop for photos and offer a glimpse into San Francisco's architectural charm.")
            
        ]
    }
}
