//
//  TAbInfoClassViewController.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 19/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <StoreKit/StoreKit.h>
#import "SVProgressHUD.h"

@interface TAbInfoClassViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,SKProductsRequestDelegate,SKRequestDelegate,UIAlertViewDelegate,SKPaymentTransactionObserver,UIGestureRecognizerDelegate>
{
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *merchant_category;
    IBOutlet UIScrollView *TopScrll;
    
    IBOutlet UIView *ourCouponView;
    IBOutlet UIView *couponDetailView;
    IBOutlet UIView *mapkitView;
    
    // coupon
    IBOutlet UIImageView *logoImg;
    IBOutlet UILabel *couponTitle;
    IBOutlet UIImageView *CouponImgview;
   
    IBOutlet UILabel *couponDetail;//addresslbl;// coupon detail text
   // IBOutlet UILabel *details;//unlockLbl; //coupon detail
    IBOutlet UITextView *couponExp;//addressDetailTxt;// coupon exp
    UILabel *couponTitle2;
    UIImageView *CouponImgview2;
    UILabel *couponDetail2;
    UITextView *couponExp2;
    UILabel *couponTitle3;
    UIImageView *CouponImgview3;
    UILabel *couponDetail3;
    UITextView *couponExp3;
    UIView *gestureView;
    
    // info

    IBOutlet UIImageView *logoImg1;
    IBOutlet UIImageView *logoImg2;
    IBOutlet UILabel *merchantNameLabel;
    IBOutlet UILabel *website;
    IBOutlet UILabel *phone;

    IBOutlet UITextView *detailTxt;

    IBOutlet UILabel *addressText;
    IBOutlet UILabel *address;

    IBOutlet UILabel *OpenTimes;
    IBOutlet UITextView *OpenTimesTxtview;
    
    // payment info view
   IBOutlet UIView *paymnetInfoView;
   IBOutlet UIScrollView *paymentInfoScroll;
    IBOutlet UILabel *PITitle;
    IBOutlet UIView * PIDivider;
    IBOutlet UILabel *PITitle2;
    IBOutlet UILabel *PITitle3;
    IBOutlet UILabel *PITitle4;
    IBOutlet UILabel *PITitle5;
    IBOutlet UILabel *PITitle6;
    IBOutlet UIButton *paypalButton;
    IBOutlet UIButton *applePayButton;
    IBOutlet UILabel *PITitle7;
    IBOutlet UIImageView *shadedimageView;
    
    UITapGestureRecognizer *phoneGesture;
    UITapGestureRecognizer *websiteGesture;
    CLLocationManager*  locationManager;
    SKProduct *product;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString *listingLatitude;
@property (nonatomic, strong) NSString *listingLongitude;


@end
