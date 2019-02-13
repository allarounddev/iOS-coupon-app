//
//  Helper.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 19/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface Helper : NSObject

+(NSMutableArray *)UserFavoriteCoupon:(NSInteger )USER_ID;
+(NSMutableArray *)AllCoupon:(NSInteger)value :(NSInteger)userid;
//+(NSString *)UnFavoriteCoupon1:(NSInteger)userID :(NSInteger )couponId;
+(NSMutableArray *)CouponDetails:(NSInteger )coupon_id;
+(NSMutableArray *)MerchantSlidingImages:(NSInteger )coupon_id;
+(NSMutableArray *)MerchantOpeningClosingTime:(NSInteger )merchant_id;
+(NSMutableArray *)CouponSlidingImages:(NSInteger )coupon_id;
+(NSMutableArray *)GetCoupons:(NSInteger )couponId :(NSInteger)userID :(NSString *)Url;
+(NSString *)UnFavoriteCoupon1: (NSInteger)userID :(NSInteger)couponId :(NSString *)Url;
+(NSMutableArray *)GetCategory;
+(NSMutableArray *)searchCategory: (NSString *)categoryName :(NSInteger)userID;
+(NSInteger )ALLNotificationStatus:(NSInteger)userID :(NSString *)status :(NSString *)url :(NSString *)notifictionType;
+(NSMutableArray *)checkNotioficSatus:(NSInteger)userID;
+(NSMutableArray *)randomBanner;
+(NSString *)GetOTP :(NSString *)email;
+(NSString *)ResetPassword :(NSString *)OTP :(NSString *)email :(NSString *)password;
+(NSMutableArray *)filterData:(NSString *)country :(NSString *)date :(NSString *)category  :(NSString *)type :(NSInteger)userID;
+(NSMutableArray *)search:(NSString *)searchText :(NSInteger)userID;
+(NSString*)UpgradeAccount :(NSInteger)userId;
@end
