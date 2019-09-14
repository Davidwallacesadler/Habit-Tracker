//
//  HabitCreationTableViewController.swift
//  Habit Tracker
//
//  Created by David Sadler on 9/3/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class HabitCreationTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - TextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - PickerView DataSource & Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyIntegers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = NSAttributedString(string: frequencyIntegers[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frequency = row + 1
    }
    
    // MARK: - CollectionView DataSource & Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "imageCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.mainImageView?.image = iconCollection[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = iconCollection[indexPath.row]
        photoButtonImageView.image = selectedImage
        iconOrPhoto = selectedImage
    }
    
    // MARK: - Properties
    
    var iconNames = [Keys.writingIcon, Keys.weightLiftingIcon, Keys.readingIcon, Keys.computerGamesIcon, Keys.creativeWorkIcon]
    var iconCollection: [UIImage] {
        get {
            var images = [UIImage]()
            for name in iconNames {
                guard let icon = UIImage.init(named: name) else { return [] }
                images.append(icon)
            }
             return images
        }
    }
    var habitQualifier: Bool = true
    var frequency: Int = 1
    var habit: Habit?
    var colorId: Int? {
        didSet {
            updateButtons()
        }
    }
    var frequencyIntegers: [String] {
        get {
            var strInts = [String]()
            for i in 1...100 {
                strInts.append("\(i)")
            }
            return strInts
        }
    }
    var iconOrPhoto: UIImage?
    var unit: String = "Times"
    var currentlySelectedButtonId: Int?
    let roundingCoeff = 5.0
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTextViews()
        setupPickerViews()
        registerCustomCells()
        resignFirstResponderTapRecongnizerSetup()
        updateHabitValues()
        updateViews()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var positiveOrNegativeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var frequencyPickerView: UIPickerView!
    @IBOutlet weak var frequencyTimesADayLabel: UILabel!
    @IBOutlet weak var habitIntentionTextView: UITextView!
    @IBOutlet weak var photoButtonImageView: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var redButton: SelectableRoundedCornerButton!
    @IBOutlet weak var redOrangeButton: SelectableRoundedCornerButton!
    @IBOutlet weak var yellowOrangeButton: SelectableRoundedCornerButton!
    @IBOutlet weak var yellowButton: SelectableRoundedCornerButton!
    @IBOutlet weak var yellowGreenButton: SelectableRoundedCornerButton!
    @IBOutlet weak var greenButton: SelectableRoundedCornerButton!
    @IBOutlet weak var tealButton: SelectableRoundedCornerButton!
    @IBOutlet weak var lightBlueButton: SelectableRoundedCornerButton!
    @IBOutlet weak var darkBlueButton: SelectableRoundedCornerButton!
    @IBOutlet weak var blueVioletButton: SelectableRoundedCornerButton!
    @IBOutlet weak var redVioletButton: SelectableRoundedCornerButton!
    @IBOutlet weak var pinkButton: SelectableRoundedCornerButton!
    
    
    
    private func setupCollectionView() {
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
    }
    
    private func setupTextViews() {
        habitNameTextField.delegate = self
        habitIntentionTextView.delegate = self
        unitTextField.delegate = self
    }
    
    private func setupPickerViews() {
        frequencyPickerView.delegate = self
        frequencyPickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    private func updateViews() {
        guard let selectedHabit = habit else { return }
        habitNameTextField.text = selectedHabit.name!
        if selectedHabit.isNegativeHabit {
            positiveOrNegativeSegmentedControl.selectedSegmentIndex = 0
        } else {
            positiveOrNegativeSegmentedControl.selectedSegmentIndex = 1
        }
        frequencyPickerView.selectRow(Int(selectedHabit.desiredFrequency) - 1, inComponent: 0, animated: false)
        habitIntentionTextView.text = selectedHabit.userIntention
        photoButtonImageView.image = selectedHabit.photo
        if selectedHabit.desiredFrequency == 1 {
            unitTextField.text = selectedHabit.unitOfCount
        } else {
            let pluralUnit = selectedHabit.unitOfCount?.pluralize()
            unitTextField.text = pluralUnit
        }
    }
    
    private func updateHabitValues() {
        guard let selectedHabit = habit else { return }
        iconOrPhoto = selectedHabit.photo
        frequency = Int(selectedHabit.desiredFrequency)
        colorId = Int(selectedHabit.colorId)
        habitQualifier = selectedHabit.isNegativeHabit
    }
    
    private func registerCustomCells() {
        iconCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    private func resignFirstResponderTapRecongnizerSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    private func presentNoNameAlert() {
        let alertController = UIAlertController(title: "No Name Entered", message: "Please enter a habit name.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateButtons() {
        guard let selectedId = colorId else { return }
        if let buttonSelectedPrior = currentlySelectedButtonId {
            switch buttonSelectedPrior {
            case 1:
                redButton.currentlySelected = false
            case 2:
                redOrangeButton.currentlySelected = false
            case 3:
                yellowOrangeButton.currentlySelected = false
            case 4:
                yellowButton.currentlySelected = false
            case 5:
                yellowGreenButton.currentlySelected = false
            case 6:
                greenButton.currentlySelected = false
            case 7:
                tealButton.currentlySelected = false
            case 8:
                lightBlueButton.currentlySelected = false
            case 9:
                darkBlueButton.currentlySelected = false
            case 10:
                blueVioletButton.currentlySelected = false
            case 11:
                redVioletButton.currentlySelected = false
            case 12:
                pinkButton.currentlySelected = false
            default:
                return
            }
        }
        currentlySelectedButtonId = selectedId
        switch selectedId {
        case 1:
            redButton.currentlySelected = true
        case 2:
            redOrangeButton.currentlySelected = true
        case 3:
            yellowOrangeButton.currentlySelected = true
        case 4:
            yellowButton.currentlySelected = true
        case 5:
            yellowGreenButton.currentlySelected = true
        case 6:
            greenButton.currentlySelected = true
        case 7:
            tealButton.currentlySelected = true
        case 8:
            lightBlueButton.currentlySelected = true
        case 9:
            darkBlueButton.currentlySelected = true
        case 10:
            blueVioletButton.currentlySelected = true
        case 11:
            redVioletButton.currentlySelected = true
        case 12:
            pinkButton.currentlySelected = true
        default:
            return
        }
    }
    

    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = habitNameTextField.text, let habitIntention = habitIntentionTextView.text, let desiredPhoto = iconOrPhoto, let units = unitTextField.text, let color = colorId else { return }
        if name.isEmpty {
            presentNoNameAlert()
        } else {
            guard let selectedHabit = habit else {
                if units.isEmpty {
                    HabitController.shared.createHabit(name: name, userIntention: habitIntention, isNegativeHabit: habitQualifier, currentTimesDone: 0, image: desiredPhoto, colorID: color, habitDayInterval: 1, desiredHabitFrequency: frequency, unitOfCount: "Time")
                    self.navigationController?.popViewController(animated: true)
                    return
                } else {
                    var correctedUnitString = String()
                    if units.endsInAnEs() {
                        correctedUnitString = units.dePluralize()
                    } else if units.endsInAnS() && units.endsInAnSs() == false {
                        correctedUnitString = units.dePluralize()
                    }
                    // Want the standard for unit to be singlular not plural
                HabitController.shared.createHabit(name: name, userIntention: habitIntention, isNegativeHabit: habitQualifier, currentTimesDone: 0, image: desiredPhoto, colorID: color, habitDayInterval: 1, desiredHabitFrequency: frequency, unitOfCount: correctedUnitString)
                self.navigationController?.popViewController(animated: true)
                return
                }
            }
            HabitController.shared.updateHabit(newName: name, newIntention: habitIntention, newHabitQualifier: habitQualifier, newTimesDone: Int(selectedHabit.currentTimesDone), newImage: desiredPhoto, newColorID: color, newHabitDayInterval: 1, newHabitFrequency: frequency, habit: selectedHabit)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        habitQualifier = !habitQualifier
        print("The habit is negative : \(habitQualifier)")
    }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        colorId = 1
    }
    @IBAction func redOrangeButtonPressed(_ sender: Any) {
        colorId = 2
    }
    @IBAction func orangeButtonPressed(_ sender: Any) {
        colorId = 3
    }
    @IBAction func yellowButtonPressed(_ sender: Any) {
        colorId = 4
    }
    @IBAction func yellowGreenButtonPressed(_ sender: Any) {
        colorId = 5
    }
    @IBAction func greenButtonPressed(_ sender: Any) {
        colorId = 6
    }
    @IBAction func tealButtonPressed(_ sender: Any) {
        colorId = 7
    }
    @IBAction func lightBlueButtonPressed(_ sender: Any) {
        colorId = 8
    }
    @IBAction func darkBlueButonPressed(_ sender: Any) {
        colorId = 9
    }
    @IBAction func blueVioletButtonPressed(_ sender: Any) {
        colorId = 10
    }
    @IBAction func redVioletButtonPressed(_ sender: Any) {
        colorId = 11
    }
    @IBAction func pinkButtonPressed(_ sender: Any) {
        colorId = 12
    }
}
