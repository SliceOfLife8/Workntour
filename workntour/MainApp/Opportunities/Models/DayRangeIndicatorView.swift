//
//  DayRangeIndicatorView.swift
//  workntour
//
//  Created by Chris Petimezas on 29/6/22.
//

import HorizonCalendar
import UIKit
import SharedKit

// MARK: - DayRangeIndicatorView
final class DayRangeIndicatorView: UIView {

    // MARK: Lifecycle
    init(indicatorColor: UIColor) {
        self.indicatorColor = indicatorColor
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal
    var framesOfDaysToHighlight = [CGRect]() {
        didSet {
            guard framesOfDaysToHighlight != oldValue else { return }
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(indicatorColor.cgColor)

        if traitCollection.layoutDirection == .rightToLeft {
            transform = .init(scaleX: -1, y: 1)
        } else {
            transform = .identity
        }

        // Get frames of day rows in the range
        var dayRowFrames = [CGRect]()
        var currentDayRowMinY: CGFloat?
        for dayFrame in framesOfDaysToHighlight {
            if dayFrame.minY != currentDayRowMinY {
                currentDayRowMinY = dayFrame.minY
                dayRowFrames.append(dayFrame)
            } else {
                let lastIndex = dayRowFrames.count - 1
                dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
            }
        }

        // Draw rounded rectangles for each day row
        for dayRowFrame in dayRowFrames {
            let cornerRadius = dayRowFrame.height / 2
            let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: cornerRadius)
            context?.addPath(roundedRectanglePath.cgPath)
            context?.fillPath()
        }
    }

    // MARK: Private
    private let indicatorColor: UIColor

}

// MARK: CalendarItemViewRepresentable
extension DayRangeIndicatorView: CalendarItemViewRepresentable {

    struct InvariantViewProperties: Hashable {
        var indicatorColor = UIColor.appColor(.calendar)
    }

    struct ViewModel: Equatable {
        let framesOfDaysToHighlight: [CGRect]
    }

    static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayRangeIndicatorView {
        DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
    }

    static func setViewModel(_ viewModel: ViewModel, on view: DayRangeIndicatorView) {
        view.framesOfDaysToHighlight = viewModel.framesOfDaysToHighlight
    }

}
