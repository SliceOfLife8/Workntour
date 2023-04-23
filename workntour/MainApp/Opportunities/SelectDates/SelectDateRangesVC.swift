//
//  SelectDateRangesVC.swift
//  workntour
//
//  Created by Chris Petimezas on 29/6/22.
//

import UIKit
import HorizonCalendar
import SharedKit

class SelectDateRangesVC: BaseVC<EmptyViewModel, OpportunitiesCoordinator> {
    public private(set) var dataModel: DataModel

    private enum CalendarSelection {
        case singleDay(day: Day)
        case dayRange(range: DayRange)
    }

    private var calendarSelection: CalendarSelection?

    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(initialContent: makeContent())
        return calendar
    }()

    required init(dataModel: DataModel) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            guard !self.isDayBooked(day) else { return }

            switch self.calendarSelection {
            case .singleDay(let selectedDay):
                if day > selectedDay {
                    guard self.selectedDayRangeIsValid(selectedDay...day) else { return }
                    print("day: \(selectedDay) -- \(day)")
                    self.calendarSelection = .dayRange(range: selectedDay...day)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                } else {
                    self.calendarSelection = .singleDay(day: day)
                }
            case .none, .dayRange:
                self.calendarSelection = .singleDay(day: day)
            }

            self.calendarView.setContent(self.makeContent())

            if UIAccessibility.isVoiceOverRunning,
               let selectedDate = Calendar.current.date(from: day.components) {
                self.calendarView.layoutIfNeeded()
                let accessibilityElementToFocus = self.calendarView.accessibilityElementForVisibleDate(
                    selectedDate)
                UIAccessibility.post(notification: .screenChanged, argument: accessibilityElementToFocus)
            }
        }
    }

    override func setupUI() {
        super.setupUI()

        let addIcon = UIBarButtonItem(
            title: "navigation_item_add".localized(),
            style: .plain,
            target: self,
            action: #selector(addDatesAction)
        )
        navigationItem.rightBarButtonItems = [addIcon]
        navigationItem.rightBarButtonItem?.isEnabled = false
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Select Dates"
    }

    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current

        let startDate = calendar.date(byAdding: .day, value: 1, to: Date())! // tomorrow
        let endDate = calendar.date(byAdding: .year, value: 2, to: Date())! // after 2 years

        let calendarSelection = self.calendarSelection
        let dateRanges: Set<ClosedRange<Date>>
        if case .dayRange(let dayRange) = calendarSelection,
           let lowerBound = calendar.date(from: dayRange.lowerBound.components),
           let upperBound = calendar.date(from: dayRange.upperBound.components) {
            dateRanges = [lowerBound...upperBound]
        } else {
            dateRanges = []
        }

        let verticalOptions = VerticalMonthsLayoutOptions(alwaysShowCompleteBoundaryMonths: false)

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: verticalOptions))
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)

        .dayItemProvider { day in
            var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

            invariantViewProperties.font = UIFont.scriptFont(.bold, size: 16)
            invariantViewProperties.interaction = .enabled(playsHapticsOnTouchDown: true, supportsPointerInteraction: true)

            let isSelectedStyle: Bool
            switch calendarSelection {
            case .singleDay(let selectedDay):
                isSelectedStyle = day == selectedDay
            case .dayRange(let selectedDayRange):
                isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
            case .none:
                isSelectedStyle = false
            }

            if self.isDayBooked(day) {
                invariantViewProperties.interaction = .disabled
                invariantViewProperties.shape = .rectangle(cornerRadius: 8)
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = UIColor.gray.withAlphaComponent(0.2)
                invariantViewProperties.textColor = UIColor.systemGray2
            }
            else if isSelectedStyle {
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = UIColor.appColor(.lavender)
            }

            return CalendarItemModel<DayView>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(
                    dayText: "\(day.day)",
                    accessibilityLabel: nil,
                    accessibilityHint: nil))
        }

        .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
            CalendarItemModel<DayRangeIndicatorView>(
                invariantViewProperties: .init(),
                viewModel: .init(
                    framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
        }
    }

    private func isDayBooked(_ day: Day) -> Bool {
        let calendar = Calendar.current
        guard let date = calendar.date(from: day.components)
        else {
            return false
        }

        let calendarDate = dataModel.preselectedDates.first { preselectDate -> Bool in
            (preselectDate.start...preselectDate.end).contains(date)
        }

        return calendarDate != nil
    }

    private func selectedDayRangeIsValid(_ range: DayRange) -> Bool {
        let calendar = Calendar.current
        guard let lowerDate = calendar.date(from: range.lowerBound.components),
              let upperDate = calendar.date(from: range.upperBound.components)
        else {
            return true
        }

        if let selectedDatesRange = dataModel.preselectedDates.first(where: { preselectDate -> Bool in
            return lowerDate <= preselectDate.end && upperDate >= preselectDate.start
        }) {
            return false
        }

        return true
    }

    @objc private func addDatesAction() {
        if case let .dayRange(days) = calendarSelection,
           let startDate = days.lowerBound.description.asDate(),
           let endDate = days.upperBound.description.asDate()
        {
            self.coordinator?.navigate(to: .saveDateRangeSelection(from: startDate, to: endDate))
            if let homeCoordinator = otherCoordinator as? HomeCoordinator {
                homeCoordinator.navigate(
                    to: .saveDateRangeSelection(
                        from: days.lowerBound.description,
                        to: days.upperBound.description
                    )
                )
            }
        } else {
            assertionFailure()
        }
    }
}

// MARK: - DataModel
extension SelectDateRangesVC {

    class DataModel {

        // MARK: - Properties

        let preselectedDates: [CalendarDate]

        // MARK: - Constructors/Destructors

        init(preselectedDates: [CalendarDate]) {
            self.preselectedDates = preselectedDates
        }
    }
}
