//
//  CreateOpportunityViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 27/6/22.
//

import UIKit
import Combine
import Kingfisher

class CreateOpportunityViewModel: BaseViewModel {
    // Services
    private var service: OpportunityService
    var NUM_OF_REQUIRED_FIELDS: Float = 11
    var dataModel: DataModel

    /// Inputs
    var category: OpportunityCategory? {
        didSet {
            updateProgressBar()
        }
    }
    var jobTitle: String = "" {
        didSet {
            updateProgressBar()
        }
    }
    var jobDescription: String?
    var typeOfHelp: [TypeOfHelp] = [] {
        didSet {
            updateProgressBar()
        }
    }
    @Published var location: OpportunityLocation? {
        didSet {
            updateProgressBar()
        }
    }
    @Published var dates: [OpportunityDates] = [] {
        didSet {
            updateProgressBar()
        }
    }
    @Published var workingDays: OpportunitySelectDates? {
        didSet {
            updateProgressBar()
        }
    }
    var languagesRequired: [Language] = [] {
        didSet {
            updateProgressBar()
        }
    }
    var accommodation: Accommodation? {
        didSet {
            updateProgressBar()
        }
    }
    var meals: [Meal] = [] {
        didSet {
            updateProgressBar()
        }
    }
    var learningOpportunities: [LearningOpportunities] = [] {
        didSet {
            updateProgressBar()
        }
    }
    var additonalOfferings: OpportunityOptionals?
    @Published var images: [UIImage] = [] {
        didSet {
            updateProgressBar()
        }
    }

    /// Outputs
    @Published var progress: Float = 0
    @Published var validData: Bool?
    @Published var opportunityCreated: Bool = false
    @Published var opportunityUpdated: Bool = false
    @Published var opportunityDeleted: Bool = false

    @Published var opportunityModel: OpportunityDto?

    // MARK: - Constructors/Destructors

    init(
        dataModel: DataModel,
        service: OpportunityService = DataManager.shared
    ) {
        self.service = service
        self.dataModel = dataModel
        var imagesUrls: [URL] = []
        if case .edit(let opportunityDto) = dataModel.mode {
            self.opportunityModel = opportunityDto
            self.category = opportunityDto.category
            self.jobTitle = opportunityDto.title
            self.jobDescription = opportunityDto.description
            self.typeOfHelp = opportunityDto.typeOfHelp
            imagesUrls = opportunityDto.imageUrls
                .compactMap { URL(string: $0) }
            self.location = opportunityDto.location
            self.dates = opportunityDto.dates
            self.workingDays = OpportunitySelectDates(opportunity: opportunityDto)
            self.languagesRequired = opportunityDto.languagesRequired
            self.accommodation = opportunityDto.accommodation
            self.meals = opportunityDto.meals
            self.learningOpportunities = opportunityDto.learningOpportunities
            self.additonalOfferings = opportunityDto.optionals
        }
        super.init()
        defer { updateProgressBar() }
        imagesUrls.forEach {
            ImageDownloader.default.downloadImage(with: $0) { result in
                switch result {
                case .success(let imageResult):
                    self.images.append(imageResult.image)
                default: break
                }
            }
        }
    }

    // swiftlint:disable cyclomatic_complexity
    /// 11 Required fields in order to activate `Create` button
    private func updateProgressBar() {
        var percent: Float = 0

        if category != nil { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if !jobTitle.isEmpty { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if images.count > 0 { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if typeOfHelp.count > 0 { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if location != nil { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if dates.count > 0 { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if workingDays != nil { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if languagesRequired.count > 0 { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if accommodation != nil { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if meals.count > 0 { percent += 1/NUM_OF_REQUIRED_FIELDS }
        if learningOpportunities.count > 0 { percent += 1/NUM_OF_REQUIRED_FIELDS }

        progress = percent
    }

    /// We should validate all required data here. This func should be called when `Create button` is `enabled`.
    func validateData() {
        guard let category,
              let location,
              let accommodation,
              let workingDays
        else {
            validData = false
            return
        }

        opportunityModel = OpportunityDto(
            memberId: UserDataManager.shared.memberId,
            category: category,
            images: images.compactMap { $0.jpeg(.medium) },
            imagesUrl: [],
            title: jobTitle,
            description: jobDescription,
            typeOfHelp: typeOfHelp,
            location: location,
            dates: dates,
            minDays: workingDays.minimumDays,
            maxDays: workingDays.maximumDays,
            workingHours: workingDays.maxWorkingHours,
            daysOff: workingDays.daysOff,
            languagesRequired: languagesRequired,
            accommodation: accommodation,
            meals: meals,
            learningOpportunities: learningOpportunities,
            optionals: additonalOfferings
        )

        validData = true
    }

    func createOpportunity() {
        guard let model = opportunityModel else {
            return
        }

        loaderVisibility = true
        service.createOpportunity(model)
            .subscribe(on: RunLoop.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$opportunityCreated)
    }

    func updateOpportunity() {
        print("update opportunity!")
    }

    func deleteOpportunity() {
        guard let id = opportunityModel?.opportunityId else { return }

        loaderVisibility = true
        service.deleteOpportunity(byId: id)
            .subscribe(on: RunLoop.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$opportunityDeleted)
    }
}

// MARK: - DataModel
extension CreateOpportunityViewModel {

    class DataModel {

        enum Mode {
            case create
            case edit(OpportunityDto)
        }

        // MARK: - Properties

        let mode: Mode

        // MARK: - Constructors/Destructors

        init(mode: Mode) {
            self.mode = mode
        }
    }
}
