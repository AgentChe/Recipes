//
//  OCombineData.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

struct OCombineData {
    let goal: Int
    let categories: [Int]
    let diet: Int
    let pace: Int
    let time: Int
    let pushToken: String?
    let notificationsOptions: [Int]?
}

final class OnboardingCombineData {
    private var goal: OGoalButton.Goal?
    private var categories: [OCategoriesCollectionElement]?
    private var diet: Diet?
    private var pace: Int?
    private var time: OTimeButton.Time?
    private var pushToken: String?
    private var notificationsOptions: [ONotificationsSwitch.Notification]?
    
    func combineData() -> OCombineData? {
        guard
            let goal = goal,
            let categories = categories,
            let diet = diet,
            let pace = pace,
            let time = time
        else {
            return nil
        }

        return OCombineData(
            goal: goal.code,
            categories: categories.map { $0.id },
            diet: diet.id,
            pace: pace,
            time: time.code,
            pushToken: pushToken,
            notificationsOptions: notificationsOptions?.map { $0.code }
        )
    }
}

// MARK: OGoalViewDelegate
extension OnboardingCombineData: OGoalViewDelegate {
    func goalViewDidSelected(goal: OGoalButton.Goal) {
        self.goal = goal
    }
}

// MARK: OCategoriesViewDelegate
extension OnboardingCombineData: OCategoriesViewDelegate {
    func categoriesViewDidSelected(elements: [OCategoriesCollectionElement]) {
        self.categories = elements
    }
}

// MARK: OPaceViewDelegate
extension OnboardingCombineData: OPaceViewDelegate {
    func paceViewDidSelected(pace: Int) {
        self.pace = pace
    }
}

// MARK: OTimeViewDelegate
extension OnboardingCombineData: OTimeViewDelegate {
    func timeViewDidSelected(time: OTimeButton.Time) {
        self.time = time
    }
}

// MARK: ONotificationsViewDelegate
extension OnboardingCombineData: ONotificationsViewDelegate {
    func notificationsViewDidRegistered(pushToken: String?, options: [ONotificationsSwitch.Notification]) {
        self.pushToken = pushToken
        self.notificationsOptions = options
    }
}
