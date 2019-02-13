//
//  MainViewConroller.h
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@interface MainViewConroller : UIViewController<UIScrollViewDelegate, UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL CouponFilterBool;
    BOOL MyFavBool;
    BOOL AllCouponBool;
    NSMutableArray *CouponData;
    NSMutableArray *MyFavArrData;
    NSMutableArray *bannerdata;
    NSMutableArray *imageArray;
    UIImageView *imageview1;
    UIImageView *imageview2;
    UIButton *closeAds;
    NSString *country, *date,*category, *type;
    UIPickerView *mPickerView;
    UIView *pickerView ;
    
    NSMutableArray *arrayForDisplay;
}

@property(strong, nonatomic) IBOutlet UIImageView *backImg;

@property(strong, nonatomic) IBOutlet UIScrollView *TopScrollView;
@property(strong, nonatomic) IBOutlet UISearchBar *TopSearchBAr;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menu;
@property (strong, nonatomic) IBOutlet UIView *CouponFilterView;
@property (strong, nonatomic)  UIView *CouponFilterSubView;
@property (strong, nonatomic) IBOutlet UIView *MyFavView;
@property (strong, nonatomic)  UIView *MyFavSubView;

@property (strong, nonatomic) IBOutlet UIView *AllCouponView;
@property (strong, nonatomic) IBOutlet UIButton *CouponFilterBtn;
@property (strong, nonatomic) IBOutlet UIButton *MyFavBtn;
@property (strong, nonatomic) IBOutlet UIButton *AllCouponBtn;
@property (strong, nonatomic) IBOutlet UIImageView *CouponFilterImg;
@property (strong, nonatomic) IBOutlet UIImageView *MyFavImg;
@property (strong, nonatomic) IBOutlet UIImageView *AllCouponImg;
@property (strong, nonatomic) IBOutlet UIButton *LoadMoreBtn;
@property (strong, nonatomic) IBOutlet UITableView *AllCouponTbl;

-(IBAction)CouponFilterAct:(id)sender;
-(IBAction)MyFavAct:(id)sender;
-(IBAction)AllCouponAct:(id)sender;
-(IBAction)LoadMoreAct:(id)sender;

@end

