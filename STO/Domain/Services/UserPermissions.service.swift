//
//  UserPermissions.service.swift
//  STO
//
//  Created by Taras Spasibov on 20.06.2022.
//

import Foundation
import UserNotifications

enum Permission {
    case pushNotifications
}

extension Permission {
    enum Status: Equatable {
        case unknown
        case notRequested
        case granted
        case denied
    }
}

protocol UserPermissionsService: AnyObject {
    func resolveStatus(for permission: Permission)
    func request(permission: Permission)
}


final class DefaultUserPermissionsService: UserPermissionsService {
    
    private let appState: Store<AppState>
    private let openAppSettings: () -> Void
    
    init(appState: Store<AppState>, openAppSettings: @escaping () -> Void) {
        self.appState = appState
        self.openAppSettings = openAppSettings
    }
    
    func resolveStatus(for permission: Permission) {
        let keyPath = AppState.permissionKeyPath(for: permission)
        let currentStatus = appState[keyPath]
        guard currentStatus == .unknown else { return }
        
        switch permission {
        case .pushNotifications:
            pushNotificationsPermissionStatus(keyPath: keyPath)
        }
    }
    
    func request(permission: Permission) {
        let keyPath = AppState.permissionKeyPath(for: permission)
        let currentStatus = appState[keyPath]
        guard currentStatus != .denied else {
            openAppSettings()
            return
        }
        switch permission {
        case .pushNotifications:
            requestPushNotificationsPermission(keyPath: keyPath)
        }
    }
}

extension UNAuthorizationStatus {
    var map: Permission.Status {
        switch self {
        case .denied: return .denied
        case .authorized: return .granted
        case .notDetermined, .provisional, .ephemeral: return .notRequested
        @unknown default: return .notRequested
        }
    }
}

extension DefaultUserPermissionsService {
    func pushNotificationsPermissionStatus(keyPath: WritableKeyPath<AppState, Permission.Status>) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.appState[keyPath] = settings.authorizationStatus.map
            }
        }
    }
    
    func requestPushNotificationsPermission(keyPath: WritableKeyPath<AppState, Permission.Status>) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { isGranted, error in
            DispatchQueue.main.async {
                self.appState[keyPath] = isGranted ? .granted : .denied
            }
        }
    }
}
