//
//  SettingViewController.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 16/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteViewController.h"

@interface SettingViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

{
    IBOutlet UIView *feedbackView;
    IBOutlet UIButton *sendFeedback;
    IBOutlet UITextField *emailLbl;
    IBOutlet UITextField *feedbackLbl;
    IBOutlet UILabel *topLbl;
    IBOutlet UILabel *bottomLbl;
    IBOutlet UIImageView *sepratorMid;
    IBOutlet UIImageView *sepratorEnd;
    IBOutlet UIImageView *sepratorTop2;

}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property (strong, nonatomic) IBOutlet UITableView *settingTbl;

@end
