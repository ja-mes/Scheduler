//
//  Validator.swift
//  Scheduler
//
//  Created by James Brown on 10/13/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit
import PhoneNumberKit

enum ValidationError: Error {
    case InvalidPhone
    case InvalidEmail
}

class Validator {
    func validEmail(value: String) throws {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: value)
        
        if result == false {
            throw ValidationError.InvalidEmail
        }
    }

    
    func validPhone(value: String) throws {
        let phoneNumberKit = PhoneNumberKit()
        
        do {
            let _ = try phoneNumberKit.parse(value)
        } catch {            
            throw ValidationError.InvalidPhone
        }
    }
    
    func format(_ value: String) -> String {
        let phoneNumberKit = PhoneNumberKit()
        
        do {
            let phoneNumber = try phoneNumberKit.parse(value)
            return phoneNumberKit.format(phoneNumber, toType: .national)
        } catch ValidationError.InvalidPhone {
            return ""
        } catch {
            fatalError("Unable to format phone number: \(error)")
        }
    }
    
}
