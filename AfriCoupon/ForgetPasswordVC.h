//
//  ForgetPasswordVC.h
//  AfriCoupon
//
//  Created by Deepak on 23/02/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
@interface ForgetPasswordVC : UIViewController
{
    IBOutlet UIImageView *logoImage;
    IBOutlet UILabel *ForgetPassword;
    IBOutlet UILabel *enterYourMail;
    IBOutlet UITextField *emailField;
    IBOutlet UIButton *getOTP;
    IBOutlet UIButton *cancel;
}
@end
