//
//  FFHealthDataAccess.swift
//  FeelFit
//
//  Created by Константин Малков on 18.01.2024.
//

import HealthKit

///Class return app's status of access to users health data
class FFHealthDataAccess {
    
    static let shared = FFHealthDataAccess()
    
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    private let userCharactersTypes = Set(FFHealthData.charDataTypes)
    private let healthStore = HKHealthStore()
    
    ///boolean value necessary for check status of health store if it is available or not
    private var isHealthKitAccess: Bool = UserDefaults.standard.bool(forKey: "healthKitAccess")
    
    ///Function for request access to Health Kit. Inherit read and share types
    func requestForAccessToHealth(){
        var textStatus: String = ""
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) {[unowned self] success, error in
            if let error = error {
                textStatus = "Applications gets error by trying to get access to Health. \(error.localizedDescription)"
                print(textStatus)
            } else {
                if success {
                    requestAccessToBackgroundMode()
                    if self.isHealthKitAccess {
                        textStatus = "You already gave full access to Health request"
                    } else {
                        textStatus = "Health kit authorization complete successfully"
                        UserDefaults.standard.setValue(true, forKey: "healthKitAccess")
                    }
                } else {
                    textStatus = "Health kit authorization did not complete successfully"
                }
            }
        }
        print(textStatus)
    }
    
    
    /// Making request for getting access to main users data
    func requestAccessToCharactersData(){
        healthStore.requestAuthorization(toShare: nil, read: userCharactersTypes) { status, error in
            if status {
                print("FFHealthDataAccess.requestAccesstoCharData completed")
                let value = try! self.healthStore.biologicalSex()
                let userGender = GenderTypeResult(rawValue: value.biologicalSex.rawValue)
                print(userGender?.stringValue)
                print(try! self.healthStore.dateOfBirthComponents())
                print(try! self.healthStore.wheelchairUse())
                print(try! self.healthStore.bloodType())
                let blood = try! self.healthStore.bloodType()
                let bloodRawValue = blood.bloodType.rawValue
                let result = HKBloodType(rawValue: bloodRawValue)
                print(result!)
                print(try! self.healthStore.fitzpatrickSkinType())
            } else {
                print("FFHealthDataAccess.requestAccessToCharData error getting data. Check samples or try again")
                print(error!.localizedDescription)
            }
        }
    }
    
    enum GenderTypeResult: Int {
        case notDetected = 0
        case female = 1
        case male = 2
        
        var stringValue: String {
            switch self {
            case .notDetected: return "Not set"
            case .female: return "Female"
            case .male: return "Male"
            }
        }
    }
    
    ///Function check status authorization to Health Store and return exact boolean value of gets status
    func getHealthAuthorizationRequestStatus(){
        if !HKHealthStore.isHealthDataAvailable()  {
            print("Health Data is unavailable. Try again later")
            return
        }
        var textStatus: String = ""
        healthStore.getRequestStatusForAuthorization(toShare: shareTypes, read: readTypes) { authStatus, error in
            switch authStatus {
            case .unknown:
                UserDefaults.standard.setValue(false, forKey: "healthKitAccess")
                textStatus = "Unknowned error occurred. Try again later."
            case .unnecessary:
                UserDefaults.standard.setValue(true, forKey: "healthKitAccess")
                textStatus = " Unnecessary .You have already allow all data for using "
            case .shouldRequest:
                self.requestForAccessToHealth()
                UserDefaults.standard.setValue(false, forKey: "healthKitAccess")
                textStatus = "Should request .The app does not requested for all specific data yet"
            @unknown default:
                break
            }
        }
        print(textStatus)
    }
    
    ///Function necessary for accessing to steps data and loading it while application in background mode
    private func requestAccessToBackgroundMode() {
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't get access to Health Kit")
            return
        }
        
        guard let steps = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        healthStore.enableBackgroundDelivery(for: steps, frequency: .immediate) { status, error in
            if status {
                print("Background delivery is enabled")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
