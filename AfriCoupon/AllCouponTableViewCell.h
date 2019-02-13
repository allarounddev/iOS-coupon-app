//
//  AllCouponTableViewCell.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 18/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCouponTableViewCell : UITableViewCell

/*First view*/
@property(strong,nonatomic) IBOutlet UIImageView *logo;
@property(strong,nonatomic) IBOutlet UIImageView *seprator;

/*second view*/
@property(strong,nonatomic) IBOutlet UILabel *LogoName;
@property(strong,nonatomic) IBOutlet UILabel *categoryName;
@property(strong,nonatomic) IBOutlet UIImageView *timerImg;
@property(strong,nonatomic) IBOutlet UILabel *expiryDate;
@property(strong,nonatomic) IBOutlet UIImageView *seprator1;

/*third view*/
@property(strong,nonatomic) IBOutlet UITextView *Shorttitle;
@property(strong,nonatomic) IBOutlet UIButton *star;
@property(strong,nonatomic) IBOutlet UIImageView *unlock;

@property(strong,nonatomic) IBOutlet UIView *divider;


@end
