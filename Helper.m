//
//  Helper.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 19/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "Helper.h"

@implementation Helper


+(NSMutableArray *)UserFavoriteCoupon:(NSInteger )USER_ID
{
    //    {user_id: value}
    NSMutableArray *UserFavoriteCouponArr=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"user_id=%ld",(long)USER_ID];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  // [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/new_coupon_notification"]];
    // [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/expire_coupon_notification"]];
    
   [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/all_favourite_coupon"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
       // MyFavArrData=[[NSArray alloc]init];
     NSString *  rsestr=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];

        UserFavoriteCouponArr=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",rsestr);
    }

    return UserFavoriteCouponArr;
}

+(NSMutableArray *)GetCategory
{
    
    
    NSMutableArray *AllCoupon=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"category=category"];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/all_category_list"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        AllCoupon=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",AllCoupon);
    }
    return AllCoupon;
}
+(NSMutableArray *)searchCategory: (NSString *)categoryName :(NSInteger)userID
{
//    {category:category name, user_id: value}
    
    NSMutableArray *AllCoupon=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"category=%@&user_id=%ld",categoryName,(long)userID];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/search_coupon_by_category"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        AllCoupon=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",AllCoupon);
    }
    return AllCoupon;
}


+(NSMutableArray *)AllCoupon:(NSInteger)value :(NSInteger)userid
{
    NSMutableArray *AllCoupon=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"value=%ld&user_id=%ld",value,(long)userid];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/all_coupon"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        AllCoupon=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",AllCoupon);
    }
    return AllCoupon;
}

+(NSMutableArray *)GetCoupons:(NSInteger )couponId :(NSInteger)userID :(NSString *)Url
{
    NSMutableArray *AddCouponFavoriteArr=[[NSMutableArray alloc]init];
        NSString *post = [NSString stringWithFormat:@"coupon_id=%ld&user_id=%ld",(long)couponId,(long)userID];
        NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:Url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        if (responseStatusCode == 200)
        {
            
            AddCouponFavoriteArr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",AddCouponFavoriteArr);
        }
        return AddCouponFavoriteArr;
    }
+(NSString *)UnFavoriteCoupon1: (NSInteger)userID :(NSInteger)couponId :(NSString *)Url
{
    NSString *rsestr;
    NSString *post = [NSString stringWithFormat:@"user_id=%ld&coupon_id=%ld",(long)userID,(long)couponId];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:Url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        
        rsestr=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",rsestr);
    }
    return rsestr;

}


+(NSMutableArray *)CouponDetails:(NSInteger )coupon_id
{
//    coupon_id:value
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    
    NSString *post = [NSString stringWithFormat:@"coupon_id=%ld",(long)coupon_id];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/coupon_details"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }           

    return CouponDetails;
}

+(NSMutableArray *)MerchantSlidingImages:(NSInteger )coupon_id
{
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"coupon_id=%ld",(long)coupon_id];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/banner_image"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }

    return CouponDetails;
}


+(NSMutableArray *)MerchantOpeningClosingTime:(NSInteger )merchant_id
{
//    {merchant_id:value}
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"merchant_id=%ld",(long)merchant_id];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/loading_availability"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }
    

    return CouponDetails;
 
}


+(NSMutableArray *)CouponSlidingImages:(NSInteger )coupon_id;
{
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
   //{coupon_id:value}
    NSString *post = [NSString stringWithFormat:@"coupon_id=%ld",(long)coupon_id];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/coupon_images"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }
    return CouponDetails;
}

+(NSInteger )ALLNotificationStatus:(NSInteger)userID :(NSString *)status :(NSString *)url :(NSString *)notifictionType
{
    //NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    //{coupon_id:value}
    NSInteger  STATUS;
    NSString *post = [NSString stringWithFormat:@"user_id=%ld&%@=%@",(long)userID,notifictionType,status];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
       STATUS=[[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil]integerValue];
        NSLog(@"%ld",(long)STATUS);
    }
    return STATUS;
}

+(NSMutableArray *)checkNotioficSatus:(NSInteger)userID
{
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"user_id=%ld",(long)userID];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/check_notfic_status"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }

    return CouponDetails;
}
+(NSMutableArray *)randomBanner{
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    NSString *post = @"all:all";
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/random_banner"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }
    
    return CouponDetails;

}
+(NSString *)GetOTP :(NSString *)email{
    NSString *post = [NSString stringWithFormat:@"email=%@",email];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_get_otp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    NSString *str;
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
       str=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",str);
    }
    return str;
}
+(NSString *)ResetPassword :(NSString *)OTP :(NSString *)email :(NSString *)password{
    
    NSString *post = [NSString stringWithFormat:@"code=%@&email=%@&password=%@",OTP,email,password];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_reset_pass"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    NSString *str;
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
       
        NSLog(@"%@",str);
    }
    return str;
}

+(NSMutableArray *)filterData:(NSString *)country :(NSString *)date :(NSString *)category  :(NSString *)type :(NSInteger)userID{
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"expire_date=%@& coupon_type=%@&category=%@&string=%@&user_id=%ld",date,type,category,country,(long)userID];

    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/search_by_type_category"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }
    
    return CouponDetails;

}
+(NSMutableArray *)search:(NSString *)searchText :(NSInteger)userID{
    NSMutableArray *CouponDetails=[[NSMutableArray alloc]init];
    NSString *post = [NSString stringWithFormat:@"keyword=%@&user_id=%ld",searchText,(long)userID];
    
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/search_coupon"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        CouponDetails=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",CouponDetails);
    }
    
    return CouponDetails;
}
+(NSString*)UpgradeAccount :(NSInteger)userId{
    
    NSString *post = [NSString stringWithFormat:@"user_id=%ld",(long)userId];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/upgrade_account"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    NSString *str;
    if (responseStatusCode == 200)
    {
        // MyFavArrData=[[NSArray alloc]init];
        str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",str);
    }
    return str;

}

@end
