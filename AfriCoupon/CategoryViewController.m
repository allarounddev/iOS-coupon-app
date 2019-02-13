//
//  CategoryViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 15/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "CategoryViewController.h"
#import "Helper.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DROPCELLlTableViewCell.h"
#import "CategorySearchViewController.h"
#import "SVProgressHUD.h"
@interface CategoryViewController ()
{
    UINavigationBar *navbar;
    UINavigationItem* navItem ;
    NSMutableArray *categoryArr;
   IBOutlet UIScrollView *unlockScrl;
    CGRect frame;
    UILabel *navTitleLbl;
    IBOutlet UIScrollView *faqScroll;

}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    unlockScrl.hidden=YES;
    self.categoryTblView.hidden=YES;

    unlockScrl.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    unlockScrl.scrollEnabled=YES;
    faqScroll.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    faqScroll.scrollEnabled=YES;
    
    self.categoryTblView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    self.navigationController.navigationBarHidden=YES;
    navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    /* Create navigation item object & set the title of navigation bar. */
    navItem = [[UINavigationItem alloc] init];
    
    /* Create left button item. */
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];

    navItem.leftBarButtonItem = cancelBtn;
    navTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(navbar.frame.size.width/2-140,-5,240, 44)];
   
    navTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18.0];
    navTitleLbl.textColor=[UIColor lightGrayColor];
    navTitleLbl.minimumScaleFactor=0.5;
    navTitleLbl.textAlignment=NSTextAlignmentCenter;
       /* Assign the navigation item to the navigation bar.*/
    [navbar setItems:@[navItem]];
    
    /* add navigation bar to the root view.*/
    [self.view addSubview:navbar];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    unlockScrl.hidden=YES;
    self.categoryTblView.hidden=YES;
    
    unlockScrl.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    unlockScrl.scrollEnabled=YES;
    faqScroll.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    faqScroll.scrollEnabled=YES;
    
    self.categoryTblView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    self.navigationController.navigationBarHidden=YES;
    navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    /* Create navigation item object & set the title of navigation bar. */
    navItem = [[UINavigationItem alloc] init];
    
    /* Create left button item. */
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    navItem.leftBarButtonItem = cancelBtn;
    navTitleLbl=[[UILabel alloc]initWithFrame:CGRectMake(navbar.frame.size.width/2-140,-5,240, 44)];
    
    navTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18.0];
    navTitleLbl.textColor=[UIColor lightGrayColor];
    navTitleLbl.minimumScaleFactor=0.5;
    navTitleLbl.textAlignment=NSTextAlignmentCenter;
    /* Assign the navigation item to the navigation bar.*/
    [navbar setItems:@[navItem]];
    
    /* add navigation bar to the root view.*/
    [self.view addSubview:navbar];

    dispatch_queue_t queue = dispatch_queue_create("com.example.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        
        categoryArr=[Helper GetCategory];

        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.categoryTblView reloadData];
        });
    });
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [self handleLoginType:self.MenuTypeVlaue];
    [SVProgressHUD dismiss];
    
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
- (void)handleLoginType:(MenuType)type {
    
    switch (type) {
        case MenuTypeCategories:
            self.categoryTblView.hidden=NO;
            navTitleLbl.text=@"CATEGORY";
            navItem.titleView=navTitleLbl;
            faqScroll.hidden=YES;

                     break;
            
        case MenuTypeUnblock:
            navTitleLbl.text=@"UNLOCK COUPON";
            navItem.titleView=navTitleLbl;
            unlockScrl.hidden=NO;
            faqScroll.hidden=YES;

            self.categoryTblView.hidden=YES;
            [self unlockView];
            break;
        case MenuTypeFaq:
            navTitleLbl.text=@"FAQ";
            faqScroll.hidden=NO;
            navItem.titleView=navTitleLbl;
            [self faqView];
            break;
  
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource methods
-(void)faqView
{
    UITextView *firstTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,-5,unlockScrl.frame.size.width-20, 30)];
    firstTxtView.scrollEnabled=YES;
    firstTxtView.text=@"If you’ve never used mobile coupons, or just want to learn more about them, this list of frequently asked questions should help you out.";
    firstTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    firstTxtView.textColor=[UIColor lightGrayColor];
    frame = firstTxtView.frame;
    frame.size.height = firstTxtView.contentSize.height;
    firstTxtView.frame = frame;
    [firstTxtView sizeToFit];
    firstTxtView.scrollEnabled=NO;
    firstTxtView.userInteractionEnabled=NO;
    
    UITextView *secondTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,firstTxtView.frame.size.height+firstTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 60)];
    secondTxtView.scrollEnabled=YES;
    secondTxtView.text=@"They’ll also give you more information about the Africoupon app, the first mobile coupon app of West-Africa. Can’t find the answer you’re looking for? Use the contact link at the bottom of the page to send us a message directly.";
    secondTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    secondTxtView.textColor=[UIColor lightGrayColor];
    [secondTxtView sizeToFit];
    secondTxtView.scrollEnabled=NO;
    secondTxtView.userInteractionEnabled=NO;
    
    UITextView *ThirdTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, secondTxtView.frame.size.height+secondTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 24)];
    ThirdTxtView.scrollEnabled=YES;
    ThirdTxtView.text=@"How much does the AfriCoupon app cost?";
    ThirdTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    ThirdTxtView.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    [ThirdTxtView sizeToFit];
    ThirdTxtView.scrollEnabled=NO;
    ThirdTxtView.userInteractionEnabled=NO;

    UITextView *fourthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, ThirdTxtView.frame.size.height+ThirdTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 24)];
    fourthTxtView.scrollEnabled=YES;
    fourthTxtView.text=[NSString stringWithFormat:@"Nothing! The AfriCoupon app is free! You can upgrade to premium for more premium coupons "];
    fourthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    fourthTxtView.textColor=[UIColor lightGrayColor];
    [fourthTxtView sizeToFit];
    fourthTxtView.scrollEnabled=NO;
    fourthTxtView.userInteractionEnabled=NO;
    
    UITextView *fifthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, fourthTxtView.frame.size.height+fourthTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 24)];
    firstTxtView.scrollEnabled=YES;
    fifthTxtView.text=[NSString stringWithFormat:@"Will AfriCoupon work on my phone or tablet? "];
    fifthTxtView.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    fifthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [firstTxtView sizeToFit];
    fifthTxtView.scrollEnabled=NO;
    fifthTxtView.userInteractionEnabled=NO;
    
    UITextView *sixthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,  fifthTxtView.frame.size.height+fifthTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 30)];
    sixthTxtView.scrollEnabled=YES;
    sixthTxtView.text=[NSString stringWithFormat:@"The AfriCoupon app requires iOS 7.0 or later for iPhone, iPad and iPod touch."];
    sixthTxtView.textColor=[UIColor lightGrayColor];
    [sixthTxtView sizeToFit];
    sixthTxtView.scrollEnabled=NO;
    sixthTxtView.userInteractionEnabled=NO;
    sixthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    
    UITextView *sevTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,sixthTxtView.frame.size.height+sixthTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 24)];
    sevTxtView.scrollEnabled=YES;
    sevTxtView.text=@"Do I need to have Internet/cell service to load coupons? ";
    sevTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    sevTxtView.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];    frame = sevTxtView.frame;
    [sevTxtView sizeToFit];
    sevTxtView.userInteractionEnabled=NO;
    sevTxtView.scrollEnabled=NO;
    
    UITextView *eightTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,sevTxtView.frame.size.height+sevTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 24)];
    eightTxtView.scrollEnabled=YES;
    eightTxtView.text=@"Yes, Wi-Fi or cell service is required to load the latest coupons. ";
    eightTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    eightTxtView.textColor=[UIColor lightGrayColor];
    [eightTxtView sizeToFit];
    eightTxtView.scrollEnabled=NO;
    eightTxtView.userInteractionEnabled=NO;
    
    UITextView *ninthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, eightTxtView.frame.size.height+eightTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 24)];
    ninthTxtView.scrollEnabled=YES;
    ninthTxtView.text=@"How do I use coupons on the AfriCoupon app?";
    ninthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    ninthTxtView.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    [ninthTxtView sizeToFit];
    ninthTxtView.scrollEnabled=NO;
    ninthTxtView.userInteractionEnabled=NO;
    
    UITextView *tenlthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, ninthTxtView.frame.size.height+ninthTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 40)];
    tenlthTxtView.scrollEnabled=YES;
    tenlthTxtView.text=[NSString stringWithFormat:@"To use coupons from the mobile app, all you need to do is show the cashier the offer you want to use and they will swipe the coupon directly from the screen of your mobile device to redeem your discount. No printing or clipping is ever required. "];
    tenlthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    tenlthTxtView.textColor=[UIColor lightGrayColor];
[tenlthTxtView sizeToFit];
    tenlthTxtView.scrollEnabled=NO;
    tenlthTxtView.userInteractionEnabled=NO;
    
    UITextView *elvTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, tenlthTxtView.frame.size.height+tenlthTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    elvTxtView.scrollEnabled=YES;
    elvTxtView.text=[NSString stringWithFormat:@"How often are your coupons updated? "];
    elvTxtView.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    elvTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [elvTxtView sizeToFit];
    elvTxtView.scrollEnabled=NO;
    elvTxtView.userInteractionEnabled=NO;
    
    UITextView *telwTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,  elvTxtView.frame.size.height+elvTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 40)];
    telwTxtView.scrollEnabled=YES;
    telwTxtView.text=[NSString stringWithFormat:@"Mobile coupons are updated daily to ensure you have access to the latest deals. This means some merchants may not appear on the app until they have new, valid coupons available."];
    telwTxtView.textColor=[UIColor lightGrayColor];
    [tenlthTxtView sizeToFit];
    telwTxtView.scrollEnabled=NO;
    telwTxtView.userInteractionEnabled=NO;
    telwTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];

    UITextView *ThirteenTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, telwTxtView.frame.size.height+telwTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    ThirteenTxtView.scrollEnabled=YES;
    ThirteenTxtView.text=[NSString stringWithFormat:@"How can I ‘Unlock’ mobile coupons in the app that are ‘Locked’?"];
    ThirteenTxtView.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    ThirteenTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [ThirdTxtView sizeToFit];
    ThirteenTxtView.scrollEnabled=NO;
    ThirteenTxtView.userInteractionEnabled=NO;
    
    UITextView *fourteenTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,  ThirteenTxtView.frame.size.height+ThirteenTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 100)];
    fourteenTxtView.scrollEnabled=YES;
    fourteenTxtView.text=[NSString stringWithFormat:@"UNLOCK & SAVE EVEN MORE!\nOnce you have downloaded the app from the Apple store you have access to free coupons and discounts at every listed merchant. You will also find ‘locked’ coupons at every merchant that gives you even more and additional discounts with a total value of hundreds of dollars!\r\nTO UNLOCK THESE COUPONS WE CHARGE YOU WITH A SMALL ONE TIME FEE OF $ 2.99* THAT WILL GIVE YOU ACCESS TO ALL LOCKED COUPONS FOR A PERIOD OF 12 MONTHS.\r\n  After 12 months your Africoupon app will show free and locked coupons again. You can unlock again as described above.\nUnlocking fee = $ 2.99* payable through (an) In-app purchase. "];
    fourteenTxtView.textColor=[UIColor lightGrayColor];
    fourteenTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    [fourthTxtView sizeToFit];
    fourteenTxtView.scrollEnabled=NO;
    fourteenTxtView.userInteractionEnabled=NO;
  
   
    UITextView *txtView15=[[UITextView alloc]initWithFrame:CGRectMake(10, fourteenTxtView.frame.size.height+fourteenTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    txtView15.scrollEnabled=YES;
    txtView15.text=[NSString stringWithFormat:@"Why can it take so long for coupons to load?"];
    txtView15.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    txtView15.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [txtView15 sizeToFit];
    txtView15.scrollEnabled=NO;
    txtView15.userInteractionEnabled=NO;
    
    UITextView *txtView16=[[UITextView alloc]initWithFrame:CGRectMake(10,  txtView15.frame.size.height+txtView15.frame.origin.y,unlockScrl.frame.size.width-20, 100)];
    txtView15.scrollEnabled=YES;
    txtView16.text=[NSString stringWithFormat:@"In most cases coupons load instantaneously. Loading time depends on a number of factors. The app will generally run faster if your device is connected to wireless Internet versus 3G or 4G service. This may also depend on the connection speeds offered by your wireless provider. Running multiple apps and the amount of available memory on your device can also impact the loading time for mobile coupons. "];
    txtView16.textColor=[UIColor lightGrayColor];
    txtView16.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    [txtView16 sizeToFit];
    txtView16.scrollEnabled=NO;
    txtView16.userInteractionEnabled=NO;
    
    
    UITextView *txtView17=[[UITextView alloc]initWithFrame:CGRectMake(10, txtView16.frame.size.height+txtView16.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    txtView17.scrollEnabled=YES;
    txtView17.text=[NSString stringWithFormat:@"Why did the app crash?"];
    txtView17.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    txtView17.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [txtView17 sizeToFit];
    txtView17.scrollEnabled=NO;
    txtView17.userInteractionEnabled=NO;
    
    UITextView *txtView18=[[UITextView alloc]initWithFrame:CGRectMake(10,  txtView17.frame.size.height+txtView17.frame.origin.y,unlockScrl.frame.size.width-20, 40)];
    txtView18.scrollEnabled=YES;
    txtView18.text=[NSString stringWithFormat:@"There are a number of reasons an app will crash ranging from issues with the app to issues with the device. They vary greatly, but uninstalling and reinstalling the app often resolves problems with crashing. "];
    txtView18.textColor=[UIColor lightGrayColor];
    [txtView18 sizeToFit];
    txtView18.scrollEnabled=NO;
    txtView18.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    txtView18.userInteractionEnabled=NO;


    UITextView *txtView20=[[UITextView alloc]initWithFrame:CGRectMake(10, txtView18.frame.size.height+txtView18.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    txtView20.scrollEnabled=YES;
    txtView20.text=[NSString stringWithFormat:@"Why do I have to sign up to use Africoupon?"];
    txtView20.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    txtView20.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [txtView20 sizeToFit];
    txtView20.scrollEnabled=NO;
    txtView20.userInteractionEnabled=NO;
    
    UITextView *txtView21=[[UITextView alloc]initWithFrame:CGRectMake(10,  txtView20.frame.size.height+txtView20.frame.origin.y,unlockScrl.frame.size.width-20, 50)];
    txtView21.scrollEnabled=YES;
    txtView21.text=[NSString stringWithFormat:@"Sign up is free and without obligation. Your sign up is only necessary to enable us to trace claimed coupons in case of any problem that you would encounter and to communicate with you via email. Also uses Africoupon (and only Africoupon) your email address when you sign up for our newsletter, with the latest and best discount coupons.  "];
    txtView21.textColor=[UIColor lightGrayColor];
    [txtView21 sizeToFit];
    txtView21.scrollEnabled=NO;
    txtView21.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    txtView21.userInteractionEnabled=NO;
   
    
    UITextView *txtView22=[[UITextView alloc]initWithFrame:CGRectMake(10, txtView21.frame.size.height+txtView21.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    txtView22.scrollEnabled=YES;
    txtView22.text=[NSString stringWithFormat:@"How can I get my business on Africoupon?"];
    txtView22.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    txtView22.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [txtView22 sizeToFit];
    txtView22.scrollEnabled=NO;
    txtView22.userInteractionEnabled=NO;
    
  
   
    UITextView *txtView23=[[UITextView alloc]initWithFrame:CGRectMake(10, txtView22.frame.size.height+txtView22.frame.origin.y+10,unlockScrl.frame.size.width-20, 25)];
    txtView23.scrollEnabled=YES;
    txtView23.text=[NSString stringWithFormat:@"Are there any terms and conditions for displayed coupons? "];
    txtView23.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    txtView23.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [txtView23 sizeToFit];
    txtView23.scrollEnabled=NO;
    txtView23.userInteractionEnabled=NO;
    
    UITextView *txtView24=[[UITextView alloc]initWithFrame:CGRectMake(10,  txtView23.frame.size.height+txtView23.frame.origin.y,unlockScrl.frame.size.width-20, 40)];
    txtView24.scrollEnabled=YES;
    txtView24.text=[NSString stringWithFormat:@"Yes, you'll find them under coupon details for every specific merchant and his offered coupons. Do read them carefully.  "];
    txtView24.textColor=[UIColor lightGrayColor];
    [txtView24 sizeToFit];
    txtView24.scrollEnabled=NO;
    txtView24.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    txtView24.userInteractionEnabled=NO;
   
    UITextView *txtView25=[[UITextView alloc]initWithFrame:CGRectMake(10, txtView24.frame.size.height+txtView24.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    txtView25.scrollEnabled=YES;
    txtView25.text=[NSString stringWithFormat:@"Are there any 'hidden conditions'? "];
    txtView25.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    txtView25.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
    [txtView25 sizeToFit];
    txtView25.scrollEnabled=NO;
    txtView25.userInteractionEnabled=NO;
    
    UITextView *txtView26=[[UITextView alloc]initWithFrame:CGRectMake(10,  txtView25.frame.size.height+txtView25.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
    txtView26.scrollEnabled=YES;
    txtView26.text=[NSString stringWithFormat:@"No what you see on the terms and conditions page is what you get.   "];
    txtView26.textColor=[UIColor lightGrayColor];
    [txtView26 sizeToFit];
    txtView26.scrollEnabled=NO;
    txtView26.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    txtView26.userInteractionEnabled=NO;

    [faqScroll addSubview:firstTxtView];
    [faqScroll addSubview:secondTxtView];
    [faqScroll addSubview:ThirdTxtView];
    [faqScroll addSubview:fourthTxtView];
    [faqScroll addSubview:fifthTxtView];
    [faqScroll addSubview:sixthTxtView];
    [faqScroll addSubview:sevTxtView];
    [faqScroll addSubview:eightTxtView];
    [faqScroll addSubview:ninthTxtView];
    [faqScroll addSubview:tenlthTxtView];
    [faqScroll addSubview:elvTxtView];
    [faqScroll addSubview:telwTxtView];
    [faqScroll addSubview:ThirteenTxtView];
    [faqScroll addSubview:fourteenTxtView];
    [faqScroll addSubview:txtView15];
    [faqScroll addSubview:txtView16];
    [faqScroll addSubview:txtView17];
    [faqScroll addSubview:txtView18];
    [faqScroll addSubview:txtView20];
    [faqScroll addSubview:txtView21];
    [faqScroll addSubview:txtView22];
    [faqScroll addSubview:txtView23];
    [faqScroll addSubview:txtView24];
    [faqScroll addSubview:txtView25];
    [faqScroll addSubview:txtView26];
    faqScroll.contentSize=CGSizeMake(self.view.frame.size.width, txtView26.frame.size.height+txtView26.frame.origin.y+20);
 
}
-(void)unlockView
{
    UITextView *firstTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,-5,unlockScrl.frame.size.width-20, 70)];
    firstTxtView.text=@"Once you have downloaded the app from the Apple store you have access to free coupons and discounts at every listed merchant.You will also find 'locke' coupons at every merchant that gives you even more and additional discounts with a total value of hundreds of dollars!";
    firstTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    firstTxtView.textColor=[UIColor blackColor];
    frame = firstTxtView.frame;
    frame.size.height = firstTxtView.contentSize.height;
    firstTxtView.frame = frame;
    firstTxtView.scrollEnabled=NO;
    firstTxtView.userInteractionEnabled=NO;
    
    UITextView *secondTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,firstTxtView.frame.size.height+firstTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 55)];
    secondTxtView.text=@"TO UNLOCK THESE COUPONS WE CHARGE WITH YOU SMALL ONE TIME FEE OF $2.99* THAT WILL GIVE YOU ACCESS TO ALL LOCKED COUPONS FOR A PERIOD OF 12 MONTHS.";
    secondTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15.0];
    secondTxtView.textColor=[UIColor lightGrayColor];
    secondTxtView.scrollEnabled=NO;
    secondTxtView.userInteractionEnabled=NO;
    
    UITextView *ThirdTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, secondTxtView.frame.size.height+secondTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 50)];
    ThirdTxtView.text=@"After 12 months your Africoupon app will show free and locked coupons again.You can unlock again as described above.";
    ThirdTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    ThirdTxtView.textColor=[UIColor lightGrayColor];
    ThirdTxtView.scrollEnabled=NO;
    ThirdTxtView.userInteractionEnabled=NO;

    UITextView *fourthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, ThirdTxtView.frame.size.height+ThirdTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 120)];
    fourthTxtView.text=[NSString stringWithFormat:@"Unlocking fee = $2.99\n\npayable through (an) In-app purchase\n\n"];
    fourthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.0];
    fourthTxtView.textColor=[UIColor lightGrayColor];
    fourthTxtView.scrollEnabled=NO;
    fourthTxtView.userInteractionEnabled=NO;

    UITextView *fifthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, fourthTxtView.frame.size.height+fourthTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 25)];
  //  fifthTxtView.text=[NSString stringWithFormat:@"You can also pay through our website"];
    fifthTxtView.textColor=[UIColor redColor];
    fifthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
    fifthTxtView.scrollEnabled=NO;
    fifthTxtView.userInteractionEnabled=NO;

    UITextView *sixthTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,  fifthTxtView.frame.size.height+fifthTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 100)];
  //  sixthTxtView.text=[NSString stringWithFormat:@"-with PayPal\n\n-or with Africell Mobile credits\n\n(only for Gambia - coming soon)"];
    sixthTxtView.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
    sixthTxtView.scrollEnabled=NO;
    sixthTxtView.userInteractionEnabled=NO;
    sixthTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];

    [unlockScrl addSubview:firstTxtView];
    [unlockScrl addSubview:secondTxtView];
    [unlockScrl addSubview:ThirdTxtView];
    [unlockScrl addSubview:fourthTxtView];
    [unlockScrl addSubview:fifthTxtView];
    [unlockScrl addSubview:sixthTxtView];
    unlockScrl.contentSize=CGSizeMake(self.view.frame.size.width, sixthTxtView.frame.size.height+sixthTxtView.frame.origin.y+20);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DROPCELLlTableViewCell *cell=(DROPCELLlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell ==nil)
    {
        cell=[[DROPCELLlTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSMutableDictionary *dict=[categoryArr objectAtIndex:indexPath.row];
    NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",[dict objectForKey:@"cat_image"]]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *imageCache = [[SDImageCache alloc] initWithNamespace:@"myNamespace"];
    NSString *myCacheKey=[dict objectForKey:@"cat_image"];
    [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
        if(image !=nil)
        {
            cell.categoryImgView.image=image;
        }
        else
        {
            [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [imageCache  storeImage:image forKey:[dict objectForKey:@"cat_image"]];
                cell.categoryImgView.image=image;
                
            }];
        }
    }];

    cell.titleLbl.frame=CGRectMake(0, cell.frame.size.height/2-20, self.view.frame.size.width,40);
    cell.categoryImgView.frame=CGRectMake(0, 0, self.view.frame.size.width, 100);
    cell.categoryImgView.alpha=0.7;
    cell.titleLbl.text=[dict objectForKey:@"category_name"];
    cell.seprator.frame=CGRectMake(0, 97, self.view.frame.size.width, 3);
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

    CategorySearchViewController *cat=[self.storyboard instantiateViewControllerWithIdentifier:@"CategorySearchViewController"];
    NSMutableDictionary *dict=[categoryArr objectAtIndex:indexPath.row];
    NSString *cat_name=[dict objectForKey:@"category_name"];
    [[NSUserDefaults standardUserDefaults]setObject:cat_name forKey:@"selectedCategory"];
            [self.navigationController pushViewController:cat animated:YES];
   // [self presentViewController:cat animated:YES completion:nil];
            [SVProgressHUD dismiss];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back :(id)sender
{
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - UIWebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
  
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
