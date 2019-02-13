//
//  MenuBarTableViewController.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface MenuBarTableViewController : UITableViewController<MFMailComposeViewControllerDelegate>

{
    NSMutableArray *arrSites;
    NSUserDefaults *sharedUserDefaults;
   
}
   @property(strong,nonatomic) IBOutlet UITableView *menuTbl;

@end
