//
//  StepsViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import RxSwift
import RxCocoa

final class StepsViewModel {
    let selectStep: BehaviorRelay<RecipeStep>
    
    lazy var elements = makeElements()
    
    private let steps: BehaviorRelay<[RecipeStep]>
    
    init(steps: [RecipeStep], selectedStep: RecipeStep) {
        self.steps = BehaviorRelay(value: steps)
        self.selectStep = BehaviorRelay(value: selectedStep)
    }
}

// MARK: Private
private extension StepsViewModel {
    func makeElements() -> Driver<[StepsTableElement]> {
        Driver
            .combineLatest(
                steps.asDriver(),
                selectStep.asDriver()
            )
            .map { steps, selectedStep -> [StepsTableElement] in
                var result = [StepsTableElement]()
                
                for (index, step) in steps.enumerated() {
                    let isLast = (steps.count - 1) == index
                    
                    let element = StepTableElement(number: String(index + 1),
                                                   step: step,
                                                   isSelected: step == selectedStep,
                                                   separatorHidden: isLast)
                    result.append(.step(element))
                    
                    if !isLast {
                        result.append(.offset)
                    }
                }
                
                return result
            }
    }
}
