//
//  SettingSubViewController.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 27/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingSubViewController : UIViewController<UIWebViewDelegate>
{
IBOutlet UIButton *back;
IBOutlet UILabel *titleLbl;
IBOutlet UIView *NavView;
    IBOutlet UIWebView *webSiteWV;
    IBOutlet UIScrollView *termScrollView;
    IBOutlet UILabel *AccLbl;
    IBOutlet UILabel *GenerlLbl;
    IBOutlet UILabel *PrivacyLbl;
    IBOutlet UILabel *IndeminationLbl;
    IBOutlet UILabel *ThirdPartyLbl;
    IBOutlet UILabel *ModifiedTermsLbl;
    IBOutlet UILabel *ProhibitionLbl;
    IBOutlet UILabel *StandardTermsLbl;
    IBOutlet UILabel *purchaseLbl;
}
@end
