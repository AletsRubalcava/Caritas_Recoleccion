import Foundation

func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"

    guard let date = inputFormatter.date(from: dateString) else {
        return dateString
    }

    let outputFormatter = DateFormatter()
    outputFormatter.locale = Locale(identifier: "es_MX")
    outputFormatter.timeZone = TimeZone(identifier: "GMT")
    outputFormatter.dateFormat = "MMM dd yyyy"

    return outputFormatter.string(from: date).uppercased()
}

func apiString(fromGMT date: Date) -> String {
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(identifier: "GMT")
    f.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    return f.string(from: date)
}

func apiString(fromLocalDay date: Date) -> String {
    let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
    var gmt = Calendar(identifier: .gregorian)
    gmt.timeZone = TimeZone(identifier: "GMT")!
    return apiString(fromGMT: gmt.date(from: comps) ?? date)
}

func diaLocal(deGMT fecha: Date) -> Date {
    var gmt = Calendar(identifier: .gregorian)
    gmt.timeZone = TimeZone(identifier: "GMT")!
    let comps = gmt.dateComponents([.year, .month, .day], from: fecha)
    return Calendar.current.date(from: comps) ?? fecha
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

func apiDateOnly(fromLocalDay date: Date) -> String {
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.calendar = Calendar(identifier: .gregorian)
    f.timeZone = .current 
    f.dateFormat = "yyyy-MM-dd"
    return f.string(from: date)
}

func timeUntil(_ dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"

    guard let date = formatter.date(from: dateString) else {
        return dateString
    }

    // Día calendario tal como lo manda el backend (UTC)
    var utc = Calendar(identifier: .gregorian)
    utc.timeZone = TimeZone(secondsFromGMT: 0)!
    let c = utc.dateComponents([.year, .month, .day], from: date)

    // Ese mismo día calendario, pero en la zona local
    let local = Calendar.current
    guard let eventDay = local.date(from: c) else { return dateString }

    let today = local.startOfDay(for: Date())
    let days = local.dateComponents([.day], from: today, to: eventDay).day ?? 0

    switch days {
    case ..<(-1): return "cace \(-days) días"
    case -1:      return "ayer"
    case 0:       return "hoy"
    case 1:       return "en 1 día"
    case 2..<30:  return "en \(days) días"
    case 30..<365:
        let m = days / 30
        return "\(m) \(m == 1 ? "mes" : "meses")"
    default:
        let y = days / 365
        return "\(y) \(y == 1 ? "año" : "años")"
    }
}
