//
//  AppState.swift
//  STO
//
//  Created by Taras Spasibov on 20.06.2022.
//

import Foundation

struct AppState: Equatable {
    var routing = ViewRouting()
    var permissions = Permissions()
}

extension AppState {
    struct ViewRouting: Equatable {
        var launchFlow = LaunchView.Routing()
        var mainFlow = MainView.Routing()
    }
}

extension AppState {
    struct Permissions: Equatable {
        var push: Permission.Status = .unknown
    }
    
    static func permissionKeyPath(for permission: Permission) -> WritableKeyPath<AppState, Permission.Status> {
        let pathToPermissions = \AppState.permissions
        switch permission {
        case .pushNotifications:
            return pathToPermissions.appending(path: \.push)
        }
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.permissions == rhs.permissions && lhs.routing == rhs.routing
}
