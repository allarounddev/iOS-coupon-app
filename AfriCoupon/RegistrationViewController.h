//
//  RegistrationViewController.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegistrationViewController : UIViewController<UITextFieldDelegate>

@property(strong,nonatomic) IBOutlet UITextField *nameFld;
@property(strong,nonatomic) IBOutlet UITextField *addressFld;
@property(strong,nonatomic) IBOutlet UITextField *emailTxtFld;
@property(strong,nonatomic) IBOutlet UITextField *passwordTxtFld;
@property(strong,nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property(strong,nonatomic) IBOutlet UIButton *freeBtn;
@property(strong,nonatomic) IBOutlet UIButton *submitBtn;

-(IBAction)submit  :(id)sender;
-(IBAction)back  :(id)sender;
@end
