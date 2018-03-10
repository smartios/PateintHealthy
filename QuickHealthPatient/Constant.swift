//
//  LoginView.swift
//  getAvis
//
//  Created by SS142 on 01/08/16.
//  Copyright © 2016 SS142. All rights reserved.
//

import Foundation



let appDelegate = UIApplication.shared.delegate as! AppDelegate
let access_token = UserDefaults.standard.object(forKey: "access_token") as! String


//let webServiceUrl = "http://115.249.91.204/quickhealth/webservice/" //development

//let webServiceUrl = "http://103.15.232.35/singsys-stg3/quickhealth/webservice/" //// Staging Server

//let webServiceUrl = "http://quickhealth4u.com/develop/webservice/" //new Dev
let webServiceUrl = "https://quickhealth4u.com/webservice/" //new pro

//let webServiceUrl = "http://192.168.45.67/ci/quickhealth/webservice/" //local


struct WebAPI {
    
    static let BASE_URL = webServiceUrl
    
    //   static let BASE_URLs = "http://115.249.91.204/quickhealth/" // development
    
    //  static let BASE_URLs = "http://quickhealth4u.com/develop/" //new dev
    
    static let BASE_URLs = "https://quickhealth4u.com/" //new pro
    
    //   static let BASE_URLs = "http://192.168.45.67/ci/quickhealth/" //local
    
    // static let BASE_URLs = "http://103.15.232.35/singsys-stg3/quickhealth/" // // Staging Server
    
    static let api_token = "oauth2/token"
    static let signup_webMehod = "signup"
    static let login_webmethod = "login"
    static let otp_webmethod = "verify_otp"
    static let resendotp_webmethod = "resend_otp"
    static let reset_password = "reset_password"
    static let forgot_password = "forgot_password"
    static let Get_country_code = "country_code"
    static let FAQ_webMethod = "faq_data"
    static let contact_us = "contact_us"
    static let services_list = "services_list"
    static let doctor_list = "doctor_list"
    static let favourite_list = "favourite_list"
    //favourite_list
    
    
    //inbox_listing
    static let inbox = "inbox"
    static let physical_stats = "physical_stats"
    static let month_availability_ios = "month_availability_ios"
    static let child_list = "child_list"
    static let medication = "medication"
    static let family_history = "view_family_history"
    static let language_list = "language_list"
    //language_list
    
    static let user_profile = "user_profile"
    static let edit_profile = "edit_profile"
    static let add_child = "add_child"
    static let change_password = "change_password"
    static let delete_child = "delete_child"
    //delete_child
    
    //booking appt
    static let book_appointment = "book_appointment"
    static let paypal_payment_request = "paypal_payment_request"
    static let appointment_list = "appointment_list"
    static let appointment_detail = "appointment_detail"
    static let mark_as_favourite = "mark_as_favourite"
    
    static let history = "history_list"
    static let COUNTRY_LIST = "getAllCountry"
    static let STATE_LIST = "getState"
    static let CITY_LIST = "getCity"
    static let CUSTOMER_LOGIN = "customer_login"
    static let CUSTOMER_SIGNUP = "customer_registration"
    static let CUSTOMER_OTP = "mobile_verification"
    static let FORGOT_PASSWORD = "forgot_password"
    static let REFRESH_TOKEN = "refresh_token"
    static let RESEND_SMS = "resend_otp"
    static let EDIT_PROFILE = "edit_profile"
    static let ADD_PAYMENT_CARD = "add_payment_card"
    static let VIEW_CUSTOMER_PROFILE = "view_customer_profile"
    static let GET_CUSTOMER_CARD = "get_customer_card"
    static let DELETE_PAYMENT_CARD = "delete_payment_card"
    static let MARK_DEFAULT_CARD = "mark_default_card"
    static let COMMON_DATA = "get_common_data"
    static let GET_STATE_CITY = "getStateCity"
    static let GET_SP_INFO = "provider_info"
    static let GET_FIND_CATEGORY = "find"
    static let EXPLORE = "explore"
    static let POST_COMMENTS = "post_comments"
    static let POST_LIKE = "post_like"
    static let GET_SP_SERVICE_LIST = "get_servicelist"
    static let SERVICE_DETAIL = "service_detail"
    static let AVAILABLE_BOOKING_SLOT = "available_booking_slot"
    static let CASH_DOLLAR_INFO = "cash-dollar-info"
    static let FIND_PROVIDER_LIST = "find-providerlist"
    static let SEARCH_KEYWORD_LIST = "search-keywords-list"
    static let SERVICE_BOOKING = "service-booking"
    static let SEARCH_AVAILABILITY = "service-availability"
    static let REPORT_INAPPROPRIATE = "report-inappropriate"
    static let BOOKING_LIST = "booking-list"
    static let SERVICE_BOOKING_DETAIL = "service-booking-detail"
    static let CREATE_REVIEW = "create-review"
    static let MARK_AS_DEFAULT = "mark-as-default"
    static let RESCHEDULE_BOOKING = "reschedule-booking"
    static let CANCEL_BOOKING = "cancel-booking"
    static let SEND_EMAIL_RECEIPT = "send-email-receipt"
    static let NOTIFICATION_LIST = "notification-list"
    static let NOTIFICATION_ACTION = "notification-action"
    static let FOLLOW = "follow"
    static let LOGOUT = "logout"
    static let GET_GALLERY_DATA = "get-gallery-data"
    static let GET_LIKED_DATA = "get-liked-data"
    static let REVIEWLIST = "reviewslist"
    static let OTHERUSERINFO = "otherUserInfo"
    static let GET_FAVORITE_STORE = "get-favourite-store"
    static let GET_FAVORITE_WORK = "get-favourite-work"
    static let GET_FAVORITE_USERS = "get-favourite-users"
    static let GET_FAVORITE_USERS_REVIEWS = "get-favourite-users-reviews"
    static let GET_UNREAD_CHAT = "getUnreadChat"
    static let REDEEM_COUPON = "redeem-coupon"
    static let GET_REVIEW_GALLERY_DATA = "get-review-gallery-data"
    static let GET_CANCELLATION_REASON = "get_cancellation_reason"
    static let REVIEW_LIST_GRID = "reviewslist-grid"
    static let BOOKING_ACTION = "booking-action"
    static let RESEND_EMAIL_VERIFICATION = "resend_email_verification"
    static let CHECK_RESCHEDULE_BOOKING = "check_reschedule_booking"
    static let CHAT_BOOKING_LIST = "chat-booking-list"
    static let SUBMIT_CONTACT_US = "submit-contact-us"
    static let FAQ = "faq?"
    static let CHANGE_LANGUAGE = "change-language"
    static let GET_USER_LANGUAGE = "get-user-language"
    static let Nurse_Track_Listing = "track_user"
    static let Feedback_Rating = "track_user"
    static let Disconnect_Call = "end_call"
}


//tokbox keys
var kApiKey = "46062412"
// Replace with your generated session ID
var kSessionId = "2_MX40NjA2MjQxMn5-MTUxOTI3NjQ0Mzk3MH54a1lhNjY0Sld3bHFRVkYrdUZDRlNQYnR-fg"
// Replace with your generated token
var kToken = "T1==cGFydG5lcl9pZD00NjA2MjQxMiZzZGtfdmVyc2lvbj1kZWJ1Z2dlciZzaWc9YzA2YzI4OGU2ZDU4NjQ2ZGU1N2QzYjkzZWI1MDNiMDA0MTg4N2UzYzpzZXNzaW9uX2lkPTJfTVg0ME5qQTJNalF4TW41LU1UVXhPVEkzTmpRME16azNNSDU0YTFsaE5qWTBTbGQzYkhGUlZrWXJkVVpEUmxOUVluUi1mZyZjcmVhdGVfdGltZT0xNTE5Mjc2NDQzJnJvbGU9bW9kZXJhdG9yJm5vbmNlPTE1MTkyNzY0NDMuOTc2NzEwMTI0MTE5NzEmZXhwaXJlX3RpbWU9MTUyMTg2ODQ0Mw=="

//signup validations

let enterFirstName = "Please enter first name."
let enterLastName = "Please enter last name."
let enterDob = "Please select date of birth."
let validEmail = "Please enter valid email address."
let gender = "Please select gender."
let enterMobileNum = "Please enter mobile number."
let enterPassword = "Please enter password."
let emptyPassword = "Please enter valid password.Passwords must contain at least 8 characters, including uppercase, lowercase letters, spacial character and numbers."
let validPassword = "Please enter valid password.Passwords must contain at least 8 characters."
let validIdentity = "Only 9 characters are allowed. First letter should be S/T/F/G, followed by 7 digit number and last letter should be A-Z."

// signup msg
let typeofProffesion = "Please select Profession."
let typeofServices = "Please select Services."
let licenceno = "Please enter Registration Number."
let martial = "Please enter Martial status."
let lang = "Please enter Language Proficiency."
let entertitle = "Please enter Enter title."
let enterConfirmPass = "Please enter confirm password."
let selecttc = "You must accept our terms & conditions."
let passwordMatch = "Password and confirm password does not match."
let invalidDate = "Please select valid date."
let NoInternetConnection = "Please check your internet connection."
let PleaseWait = "Please Wait"
let Requesting = "Requesting..."



enum EButtonsBar : Int {
    case kButtonsAnswerDecline
    case kButtonsHangup
    case Incoming
    case Outgoing
}

enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}


func isvalidIdentity(IdentityStr: String) -> Bool
{
    let identityRegEx = "^[M]{1}[0-9]{5}[A-Z]{1}?$"
    
    let identityTest = NSPredicate(format:"SELF MATCHES %@", identityRegEx)
    
    return identityTest.evaluate(with: IdentityStr)
}

func isvalidPersonalIdentityNo(IdentityStr: String) -> Bool
{
    let identityRegEx = "^[STFG]{1}[0-9]{7}[A-Z]{1}?$"
    
    let identityTest = NSPredicate(format:"SELF MATCHES %@", identityRegEx)
    
    return identityTest.evaluate(with: IdentityStr)
}


class CommonValidations: NSObject
{
    //MARK: Validate Email
    
    class func convertToDictionary(text: String) -> NSDictionary {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as!NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return NSDictionary()
    }
    
    
    class func isValidEmail(testStr:String) -> Bool
    {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPassword(testStr:String) -> Bool
    {
        let passwordRegEx = "^.*(?=.{8}).*$"
        // let passwordRegEx = "((?=.*\\d)(?=.*[A-Z])(?=.*[@#$%]).{8,15})"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        return passTest.evaluate(with: testStr)
    }
    
    
    class func isValidNRIC(testStr:String) -> Bool
    {
        let nricRegEx = "^[A-Z]{1}[0-9]{7}[A-Z]{1}"
        let nrictest = NSPredicate(format: "SELF MATCHES %@", nricRegEx)
        return nrictest.evaluate(with: testStr)
    }
    
    
    //MARK: Get The Color From RGB
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func isValidDate(from: String, until: String) -> Bool
    {
        switch from.compare(until)
        {
        case .orderedAscending     :
            return true
        case .orderedDescending    :
            return false
        case .orderedSame          :
            return true
        }
    }

    
    class func getDateStringFromDateString(date: String, fromDateString: String, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateString
        let getDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toDateString
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: getDate!)
    }
    
    class func getDateUTCStringFromDateString(date: String, fromDateString: String, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = fromDateString
        let getDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = toDateString
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: getDate!)
    }
    
    
    
    class func getDateStringFromDate(date: Date, toDateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toDateString
        return dateFormatter.string(from: date)
    }
}


func logoutUser()
{
    supportingfuction.hideProgressHudInView(view: (UIApplication.topViewController())!)
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let pushVC = mainStoryboard.instantiateViewController(withIdentifier: "LandngScreen") as! LandngScreen
    let nav: UINavigationController = (UIApplication.topViewController()?.navigationController)!
    nav.viewControllers = [pushVC]
    supportingfuction.showMessageHudWithMessage(message: "You have been logout.", delay: 2.0)
}


class StoredUserData{
    var email:NSString = NSString()
    var name: NSString = NSString()
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        //
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(slide.mainViewController)
        //        }
        return viewController
    }
}
