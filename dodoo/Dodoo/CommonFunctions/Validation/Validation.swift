
//
//  Utility.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 2/3/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit

extension String {

    enum FieldType : String{

        case firstName
        case lastName
        case name
        case middleName
        case email
        case password
        case newpassword
        case info
        case mobile
        case country
        case state
        case city
        case designation
        case address
        case building
        case amount
        case extensionn
        case image
        case regNo
        case landMark
        case title
        case description
        case pickUpDoorNumber
        case pickupareaname
        case dropDoorNumber
        case dropAreaName
        case desc
        


        func value() -> String? {
            switch self {
            case .firstName :  return R.string.localize.firstName()
            case .middleName : return R.string.localize.middleName()
            case .name : return R.string.localize.name()
            case .lastName :  return R.string.localize.lastName()
            case .email :  return R.string.localize.email()
            case .password :  return R.string.localize.password()
            case .newpassword :  return R.string.localize.newpassword()
            case .info :  return R.string.localize.info()
            case .mobile :  return R.string.localize.mobile()
            case .country : return R.string.localize.country()
            case .state : return R.string.localize.state()
            case .city : return R.string.localize.city()
            case .designation : return R.string.localize.designation()
            case .address : return R.string.localize.address()
            case .building : return R.string.localize.building()
            case .amount : return R.string.localize.building()
            case .extensionn : return R.string.localize.building()
            case .image : return R.string.localize.image()
            case .regNo : return R.string.localize.commRegNo()
            case .landMark : return R.string.localize.landmark()
            case .title : return R.string.localize.title()
            case .description : return R.string.localize.desc()
            case .pickUpDoorNumber : return R.string.localize.pickUpDoorNumber()
            case .pickupareaname : return R.string.localize.pickupareaname()
            case .dropDoorNumber : return R.string.localize.dropDoorNumber()
            case .dropAreaName :  return R.string.localize.dropAreaName()
            case .desc : return R.string.localize.desc()
           }
        }
    }

    enum Status : String {

        case empty
        case allSpaces
        case valid
        case inValid
        case allZeros
        case hasSpecialCharacter
        case notANumber
        case emptyCountrCode
        case mobileNumberLength
        case pwd
        case pinCode
        case zip
        case currency
        case misMatchPassword
        case image


        func value() -> String? {
            switch self {
            case .empty : return R.string.localize.validEmpty()
            case .allSpaces : return R.string.localize.validAllSpaces()
            case .valid : return nil
            case .inValid : return R.string.localize.inValid()
            case .allZeros : return R.string.localize.validAllZeros()
            case .hasSpecialCharacter : return R.string.localize.validHasSpecialCharacter()
            case .notANumber  : return R.string.localize.validNotANumber()
            case .emptyCountrCode : return R.string.localize.validEmptyCountrCode()
            case .mobileNumberLength : return R.string.localize.validMobileNumberLength()
            case .pwd : return R.string.localize.validPwd()
            case .pinCode : return R.string.localize.validPinCode()
            case .zip : return R.string.localize.validZip()
            case .currency : return R.string.localize.validCurrency()
            case .misMatchPassword : return R.string.localize.validMatchPassword()
            case .image : return R.string.localize.validImage()

            }
        }
        func message(type : FieldType) -> String? {

            switch self {
            case .hasSpecialCharacter: return /type.value() + /self.value()
            case .valid: return nil
            case .emptyCountrCode: return /self.value()
            case .pwd : return self.value()
            case .image : return self.value()
            case .mobileNumberLength : return /self.value()
            case .pinCode , .zip : return self.value()
            case .notANumber : return /type.value() + /self.value()
            default: return /self.value() + /type.value()
            }
        }
    }

    // **** validateEmailForm
    func validateEmailForm(email : String? , password : String? , confirmPassword : String?) -> Bool{

        if  !isValid(type : .email, info : email) || !isValid(type : .password, info : password){
            return false
        }
        else if password != confirmPassword {
            Messages.shared.show(alert: .oops, message: R.string.localize.validMatchPassword(), type: .warning)
            //AlertsClass.shared.showAlert(with: Status.misMatchPassword.rawValue)
            return false
        }
        return true
    }

    // **** validatePhoneNumber
    func validatePhoneNumber(phone : String?) -> Bool{
        if isValid(type : .mobile , info : phone){
            return true
        }
        return false
    }


    func validateUpdateProfile(firstName : String? ,middleName : String? , lastName : String?) -> Bool{
        if !isValid(type : .firstName, info : firstName) || !isValid(type : .middleName , info : middleName) || !isValid(type : .lastName, info : lastName){
            return false
        }
        return true
    }

  
    /* Branch Communication validation */
    func validateCommunication(reviewE : String? , reviewA : String? , fbLink : String? , instaLink : String? , twitLink : String? , googleLink : String? , linkedinLink : String? , uTubeLink : String? , pinterestLink : String? , phoneNo1 : String? , phoneNo2 : String? , email1 : String? , email2 : String?) -> Bool{

        //if description no in english
        if  isValid(type : .info , info : reviewE) {
            return false
        }

        return true
    }
    
    func validatePickUpAndDrop(title : String? , desc : String? , pickUpDoorNumber : String? , pickUpAreaName : String? , name : String? , contactNo : String? , module : Module? , selectDate : String? , selectTime : String? , selectDeliveryCycle : String?) -> Bool {
        
        if !isValid(type : .title , info : title) || !isValid(type : .description , info : desc) ||  !isValid(type : .name ,  info : name) || !isValid(type : .mobile ,  info : contactNo){
            return false
        }
        
        
        if let module = module {
            if module == .Subscription {
                if !isValid(type :.pickUpDoorNumber, info : pickUpDoorNumber)  || !isValid(type :  .pickupareaname, info : pickUpAreaName) {
                    return false
                }
                
                if selectDeliveryCycle?.trimmed().count == 0 || selectDeliveryCycle == nil {
                    Messages.shared.show(alert: .oops, message: R.string.localize.pleaseSelectDeliveryCycle(), type: .warning)
                    return false
                }
            }
        }
        
        return true
    }
    
    func validatePickUpAndDropPoints(pickUpDoorNumber : String? , pickUpAreaName : String? , addressType : AddressType) -> Bool {
        
        
        if addressType == .pick {
            if !isValid(type :.pickUpDoorNumber, info : pickUpDoorNumber)  || !isValid(type :  .pickupareaname, info : pickUpAreaName)
            {
                return false
            }
        }
        
        if addressType == .drop {
            if !isValid(type : .dropDoorNumber , info : pickUpDoorNumber)   || !isValid(type : .dropAreaName, info : pickUpAreaName) {
                return false
            }
        }
        
        return true
    }
    
    
//    func isPickAndDropPointSame(pickUpAreaName : String? , dropAreaName : String?) -> Bool  {
//
//        if /pickUpAreaName?.elementsEqual(dropAreaName ?? ""){
//            Messages.shared.show(alert: .oops, message: "Pick up and drop location must be different", type: .warning)
//            return true
//
//        }
//        return false
//    }
//
//        //        if module == .PickUpAndDrop {
//        //
//        //            if selectDate == "Select Date" {
//        //                Messages.shared.show(alert: .oops, message: R.string.localize.pleaseSelectDate(), type: .warning)
//        //                return false
//        //            }
//        //
//        //            if selectTime == "Select Time"{
//        //                 Messages.shared.show(alert: .oops, message: R.string.localize.pleaseSelectTime(), type: .warning)
//        //                return false
//        //            }
//        //        }
////        return true
////    }
//
    
    func validateAddAddress(_ name : String? , doorNo : String? , contactNo : String? , fullAddress: String?) -> Bool{
        if !isValid(type: .name, info: name) {
            return false
        }
        else if doorNo?.trimmed().count == 0 {
            Messages.shared.show(alert: .oops, message: "Please enter door no", type: .warning)
            return false
        }
        else if !isValid(type: .mobile, info: contactNo) {
            return false
        }
        else if fullAddress?.trimmed().count == 0 {
            Messages.shared.show(alert: .oops, message: "Please enter delivery address", type: .warning)
            return false
        }
        return true
    }



//    /********* BRANCH SERVICE *******/
//
//    func isValidServices(isStoreService : Bool?, isHomeService : Bool? , storeHours : String? , homeHours : String? , minServiceOrder : String? , serviceCharge : String? , bussinessSince : String?) -> Bool {
//        if !(/isStoreService)  && !(/isHomeService) {
//            Messages.shared.show(alert: .oops, message: R.string.localize.validateOneService(),  type: .warning)
//            return true
//        }
//        if /isStoreService{
//            if !isValid(type : .bookTime , info : storeHours)  {return true}
//        }
//        if /isHomeService{
//            if !isValid(type : .bookTime , info : homeHours) || !isValid(type : .serviceOrder , info : minServiceOrder) || !isValid(type : .serviceCharge , info : serviceCharge) {
//                return true
//            }
//        }
//        if !isValid(type : .date , info : bussinessSince){
//            return true
//        }
//        return false
//    }

    /*** BRANCH PAYMENT *****/
//
//    func isValidatePayment(isCod : Bool? , isOnline : Bool? , image : UIImage?) -> Bool{
//        if !(/isCod) && !(/isOnline) {
//            Messages.shared.show(alert: .oops, message: R.string.localize.validatePaymentMethod(), type: .warning)
//            return false
//        }
//        if !"".isValidTermsAndConditions(image: image){
//            return false
//        }
//        return true
//    }
//    func validateUploadDoc(image : UIImage?) -> Bool{
//        if !isValidTermsAndConditions(image : image){
//            return false
//        }
//        return true
//    }


    func validatenName(storeName : String?) -> Bool {
        if !isValid(type : .name , info : storeName)
        {
            return false
        }
        return true
    }
    func validatePhone(phone : String?) -> Bool{
        if isValid(type : .mobile , info : phone){
            return true
        }
        return false
    }

//    func isValidTermsAndConditions(image : UIImage?) -> Bool {
//
//        if image == R.image.ic_rect() {
//            Messages.shared.show(alert: .oops, message: R.string.localize.validateTermsAndCond(), type: .warning)
//            return false
//        }
//        return true
//    }


    //    func validateImage(image : UIImage?) -> Bool{
    //        if !isValid(type: .image , info : image) {
    //            return false
    //        }
    //        return true
    //    }



    //}
    func validateName(first : String? , last : String?) -> Bool{
        if isValid(type : .firstName , info : first) && isValid(type : .lastName , info : last){
            return true
        }
        return false
    }

    
    func validSignUp(name : String? , email : String? , password : String?, confirm : String? , mobNo : String?) -> Bool {
        
        if !isValid(type: .name, info: name) || !isValid(type: .email, info: email) {
            return false
        }
        else if !validateChangePassword(new : password , confirm : confirm) {
            return false
        }
        else if !isValid(type: .mobile, info: mobNo) {
            return false
        }
        else {
        return true
        }
       
    }


    func validateChangePassword(new : String? , confirm : String?) -> Bool{

        if new?.trimmed().count == 0 {
            Messages.shared.show(alert: .oops, message: R.string.localize.pleaseEnterNewPassword(), type: .warning)
            return false
        }
        else if confirm?.trimmed().count == 0 {
            Messages.shared.show(alert: .oops, message:R.string.localize.pleaseReTypePassword(), type: .warning)
            return false
        }
        else {
            if new?.trimmed() != confirm?.trimmed() {
                Messages.shared.show(alert: .oops, message: R.string.localize.passwordDoesNotMatch(), type: .warning)
                return false
            }
        }
        return true
    }

    func validateForgetPassword(new : String? , confirm : String?) -> Bool{

        if !isValid(type : .newpassword , info : new){
            return false
        }else if new != confirm{
            //Alerts.shared.show(alert: .error, message: AlertMessage.matchConfirmAndNew.rawValue , type : .info)
            return false
        }
        return true

    }




    func login(email : String?) -> Bool {
        if  isValid(type: .email, info: email)
        {
            return true
        }
        return false
    }

    func signup(firstname : String?, lastname : String?, email : String?, password : String?) -> Bool{
        if isValid(type: .firstName, info: firstname) && isValid(type: .lastName, info: lastname) && isValid(type: .email, info: email) && isValid(type: .password, info: password) {
            return true
        }
        return false
    }
    
    
    func saveStoreOrders(name : String? , address : String? , Landmark : String? , contactNo : String?) -> Bool {
        if isValid(type: .name, info: name) && isValid(type: .address, info: address) && isValid(type: .landMark, info: Landmark) && isValid(type: .mobile, info: contactNo) {
            return true
        }
        return false
    }


    private func isValid(type : FieldType , info: String?) -> Bool {
        guard let validStatus = info?.handleStatus(fieldType : type) else {
            return true
        }

        let errorMessage = validStatus
        print(errorMessage)
        Messages.shared.show(alert: .oops, message: errorMessage, type: .warning)
        //AlertsClass.shared.showAlert(with: errorMessage)
        return false
    }

    func handleStatus(fieldType : FieldType) -> String? {

        switch fieldType {
        case .firstName , .lastName :
            return  isValidName.message(type: fieldType)
        case .middleName :
            return isValidMiddleName.message(type: fieldType)
        case .email:
            return  isValidEmail.message(type: fieldType)
        case .password , .newpassword:
            return  isValid(password: 6, max: 15).message(type: fieldType)
        case .info:
            return  isValidInformation.message(type: fieldType)
        case .mobile:
            return  isValidPhoneNumber.message(type: fieldType)
        case .amount:
            return  isValidAmount.message(type: fieldType)
        case .extensionn :
            return isValidExtension.message(type: fieldType)
        case .city:
            return isValidWord.message(type:fieldType)
            //        case   .designation  ,.personnelId ,.regNo:
            //            return  isValidInformation.message(type: fieldType)
            // case .cardNumber:
            //      return  isValidCardNumber(length: 16).message(type: fieldType)

        default:
            return  isValidInformation.message(type: fieldType)
        }
    }



    var isNumber : Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }

    var hasSpecialCharcters : Bool {
        return rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil || rangeOfCharacter(from: CharacterSet.letters.inverted) != nil
    }

    var hasSpecialCharactersWithNumber : Bool {
        return rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil
    }
    var isEveryCharcterZero : Bool{
        var count = 0
        self.characters.forEach {
            if $0 == "0"{
                count += 1
            }
        }
        if count == self.characters.count{
            return true
        }else{
            return false
        }
    }

    public var length: Int {
        return self.characters.count
    }

    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }

    public var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }

    func isValid(password min: Int , max: Int) -> Status {
        if length < 0 { return .empty }
        if isBlank  { return .allSpaces }
        if characters.count >= min && characters.count <= max{
            return .valid
        }
        return .pwd
    }

    var isValidEmail : Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if isEmail { return .valid }
        return .inValid
    }

//    func isValidImage(image : UIImage?) -> Bool{
//        if image == R.image.ic_profile_placeholder(){
//            Messages.shared.show(alert: .oops, message: R.string.localize.validImage(), type: .warning)
//            return false
//        }
//        return true
//    }



    var isValidInformation : Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        return .valid
    }

    var isValidExtension : Status {
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if self.count < 6  && isNumber { return .valid }
        if self.count == 0 { return .valid }
        return .inValid
    }

    var isValidPhoneNumber : Status {

        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        if isEveryCharcterZero { return .allZeros }
        if !isNumber { return .inValid }
        if validate(value: self) {
                
            return .valid
        }
        else{
            return .mobileNumberLength
        }
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^[6-9][0-9]{9}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }

    var isValidName : Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if hasSpecialCharcters { return .hasSpecialCharacter }

        return .valid
    }

    //Validation for City Country District
    var isValidWord : Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if hasSpecialCharcters{ return .inValid}
        return .valid
    }

    var isValidMiddleName : Status {
        if hasSpecialCharcters { return .hasSpecialCharacter }
        return .valid
    }

    func isValidCardNumber(length max:Int ) -> Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if characters.count >= 16 && characters.count <= max{
            return .valid
        }
        return .inValid
    }

    var isValidCVV : Status {
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if isEveryCharcterZero { return .allZeros }
        if isNumber{
            if self.characters.count >= 3 && self.characters.count <= 4{
                return .valid
            }else{ return .inValid }
        }else { return .notANumber }
    }

    var isValidZipCode : Status {
        if length == 0 { return .empty }
        if isEveryCharcterZero { return .allZeros }
        if isBlank { return .allSpaces }
        if !isNumber{ return .inValid }
        if hasSpecialCharactersWithNumber {return.zip}
        if length > 6 {return .pinCode}

        return .valid
    }

    var isValidAmount :  Status {
        if length < 0 { return .empty }
        if isBlank { return .allSpaces }
        if !isNumber{ return .notANumber }
        return .valid
    }

}


