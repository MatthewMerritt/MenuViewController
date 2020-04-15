//
//  Bundle+Extensions.swift
//  Exercise
//
//  Created by Matthew Merritt on 3/30/20.
//  Copyright © 2020 Matthew Merritt. All rights reserved.
//

import Foundation

public extension Bundle {
    private var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    private var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    var bundleID: String {
        return Bundle.main.bundleIdentifier?.lowercased() ?? ""
    }

    var versionString: String {
        var scheme = ""

        // If you use different bundle IDs for different environments, code like this is helpful:
        if bundleID.contains(".dev") {
            scheme = "Dev"
        } else if bundleID.contains(".staging") {
            scheme = "Staging"
        }

        let returnValue = "Version \(releaseVersionNumber).\(buildVersionNumber) \(scheme)"

        return returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var displayName: String {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }

}
