//
//  FindAvailableDatesVC.swift
//  workntour
//
//  Created by Chris Petimezas on 19/7/22.
//

import UIKit
import HorizonCalendar
import SharedKit
import SwiftUI

class FindAvailableDatesVC: BaseVC<EmptyViewModel, HomeCoordinator> {
    private(set) var startDate: Date
    private(set) var endDate: Date

    private enum CalendarSelection {
        case singleDay(day: Day)
        case dayRange(range: DayRange)
    }

    private var calendarSelection: CalendarSelection?

    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(initialContent: makeContent())
        return calendar
    }()

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            // Continue only if day is available
            guard self.isDayAvailable(day) else {
                return
            }

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

        let selectIcon = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(addDatesAction))
        navigationItem.rightBarButtonItems = [selectIcon]
        navigationItem.rightBarButtonItem?.isEnabled = false
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Select available dates"
        navigationItem.largeTitleDisplayMode = .never
    }

    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current

        let startDate = Date()
        let endDate = calendar.date(byAdding: .year, value: 2, to: Date())!

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

            if !self.isDayAvailable(day) {
                invariantViewProperties.interaction = .disabled
                invariantViewProperties.shape = .rectangle(cornerRadius: 8)
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = UIColor.gray.withAlphaComponent(0.2)
                invariantViewProperties.textColor = UIColor.systemGray2
            } else if isSelectedStyle {
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

    private func isDayAvailable(_ day: Day) -> Bool {
        let calendar = Calendar.current
        guard let date = calendar.date(from: day.components) else { // convert Day to Date
            return false
        }

        if (startDate...endDate).contains(date) {
            return true
        }
        return false
    }

    @objc private func addDatesAction() {
        if case let .dayRange(days) = calendarSelection {
            let startDate = days.lowerBound.description
            let endDate = days.upperBound.description

            AlertHelper.showDefaultAlert(self, title: "Selected dates", message: "Traveler has selected the following dates\nStarts: \(startDate)\nEnds: \(endDate)")
        } else {
            assertionFailure()
        }
    }
}
