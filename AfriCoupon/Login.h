//
//  Login.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
@interface Login : UIViewController<UITextFieldDelegate>

{
    IBOutlet UIImageView *logoImage;
    IBOutlet UILabel *welcome;
    IBOutlet UIButton *forgetPassword;

}
@property(strong,nonatomic) IBOutlet UITextField *emailTxtFld;
@property(strong,nonatomic) IBOutlet UITextField *passwordTxtFld;
@property(strong,nonatomic) IBOutlet UIButton *LoginBtn;
@property(strong,nonatomic) IBOutlet UIButton *SignUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *SkipBtn;

-(IBAction)SignUp:(id)sender;

@end
