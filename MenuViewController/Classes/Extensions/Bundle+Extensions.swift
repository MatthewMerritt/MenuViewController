//
//  Bundle+Extensions.swift
//  Exercise
//
//  Created by Matthew Merritt on 3/30/20.
//  Copyright © 2020 Matthew Merritt. All rights reserved.
//

import Foundation

public extension Bundle {

    /// A String containing the CFBundleShortVersionString from info.plist
    private var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// A String containing the CFBundleVersion from info.plist
    private var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    /// A String containing the CFBundleIdentifier from the Main Bundle
    var bundleID: String {
        return Bundle.main.bundleIdentifier?.lowercased() ?? ""
    }

    /// A String conting a short description of the Version of this App
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

    /// A String containing the CFBundleDisplayName from info.plist
    var displayName: String {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }

}
