import Foundation

func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.dateFormat = "EEE, dd MMM yyy HH:mm:ss zzz"
    
    guard let date = inputFormatter.date(from: dateString) else {
        return dateString
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.locale = Locale(identifier: "es_MEX_POSIX")
    outputFormatter.dateFormat = "MMM dd yyyy"
    
    return outputFormatter.string(from: date).uppercased()
}

func timeAgo(_ dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"

    guard let date = formatter.date(from: dateString) else {
        return dateString
    }

    let calendar = Calendar.current
    let now = Date()

    let components = calendar.dateComponents(
        [.year, .month, .day],
        from: date,
        to: now
    )

    if let years = components.year, years > 0 {
        return "Hace \(years) \(years == 1 ? "año" : "años")"
    }

    if let months = components.month, months > 0 {
        return "Hace \(months) \(months == 1 ? "mes" : "meses")"
    }

    if let days = components.day, days > 0 {
        return "Hace \(days) \(days == 1 ? "día" : "días")"
    }

    return "Hoy"
}
