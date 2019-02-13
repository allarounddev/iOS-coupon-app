//
//  ResetPasswordVC.h
//  AfriCoupon
//
//  Created by Deepak on 24/02/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

@interface ResetPasswordVC : UIViewController
{
    IBOutlet UIImageView *logoImage;
    IBOutlet UITextField *enterOTP;
    IBOutlet UITextField *enterPassword;
    IBOutlet UITextField *confirmPassword;
    IBOutlet UIButton *resetPassword;
    IBOutlet UIButton *cancel;

}
@property(strong, nonatomic) NSString* email;
@end
