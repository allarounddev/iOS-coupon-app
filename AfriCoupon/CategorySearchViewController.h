//
//  CategorySearchViewController.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 21/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySearchViewController : UIViewController
{
    IBOutlet UISearchBar *categorySearchbar;
    IBOutlet UITableView *categorySerachTblView;
    UITapGestureRecognizer *infoTapGes;
    UITapGestureRecognizer *CouponViewGesture;
    NSArray *filteredArray;
    NSMutableArray *merchant_categoryArr;
}
@end
