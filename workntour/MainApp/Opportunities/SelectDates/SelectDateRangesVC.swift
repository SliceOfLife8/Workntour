//
//  SelectDateRangesVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 29/6/22.
//

import UIKit
import HorizonCalendar
import SharedKit

class SelectDateRangesVC: BaseVC<EmptyViewModel, OpportunitiesCoordinator> {

    private enum CalendarSelection {
        case singleDay(day: Day)
        case dayRange(range: DayRange)
    }

    private var calendarSelection: CalendarSelection?

    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(initialContent: makeContent())
        return calendar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            self.navigationItem.rightBarButtonItem?.isEnabled = false

            switch self.calendarSelection {
            case .singleDay(let selectedDay):
                if day > selectedDay {
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

        let addIcon = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addDatesAction))
        navigationItem.rightBarButtonItems = [addIcon]
        navigationItem.rightBarButtonItem?.isEnabled = false
        calendarView.addExclusiveConstraints(superview: view, top: (view.safeAreaLayoutGuide.topAnchor, 0), bottom: (view.bottomAnchor, 0), left: (view.leadingAnchor, 0), right: (view.trailingAnchor, 0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar(mainTitle: "Select Dates")
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

            if isSelectedStyle {
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

    @objc private func addDatesAction() {
        if case let .dayRange(days) = calendarSelection {
            let startDate = days.lowerBound.description
            let endDate = days.upperBound.description
            self.coordinator?.navigate(to: .saveDataRangeSelection(from: startDate, to: endDate))
        } else {
            assertionFailure()
        }
    }
}
