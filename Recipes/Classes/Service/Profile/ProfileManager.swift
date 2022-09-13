//
//  ProfileManager.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import RxSwift

protocol ProfileManagerProtocol {
    func set(goal: Int,
             categories: [Int],
             diet: Int,
             pace: Int,
             time: Int,
             pushToken: String?,
             notificationsOptions: [Int]?) -> Single<Void>
    func syncTokens(oldToken: String, newToken: String) -> Single<Void>
    func login(userToken: String) -> Single<Void>
    func set(textSize: TextSize) -> Single<Void>
    func obtainTextSize() -> Single<TextSize>
}

final class ProfileManager: ProfileManagerProtocol {
    enum Constants {
        static let textSizeKey = "profile_manager_text_size_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension ProfileManager {
    func set(goal: Int,
             categories: [Int],
             diet: Int,
             pace: Int,
             time: Int,
             pushToken: String?,
             notificationsOptions: [Int]?) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SetRequest(userToken: userToken,
                                 goal: goal,
                                 categories: categories,
                                 diet: diet,
                                 pace: pace,
                                 time: time,
                                 pushToken: pushToken,
                                 notificationsOptions: notificationsOptions)
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func syncTokens(oldToken: String, newToken: String) -> Single<Void> {
        let request = SyncTokensRequest(oldToken: oldToken,
                                        newToken: newToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func login(userToken: String) -> Single<Void> {
        let request = LoginRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func set(textSize: TextSize) -> Single<Void> {
        Single<Void>.create { event in
            if let data = try? JSONEncoder().encode(textSize) {
                UserDefaults.standard.set(data, forKey: Constants.textSizeKey)
            }
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func obtainTextSize() -> Single<TextSize> {
        Single<TextSize>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.textSizeKey),
                    let textSize = try? JSONDecoder().decode(TextSize.self, from: data)
                else {
                    let defaultTextSize = TextSize(percent: 100)
                    event(.success(defaultTextSize))
                    
                    return Disposables.create()
                }
                
                event(.success(textSize))
                
                return Disposables.create()
            }
    }
}
