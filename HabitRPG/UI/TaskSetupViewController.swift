//
//  TaskSetupViewController.swift
//  Habitica
//
//  Created by Phillip on 01.08.17.
//  Copyright © 2017 Phillip Thelen. All rights reserved.
//

import UIKit

enum SetupTaskCategory {
    case work, exercise, health, school, selfcare, chores, creativity

    //siwftlint:disable:next identifier_name
    func createSampleHabit(_ text: String, up: Bool, down: Bool) -> [String: Any] {
        return [
            "text": text,
            "up": up,
            "down": down,
            "type": "habit"
        ]
    }
    
    func createSampleDaily(_ text: String, notes: String) -> [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return [
            "text": text,
            "notes": notes,
            "startDate": dateFormatter.string(from: Date()),
            "monday": true,
            "tuesday": true,
            "wednesday": true,
            "thursday": true,
            "friday": true,
            "saturday": true,
            "sunday": true,
            "type": "daily"
        ]
    }
    
    func createSampleToDo(_ text: String, notes: String) -> [String: Any] {
        return [
            "text": text,
            "type": "todo",
            "notes": notes
        ]
    }
    
    func getTasks() -> [[String:Any]] {
        switch self {
        case .work:
            return [
                createSampleHabit(NSLocalizedString("Process email", comment: ""), up: true, down: false),
                createSampleDaily(NSLocalizedString("Worked on today’s most important task", comment: ""), notes: NSLocalizedString("Tap to specify your most important task", comment: "")),
                createSampleToDo(NSLocalizedString("Complete work project", comment: ""), notes: NSLocalizedString("Tap to specify the name of your current project + set a due date!", comment: ""))
            ]
        case .exercise:
            return [
                createSampleHabit(NSLocalizedString("10 min cardio", comment: ""), up: true, down: false),
                createSampleDaily(NSLocalizedString("Daily workout routine", comment: ""), notes: NSLocalizedString("Tap to choose your schedule and specify exercises!", comment: "")),
                createSampleToDo(NSLocalizedString("Set up workout schedule", comment: ""), notes: NSLocalizedString("Tap to add a checklist!", comment: ""))
            ]
        case .health:
            return [
                createSampleHabit(NSLocalizedString("Eat health/junk food", comment: ""), up: true, down: true),
                createSampleDaily(NSLocalizedString("Floss", comment: ""), notes: NSLocalizedString("Tap to make any changes!", comment: "")),
                createSampleToDo(NSLocalizedString("Schedule check-up", comment: ""), notes: NSLocalizedString("Tap to add checklists!", comment: ""))
            ]
        case .school:
            return [
                createSampleHabit(NSLocalizedString("Study/Procrastinate", comment: ""), up: true, down: true),
                createSampleDaily(NSLocalizedString("Do homework", comment: ""), notes: NSLocalizedString("Tap to specify your most important task", comment: "")),
                createSampleToDo(NSLocalizedString("Finish assignment for class", comment: ""), notes: NSLocalizedString("Tap to specify your most important task", comment: ""))
            ]
        case .selfcare:
            return [
                createSampleHabit(NSLocalizedString("Take a short break", comment: ""), up: true, down: false),
                createSampleDaily(NSLocalizedString("5 minutes of quiet breathing", comment: ""), notes: NSLocalizedString("Tap to choose your schedule!", comment: "")),
                createSampleToDo(NSLocalizedString("Engage in a fun activity", comment: ""), notes: NSLocalizedString("Tap to specify what you plan to do!", comment: ""))
            ]
        case .chores:
            return [
                createSampleHabit(NSLocalizedString("10 minutes cleaning", comment: ""), up: true, down: false),
                createSampleDaily(NSLocalizedString("Wash dishes", comment: ""), notes: NSLocalizedString("Tap to choose your schedule!", comment: "")),
                createSampleToDo(NSLocalizedString("Organize clutter", comment: ""), notes: NSLocalizedString("Tap to specify the cluttered area!", comment: ""))
            ]
        case .creativity:
            return [
                createSampleHabit(NSLocalizedString("Study a master of the craft", comment: ""), up: true, down: false),
                createSampleDaily(NSLocalizedString("Work on creative project", comment: ""), notes: NSLocalizedString("Tap to specify the name of your current project + set the schedule!", comment: "")),
                createSampleToDo(NSLocalizedString("Finish creative project", comment: ""), notes: NSLocalizedString("Tap to specify the name of your project", comment: ""))
            ]
        }
    }
}

class TaskSetupViewController: UIViewController, TypingTextViewController {
    
    @IBOutlet weak var avatarView: UIView!

    @IBOutlet weak var workCategoryButton: UIButton!
    @IBOutlet weak var exerciseCategoryButton: UIButton!
    @IBOutlet weak var healthCategoryButton: UIButton!
    @IBOutlet weak var schoolCategoryButton: UIButton!
    @IBOutlet weak var teamCategoryButton: UIButton!
    @IBOutlet weak var choresCategoryButtton: UIButton!
    @IBOutlet weak var creativityCategoryButton: UIButton!
    @IBOutlet weak var speechBubbleView: SpeechbubbleView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    let buttonBackground = #imageLiteral(resourceName: "DiamondButton").resizableImage(withCapInsets: UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15)).withRenderingMode(.alwaysTemplate)
    
    var sharedManager: HRPGManager?
    var user: User?
    
    public var selectedCategories: [SetupTaskCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? HRPGAppDelegate {
            sharedManager = delegate.sharedManager
            user = sharedManager?.getUser()
            user?.setAvatarSubview(avatarView, showsBackground: false, showsMount: false, showsPet: false)
        }
        initButtons()
    
        if self.view.frame.size.height <= 568 {
            containerHeight.constant = 205
        }
    }
    
    func initButtons() {
        workCategoryButton.setBackgroundImage(buttonBackground, for: .normal)
        exerciseCategoryButton.setBackgroundImage(buttonBackground, for: .normal)
        healthCategoryButton.setBackgroundImage(buttonBackground, for: .normal)
        schoolCategoryButton.setBackgroundImage(buttonBackground, for: .normal)
        teamCategoryButton.setBackgroundImage(buttonBackground, for: .normal)
        choresCategoryButtton.setBackgroundImage(buttonBackground, for: .normal)
        creativityCategoryButton.setBackgroundImage(buttonBackground, for: .normal)
        
        workCategoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButton(_:))))
        exerciseCategoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButton(_:))))
        healthCategoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButton(_:))))
        schoolCategoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButton(_:))))
        teamCategoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButton(_:))))
        choresCategoryButtton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButton(_:))))
        creativityCategoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButton(_:))))
        
        updateButtonBackgrounds()
    }
    
    func toggleButton(_ sender: UIGestureRecognizer) {
        var category: SetupTaskCategory?
        if let button = sender.view as? UIButton {
            switch button {
            case workCategoryButton:
                category = .work
                break
            case exerciseCategoryButton:
                category = .exercise
                break
            case healthCategoryButton:
                category = .health
                break
            case schoolCategoryButton:
                category = .school
                break
            case teamCategoryButton:
                category = .selfcare
                break
            case choresCategoryButtton:
                category = .chores
                break
            case creativityCategoryButton:
                category = .creativity
                break
            default:
                category = nil
            }
        }
        if let selectedCategory = category {
            if selectedCategories.contains(selectedCategory) {
                if let index = selectedCategories.index(of: selectedCategory) {
                    selectedCategories.remove(at: index)
                }
            } else {
                selectedCategories.append(selectedCategory)
            }
        }
        updateButtonBackgrounds()
    }
    
    func updateButtonBackgrounds() {
        updateButton(workCategoryButton)
        updateButton(exerciseCategoryButton)
        updateButton(healthCategoryButton)
        updateButton(schoolCategoryButton)
        updateButton(teamCategoryButton)
        updateButton(choresCategoryButtton)
        updateButton(creativityCategoryButton)
    }
    
    func updateButton(_ button: UIButton) {
        if isSelected(button) {
            button.tintColor = .white
            button.setTitleColor(UIColor.purple300(), for: .normal)
            button.setImage(#imageLiteral(resourceName: "checkmark_small"), for: .normal)
        } else {
            button.tintColor = UIColor.purple50()
            button.setTitleColor(.white, for: .normal)
            button.setImage(nil, for: .normal)
        }
    }
    
    func isSelected(_ button: UIButton) -> Bool {
        switch button {
        case workCategoryButton:
            return selectedCategories.contains(.work)
        case exerciseCategoryButton:
            return selectedCategories.contains(.exercise)
        case healthCategoryButton:
            return selectedCategories.contains(.health)
        case schoolCategoryButton:
            return selectedCategories.contains(.school)
        case teamCategoryButton:
            return selectedCategories.contains(.selfcare)
        case choresCategoryButtton:
            return selectedCategories.contains(.chores)
        case creativityCategoryButton:
            return selectedCategories.contains(.creativity)
        default:
            return false
        }
    }
    
    func startTyping() {
        speechBubbleView.animateTextView()
        user?.setAvatarSubview(avatarView, showsBackground: false, showsMount: false, showsPet: false)
    }
}
