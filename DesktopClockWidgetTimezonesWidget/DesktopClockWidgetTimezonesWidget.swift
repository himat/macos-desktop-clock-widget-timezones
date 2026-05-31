//
//  DesktopClockWidgetTimezonesWidget.swift
//  DesktopClockWidgetTimezonesWidget
//
//  Created by John Britton on 12/25/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        for minuteOffset in 0 ..< 5 {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DesktopClockWidgetTimezonesWidgetEntryView : View {
    var entry: Provider.Entry

    func timeString(date: Date, timeZone: TimeZone?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = timeZone
        let time = formatter.string(from: date)
        return time
    }

    var body: some View {
        VStack(spacing: 25) {
            VStack {
                Text("Local")
                    .font(.headline)
                Text("\(timeString(date: entry.date, timeZone: .autoupdatingCurrent))")
                    .font(.largeTitle)
            }

            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    VStack {
                        Text("San Francisco")
                            .font(.headline)
                        Text("\(timeString(date: entry.date, timeZone: TimeZone(identifier: "US/Pacific")))")
                            .font(.body)
                    }
                    VStack {
                        Text("NYC")
                            .font(.headline)
                        Text("\(timeString(date: entry.date, timeZone: TimeZone(identifier: "America/New_York")))")
                            .font(.body)
                    }
                    VStack {
                        Text("London")
                            .font(.headline)
                        Text("\(timeString(date: entry.date, timeZone: TimeZone(identifier: "Europe/London")))")
                            .font(.body)
                    }
                }

                HStack(spacing: 12) {
                    VStack {
                        Text("Hyderabad")
                            .font(.headline)
                        Text("\(timeString(date: entry.date, timeZone: TimeZone(identifier: "Asia/Kolkata")))")
                            .font(.body)
                    }
                    VStack {
                        Text("Beijing")
                            .font(.headline)
                        Text("\(timeString(date: entry.date, timeZone: TimeZone(identifier: "Asia/Shanghai")))")
                            .font(.body)
                    }
                    VStack {
                        Text("Tokyo")
                            .font(.headline)
                        Text("\(timeString(date: entry.date, timeZone: TimeZone(identifier: "Asia/Tokyo")))")
                            .font(.body)
                    }
                }
            }
        }
        .widgetContainerBackground()
    }
}

extension View {
    @ViewBuilder
    func widgetContainerBackground() -> some View {
        if #available(macOSApplicationExtension 14.0, *) {
            self.containerBackground(.fill.tertiary, for: .widget)
        } else {
            self
        }
    }
}

@main
struct DesktopClockWidgetTimezonesWidget: Widget {
    let kind: String = "DesktopClockWidgetTimezonesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DesktopClockWidgetTimezonesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DesktopClockWidgetTimezones")
        .description("Displays a digital clock.")
        .supportedFamilies([.systemMedium])
    }
}

struct DesktopClockWidgetTimezonesWidget_Previews: PreviewProvider {
    static var previews: some View {
        DesktopClockWidgetTimezonesWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
