//
//  OpportunitesDetailsViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 4/7/22.
//

import Foundation

/*
 1. Title, location and category
 2. Type of help
 3. Description Optional
 4. Availability Dates
 5. Map
 6. Accommodation provided
 7. Meals provided
 8. Stay at least, stay up to
 9. Languages Required
 10. Languages Spoken
 11. Learning opportunites
 12. Do workntour (for travellers only!)

 */

class OpportunitesDetailsViewModel: BaseViewModel {

    /// Outputs
    @Published var images: [URL?] = []
    var headerModel: OpportunityDetailsHeaderModel?
    var data: [OpportunityDetailsModel] = []

    func fetchData() {
        let imageURLs = [
            URL(string: "https://images.unsplash.com/photo-1560493676-04071c5f467b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8d2luZXJ5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
            URL(string: "https://images.unsplash.com/photo-1593535388526-a6b8556c5351?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8d2luZXJ5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
            URL(string: "https://images.unsplash.com/photo-1504279577054-acfeccf8fc52?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8d2luZXJ5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
            URL(string: "https://images.unsplash.com/photo-1598306442928-4d90f32c6866?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8d2luZXJ5fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"),
            URL(string: "https://images.unsplash.com/photo-1519092796169-bb9cc75a4b68?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHdpbmVyeXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60"),
            URL(string: "https://images.unsplash.com/photo-1470158499416-75be9aa0c4db?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fHdpbmVyeXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60")
        ]

        self.images = imageURLs
        self.headerModel = OpportunityDetailsHeaderModel(title: "Help us at our hotel and experience the Greek Lifestyle in the island of Crete.", area: "Crete, Greece", category: .hotel)
        let location = OpportunityLocation(placemark: PlacemarkAttributes(name: "name1", country: "name2", area: "name3", locality: "name4", postalCode: "name5"), latitude: 38.0156839333148, longitude: 23.751797095407333)
        self.data = [
            OpportunityDetailsModel(title: "Type of help needed", description: "Reception, Bartending"),
            OpportunityDetailsModel(title: "Accomondation provided", description: "Private room"),
            OpportunityDetailsModel(title: "Meals provided", description: "Breakfast, Lunch"),
            OpportunityDetailsModel(title: "10", description: "30", dates: true),
            OpportunityDetailsModel(location: location)
        ]
    }

    func deleteOpportunity() {
        print("delete")
    }
}
