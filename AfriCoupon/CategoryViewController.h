//
//  CategoryViewController.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 15/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MenuType)
{
    MenuTypeUnblock,
    MenuTypeFaq,
    MenuTypeCategories
};



@interface CategoryViewController : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{


}
@property (assign, nonatomic) MenuType MenuTypeVlaue;

@property(strong,nonatomic) IBOutlet UITableView *categoryTblView;


-(IBAction)back :(id)sender;
@end
