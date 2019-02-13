    //
//  TAbInfoClassViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 19/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "TAbInfoClassViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Helper.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "Login.h"
#import "RegistrationViewController.h"
#define WIDTH self.view.frame.size.width 

@interface TAbInfoClassViewController ()
{
    NSInteger user_id;

    UIView *tabBarView;
    UIButton *DetailedBtn;
    UIButton *MapViewBtn;
    UIButton *OurCouponBtn;
    NSInteger couponID;
    CGRect frame;
    NSTimer  *myTimer;
    NSMutableArray *arrImage;
    NSMutableArray *arrOpeningTime;
    NSOperationQueue  *operationQueue;
    int imageCount;
    NSMutableArray *coupons;
    NSMutableDictionary *getDict;
    NSInteger val;
    NSMutableArray *couponDetailArr;
    UIView *view;
    SDImageCache *imageCache;
    SDWebImageManager *manager;
    NSString *myCacheKey;
    NSInteger valueType;
    UIView *dot;

}
@end

@implementation TAbInfoClassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    valueType=0;
    manager = [SDWebImageManager sharedManager];
    
    
    NSLog(@"%@", coupons);
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"dict"]);
    coupons = [[NSUserDefaults standardUserDefaults] objectForKey:@"dict"];
    
    NSLog(@"%@", getDict);
    
    if ([coupons isKindOfClass:[NSMutableDictionary class]]) {
        
        getDict = (NSMutableDictionary *)coupons;
        
    } else {
        
        getDict = [coupons objectAtIndex:0];
        
    }
    
    couponID =[[getDict objectForKey:@"id"] integerValue];
    
    user_id = [[NSUserDefaults standardUserDefaults] integerForKey:@"user_id"];
    arrImage = [[NSMutableArray alloc] init];
    couponDetailArr = [[NSMutableArray alloc] init];
    imageCache = [[SDImageCache alloc] initWithNamespace:@"myNamespace"];
    self.navigationItem.titleView = titleLbl;
    
    phoneGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(calling:)];
    websiteGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSafari:)];
    merchant_category.frame = CGRectMake(0, 64, WIDTH, 40);
    merchant_category.text = [getDict valueForKey:@"merchant_category"];
    [TopScrll bringSubviewToFront:merchant_category];
    
    [self createTabBarView];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(void)createTabBarView{
    
    tabBarView=[[UIView alloc]initWithFrame:CGRectMake(0,  self.view.frame.size.height-70,  self.view.frame.size.width, 70)];
    UIView *OurCouponView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width*1/3, 70)];
    OurCouponBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    OurCouponBtn.backgroundColor=[UIColor lightGrayColor];
    OurCouponBtn.frame=CGRectMake(0, 0,  self.view.frame.size.width*1/3, 70);
    [OurCouponBtn addTarget:self action:@selector(ourCoupon:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(OurCouponView.frame.size.width/2-15,5, 30, 30)];
    logoImage.image=[UIImage imageNamed:@"barcode"];
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40,OurCouponView.frame.size.width, 40)];
    detailLabel.text=@"OUR COUPONS";
    detailLabel.textAlignment=NSTextAlignmentCenter;
    detailLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    UIView *seprator=[[UIView alloc]initWithFrame:CGRectMake(OurCouponView.frame.size.width+OurCouponView.frame.origin.x-1, 0,  1, 70)];
    seprator.backgroundColor=[UIColor blackColor];
    [OurCouponView addSubview:OurCouponBtn];
    [OurCouponView addSubview:seprator];
    [OurCouponView addSubview:logoImage];
    [OurCouponView addSubview:detailLabel];
    [tabBarView addSubview:OurCouponView];
    
    UIView *Detailed=[[UIView alloc]initWithFrame:CGRectMake(OurCouponView.frame.origin.x+OurCouponView.frame.size.width, 0,  self.view.frame.size.width*1/3, 70)];
    DetailedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    DetailedBtn.backgroundColor=[UIColor lightGrayColor];
    DetailedBtn.frame=CGRectMake(0, 0,  self.view.frame.size.width*1/3, 70);
    [DetailedBtn addTarget:self action:@selector(DetailedBtn:) forControlEvents:UIControlEventTouchUpInside];
    DetailedBtn.tag=1;
    UIImageView *logoImage1=[[UIImageView alloc]initWithFrame:CGRectMake(Detailed.frame.size.width/2-15,5, 30, 30)];
    logoImage1.image=[UIImage imageNamed:@"barcode"];
    UILabel *detailLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, 40,OurCouponView.frame.size.width, 40)];
    detailLabel1.text=@"DETAILED INFO";
    detailLabel1.textAlignment=NSTextAlignmentCenter;
    detailLabel1.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    UIView *seprator1=[[UIView alloc]initWithFrame:CGRectMake(Detailed.frame.size.width-1, 0,  1, 70)];
    seprator1.backgroundColor=[UIColor blackColor];
    [Detailed addSubview:DetailedBtn];
    [Detailed addSubview:seprator1];
    [Detailed addSubview:logoImage1];
    [Detailed addSubview:detailLabel1];
    [tabBarView addSubview:Detailed];
    
    UIView *MapView=[[UIView alloc]initWithFrame:CGRectMake(Detailed.frame.origin.x+Detailed.frame.size.width, 0,  self.view.frame.size.width*1/3, 70)];
    MapViewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    MapViewBtn.backgroundColor=[UIColor lightGrayColor];
    
    MapViewBtn.frame=CGRectMake(0, 0,  self.view.frame.size.width*1/3, 70);
    MapViewBtn.tag=1;
    [MapViewBtn addTarget:self action:@selector(MapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *logoImage11=[[UIImageView alloc]initWithFrame:CGRectMake(MapView.frame.size.width/2-15,5, 30, 30)];
    logoImage11.image=[UIImage imageNamed:@"barcode"];
    UILabel *detailLabel11=[[UILabel alloc]initWithFrame:CGRectMake(0, 40,OurCouponView.frame.size.width, 40)];
    detailLabel11.text=@"MAP";
    detailLabel11.textAlignment=NSTextAlignmentCenter;
    detailLabel11.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [MapView addSubview:MapViewBtn];
    [MapView addSubview:logoImage11];
    [MapView addSubview:detailLabel11];
    [tabBarView addSubview:MapView];
    [self.view addSubview:tabBarView];
}
-(void)viewWillAppear:(BOOL)animated
{
    couponDetailArr=[Helper CouponDetails:couponID];
   
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"CouponLocked"] ==true )
    {
        //CouponView
        val=2;
        ourCouponView.hidden =NO;
        couponDetailView.hidden =YES;
        mapkitView.hidden = YES;
        OurCouponBtn.backgroundColor=[UIColor colorWithRed:(239 / 255.0) green:(239 / 255.0) blue:(244 / 255.0) alpha:1.0];
            }
    else
    {
        //Info View
        val=1;
        
        ourCouponView.hidden =YES;
        couponDetailView.hidden =NO;
        mapkitView.hidden = YES;
        DetailedBtn.backgroundColor=[UIColor colorWithRed:(239 / 255.0) green:(239 / 255.0) blue:(244 / 255.0) alpha:1.0];
              //  DetailedBtn.backgroundColor=[UIColor lightGrayColor];
       
    }
    dispatch_queue_t queue11 = dispatch_queue_create("com.example.MyQueue11", NULL);
    dispatch_async(queue11, ^{
        [self Call];
    });

    [self InfoView];
    [self CouponView:getDict];
////
    [self layoutSubView:val];

}
-(void)viewWillDisappear:(BOOL)animatedggfhg
{
    val=1;
    [self layoutSubView:val];
    [couponDetailView.layer removeAllAnimations];
    [arrImage removeAllObjects];
    OpenTimesTxtview.text=@"";
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)layoutSubView:(NSInteger)values
{
    TopScrll.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-70);
    
    ourCouponView.frame =CGRectMake(0, 64, WIDTH, TopScrll.frame.size.height-64);
    couponDetailView.frame =CGRectMake(0, 64, WIDTH, TopScrll.frame.size.height-64);
    mapkitView.frame =CGRectMake(0, 64, WIDTH, TopScrll.frame.size.height-54);
 
    // NAVIGATION VIEW
  //  NavView.frame=CGRectMake(0, 0, self.view.frame.size.width, 64);
    titleLbl.frame=CGRectMake(self.view.frame.size.width/2-105,23, 210,35);
   // back.frame=CGRectMake(10,23, 40,40);
    titleLbl.text=[getDict valueForKey:@"merchant_name"];
    titleLbl.minimumScaleFactor=0.5;
    UIButton *star=[UIButton buttonWithType:UIButtonTypeCustom];
    [star setFrame:CGRectMake(self.view.frame.size.width-30,23,25,20)];
    
    if([[getDict objectForKey:@"fav"]intValue] == 0)
    {
        [star setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal ];
    }
    else
    {
        [ star setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal ];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:star];
    
   // [NavView addSubview:star];
    
    // OUR COUPON TIME
    logoImg.frame=CGRectMake(0,0, self.view.frame.size.width, 250);
    
    couponTitle.frame=CGRectMake(10,logoImg.frame.size.height+logoImg.frame.origin.y, self.view.frame.size.width-20, 20);
    couponTitle.minimumScaleFactor=0.5;
    
    CouponImgview.frame=CGRectMake(10,couponTitle.frame.size.height+couponTitle.frame.origin.y+10, self.view.frame.size.width-20, 80);
    CouponImgview.layer.cornerRadius = 10;
    CouponImgview.layer.borderWidth = 1.0;
    CouponImgview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    CouponImgview.clipsToBounds = YES;
    CouponImgview.layer.masksToBounds=YES;
    
    couponDetail.frame=CGRectMake(10,logoImg.frame.size.height+logoImg.frame.origin.y+120, self.view.frame.size.width-20, 25);
    couponDetail.minimumScaleFactor=0.5;
    
    couponExp.frame=CGRectMake(7,couponDetail.frame.origin.y+couponDetail.frame.size.height, self.view.frame.size.width-20, 15);
    [couponExp sizeToFit];
    couponExp.userInteractionEnabled=NO;
    couponExp.scrollEnabled=NO;
    for(int i = 0 ; i <= WIDTH/5 ; i ++){
        dot = [[UIView alloc]initWithFrame:CGRectMake(i*5+10, couponExp.frame.origin.y+couponExp.frame.size.height+10, 3, 3)];
        dot.backgroundColor = [UIColor greenColor];
        if (dot.frame.origin.x > WIDTH-10) {
            
        }else{
        [ourCouponView addSubview:dot];
        }
    }
    
    if (coupons.count >1) {
        
        couponTitle2.frame =CGRectMake(10, couponExp.frame.origin.y+couponExp.frame.size.height+20, WIDTH-20, 20);
        couponTitle2.minimumScaleFactor=0.5;
        
        CouponImgview2.frame=CGRectMake(10,couponTitle2.frame.size.height+couponTitle2.frame.origin.y+10, self.view.frame.size.width-20, 80);
        CouponImgview2.layer.cornerRadius = 10;
        CouponImgview2.layer.borderWidth = 1.0;
        CouponImgview2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        CouponImgview2.clipsToBounds = YES;
        CouponImgview2.layer.masksToBounds=YES;
        
        couponDetail2.frame=CGRectMake(10,CouponImgview2.frame.size.height+CouponImgview2.frame.origin.y+10, self.view.frame.size.width-20, 25);
        couponDetail2.minimumScaleFactor=0.5;
        couponDetail2.font = [UIFont boldSystemFontOfSize:16.0];
        couponDetail2.textColor =[UIColor blackColor];
        
        couponExp2.frame=CGRectMake(7,couponDetail2.frame.origin.y+couponDetail2.frame.size.height, self.view.frame.size.width-20, 15);
        [couponExp2 sizeToFit];
        couponExp2.userInteractionEnabled=NO;
        couponExp2.scrollEnabled=NO;
        for(int i = 0 ; i <= WIDTH/5 ; i ++){
            dot = [[UIView alloc]initWithFrame:CGRectMake(i*5+10, couponExp2.frame.origin.y+couponExp2.frame.size.height+10, 3, 3)];
            dot.backgroundColor = [UIColor greenColor];
            if (dot.frame.origin.x > WIDTH-10) {
                
            }else{
                [ourCouponView addSubview:dot];
            }
        }

        }
    if (coupons.count >2) {
        
        couponTitle3.frame =CGRectMake(10, couponExp2.frame.origin.y+couponExp2.frame.size.height+20, WIDTH-20, 20);
        couponTitle3.minimumScaleFactor=0.5;
        
        CouponImgview3.frame=CGRectMake(10,couponTitle3.frame.size.height+couponTitle3.frame.origin.y+10, self.view.frame.size.width-20, 80);
        CouponImgview3.layer.cornerRadius = 10;
        CouponImgview3.layer.borderWidth = 1.0;
        CouponImgview3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        CouponImgview3.clipsToBounds = YES;
        CouponImgview3.layer.masksToBounds=YES;
        
        couponDetail3.frame=CGRectMake(10,CouponImgview3.frame.size.height+CouponImgview3.frame.origin.y+10, self.view.frame.size.width-20, 25);
        couponDetail3.minimumScaleFactor=0.5;
        couponDetail3.font = [UIFont boldSystemFontOfSize:16.0];
        couponDetail3.textColor =[UIColor blackColor];
        
        couponExp3.frame=CGRectMake(7,couponDetail3.frame.origin.y+couponDetail3.frame.size.height, self.view.frame.size.width-20, 15);
        [couponExp3 sizeToFit];
        couponExp3.userInteractionEnabled=NO;
        couponExp3.scrollEnabled=NO;
        for(int i = 0 ; i <= WIDTH/5 ; i ++){
            dot = [[UIView alloc]initWithFrame:CGRectMake(i*5+10, couponExp3.frame.origin.y+couponExp3.frame.size.height+10, 3, 3)];
            dot.backgroundColor = [UIColor greenColor];
            if (dot.frame.origin.x > WIDTH-10) {
                
            }else{
                [ourCouponView addSubview:dot];
            }
        }
        
    }

    // DETAILS INFO
    logoImg1.frame=CGRectMake(0,0, self.view.frame.size.width, 250);
    logoImg2.frame=CGRectMake(0,0, self.view.frame.size.width, 250);

    merchantNameLabel.frame = CGRectMake(8,logoImg2.frame.size.height, WIDTH-20, 30);
    merchantNameLabel.text =[getDict valueForKey:@"merchant_name"];
    
    website.frame =CGRectMake(10, merchantNameLabel.frame.size.height+merchantNameLabel.frame.origin.y, WIDTH-20, 15);
    
    phone.frame =CGRectMake(10, website.frame.size.height+website.frame.origin.y+5, WIDTH/3, 15);
    
    detailTxt.frame=CGRectMake(6,phone.frame.size.height+phone.frame.origin.y, self.view.frame.size.width-20, 40);
    detailTxt.scrollEnabled=YES;
//    frame = detailTxt.frame;
//    frame.size.height = detailTxt.contentSize.height;
//    detailTxt.frame = frame;
    [detailTxt sizeToFit];

    detailTxt.scrollEnabled=NO;
    detailTxt.userInteractionEnabled=NO;
    
    addressText.frame = CGRectMake(10, detailTxt.frame.origin.y+detailTxt.frame.size.height+10, 120, 20);
    address.frame =CGRectMake(10, addressText.frame.origin.y+addressText.frame.size.height, WIDTH, 20);
    
    OpenTimes.frame=CGRectMake(10,address.frame.size.height+address.frame.origin.y+10, self.view.frame.size.width-20, 20);
    OpenTimes.minimumScaleFactor=0.5;
    
    OpenTimesTxtview.frame=CGRectMake(10,OpenTimes.frame.size.height+OpenTimes.frame.origin.y, self.view.frame.size.width-20, 35);
    frame = OpenTimesTxtview.frame;
    frame.size.height = OpenTimesTxtview.contentSize.height;
    OpenTimesTxtview.frame = frame;
    
    OpenTimesTxtview.scrollEnabled=NO;
    OpenTimesTxtview.userInteractionEnabled=NO;

    // MAP VIEW
    self.mapView.frame=CGRectMake(0, 64, TopScrll.frame.size.width,self.view.frame.size.height-54);
        TopScrll.scrollEnabled=YES;
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"CouponLocked"] ==true )
    {
        //CouponView
    
    TopScrll.contentSize=CGSizeMake(self.view.frame.size.width,dot.frame.size.height+dot.frame.origin.y+70);
        ourCouponView.frame =CGRectMake(0, 64, WIDTH, TopScrll.contentSize.height-64);

//        if (coupons.count>1) {
//            TopScrll.contentSize=CGSizeMake(self.view.frame.size.width,couponExp2.frame.size.height+couponExp2.frame.origin.y+85);
//
//        }
    }else{
    TopScrll.contentSize=CGSizeMake(self.view.frame.size.width,OpenTimesTxtview.frame.size.height+OpenTimesTxtview.frame.origin.y+65);
    }
    

}

// create coupon view
-(void)CouponView:(NSMutableDictionary *)dict1
{
    if(couponDetailArr.count)
    {
        NSMutableDictionary *dict111 = [couponDetailArr objectAtIndex:0];
        NSInteger merchnID = [[dict111 objectForKey:@"fk_merchant_id"] integerValue];
        CouponImgview.frame=CGRectMake(10,couponTitle.frame.size.height+couponTitle.frame.origin.y+10, self.view.frame.size.width-20, 80);
        CouponImgview.tag =[[dict111 valueForKey:@"id"]integerValue];
        arrOpeningTime= [[Helper MerchantOpeningClosingTime:merchnID]mutableCopy];
        
        NSMutableArray *CouponSlidingImagesArr=[Helper CouponSlidingImages:couponID];
        
        [self getSlidingImage:CouponSlidingImagesArr];
        
        NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",[dict1 objectForKey:@"coupon_image"]]];
        NSRange range = [[dict1 objectForKey:@"coupon_image"] rangeOfString:@"."];
        NSString *newString = [[dict1 objectForKey:@"coupon_image"] substringToIndex:range.location];
        myCacheKey=[NSString stringWithFormat:@"%@.png",newString];
        //        [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
        //            if(image !=nil)
        //            {
        //                logoImg.image=image;
        //            }
        //            else
        //            {
        [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [imageCache  storeImage:image forKey:myCacheKey];
            logoImg.image=image;
        }];
        // }
        // }];
        
        titleLbl.text=[dict111 objectForKey:@"merchant_name"];
        //CategoryLbl.text=[dict111 objectForKey:@"category"];
        couponTitle.text=[dict111 objectForKey:@"title"];
        couponTitle.textColor=[UIColor redColor];
        couponTitle.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
        couponDetail.text=@"Coupon details";
        couponDetail.textColor=[UIColor blackColor];
        
        NSString *type=[dict111 objectForKey:@"type"];
        NSLog(@"lool %@",type);
        if (![[NSUserDefaults standardUserDefaults]boolForKey:@"usertype"]) {
            type = @"free";
        }else{
            type=[dict111 objectForKey:@"type"];
        }
        
        if([type isEqualToString:@"premium"])
        {
            
            UIFont *font =[UIFont systemFontOfSize:14];
            UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
            NSDictionary *dict1 = @ {NSFontAttributeName :font};
            NSDictionary *dict2 = @ {NSFontAttributeName :boldFont};
            
            NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ \n\u2022 Coupon expires on:",[dict111 valueForKey:@"details"]] attributes:dict1];
            
            NSMutableAttributedString *attributString1 = [[NSMutableAttributedString alloc]initWithString:[dict111 valueForKey:@"exp"] attributes:dict2];
            
            [attributString appendAttributedString:attributString1];
            couponExp.attributedText = attributString;
            // couponExp.text=[NSString stringWithFormat:@"\n\u2022 Coupon expires on: %@",[dict111 objectForKey:@"exp"]];
            
            CouponImgview.backgroundColor=[UIColor colorWithRed:234.0/255 green:158.0/255 blue:43.0/255 alpha:1.0];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 150, 25)];
            titleLabel.text = @"LOCKED COUPON";
            titleLabel.textColor = [UIColor redColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:17];
            
            
            UIImageView *lockImage =[[UIImageView alloc]initWithFrame:CGRectMake(3, CouponImgview.frame.size.height/2+5, 25, 30)];
            lockImage.image=[UIImage imageNamed:@"lock"];
            
            UILabel *redeemLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, CouponImgview.frame.size.height/2+10, 100, 17)];
            redeemLabel1.text = @"REDEEM NOW";
            redeemLabel1.textColor = [UIColor whiteColor];
            redeemLabel1.font =[UIFont boldSystemFontOfSize:14];
            
            UIImageView *barcodeImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, 10, 25, CouponImgview.frame.size.height-20)];
            barcodeImage.image=[UIImage imageNamed:@"h_barcode_w"];
            
            
            UILabel *redeemLabel = [[UILabel alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, CouponImgview.frame.size.height/2+15, 75, 15)];
            redeemLabel.text = @"REDEEM NOW";
            redeemLabel.textColor = [UIColor grayColor];
            redeemLabel.font =[UIFont systemFontOfSize:10];
            
            UIImageView *slideImage =[[UIImageView alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
            slideImage.image=[UIImage imageNamed:@"hand lock"];
            [UIView animateWithDuration:2.5f
                                  delay:0.0f
                                options:UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [slideImage setFrame:CGRectMake(CouponImgview.frame.size.width-slideImage.frame.size.width, 10, 30, 35)];
                             }
                             completion:^(BOOL finished)
             {
                 // Top right to bottom right
                 [UIView animateWithDuration:.0f
                                  animations:^{
                                      [slideImage setFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
                                  }
                                  completion:nil];
             }];
            
            UISwipeGestureRecognizer *lockGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(lockgesture:)];
            lockGesture.direction= UISwipeGestureRecognizerDirectionRight;
            
            [CouponImgview addSubview:titleLabel];
            [CouponImgview addSubview:lockImage];
            [CouponImgview addSubview:redeemLabel1];
            
            [CouponImgview addSubview:barcodeImage];
            [CouponImgview addSubview:redeemLabel];
            [CouponImgview addSubview:slideImage];
            [CouponImgview addGestureRecognizer:lockGesture];
            
        }
        else if([type isEqualToString:@"free"])
        {
            
            UIFont *font =[UIFont systemFontOfSize:14];
            UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
            NSDictionary *dict1 = @ {NSFontAttributeName :font};
            NSDictionary *dict2 = @ {NSFontAttributeName :boldFont};
            
            NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ \n\u2022 Coupon expires on:",[dict111 valueForKey:@"details"]] attributes:dict1];
            
            NSMutableAttributedString *attributString1 = [[NSMutableAttributedString alloc]initWithString:[dict111 valueForKey:@"exp"] attributes:dict2];
            
            [attributString appendAttributedString:attributString1];
            couponExp.attributedText = attributString;
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 150, 25)];
            titleLabel.text = @"YOUR COUPON";
            titleLabel.textColor = [UIColor colorWithRed:(203.0 / 255.0) green:(15.0 / 255.0) blue:(34.0 / 255.0) alpha:1.0];
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            
            UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, CouponImgview.frame.size.height/2+10, 60, 17)];
            showLabel.text = [NSString stringWithFormat:@"SHOW >"];
            showLabel.textColor = [UIColor grayColor];
            showLabel.font =[UIFont boldSystemFontOfSize:14];
            
            UILabel *swipeLabel = [[UILabel alloc]initWithFrame:CGRectMake(showLabel.frame.size.width+showLabel.frame.origin.x+2, CouponImgview.frame.size.height/2+10, 50, 17)];
            
            swipeLabel.text = @"SWIPE";
            swipeLabel.textColor = [UIColor grayColor];
            swipeLabel.font =[UIFont boldSystemFontOfSize:14];
            //swipeLabel.backgroundColor =[UIColor whiteColor];
            
            UILabel *secondArrow =[[UILabel alloc]initWithFrame:CGRectMake(swipeLabel.frame.size.width+swipeLabel.frame.origin.x-1, CouponImgview.frame.size.height/2+10, 60, 17)];
            secondArrow.text = @"> SAVE!";
            secondArrow.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(150.0 / 255.0) blue:(56.0 / 255.0) alpha:1.0];
            secondArrow.font =[UIFont boldSystemFontOfSize:14];
            
            
            UIImageView *barcodeImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, 10, 25, CouponImgview.frame.size.height-20)];
            barcodeImage.image=[UIImage imageNamed:@"h_barcode_w"];
            
            UILabel *redeemLabel = [[UILabel alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, CouponImgview.frame.size.height/2+15, 75, 15)];
            redeemLabel.text = @"REDEEM NOW";
            redeemLabel.textColor = [UIColor grayColor];
            redeemLabel.font =[UIFont systemFontOfSize:10];
            
            UIImageView *slideImage =[[UIImageView alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
            slideImage.image=[UIImage imageNamed:@"hand Free"];
            [UIView animateWithDuration:2.5f
                                  delay:0.0f
                                options:UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [slideImage setFrame:CGRectMake(CouponImgview.frame.size.width-slideImage.frame.size.width, 10, 30, 35)];
                             }
                             completion:^(BOOL finished)
             {
                 // Top right to bottom right
                 [UIView animateWithDuration:.0f
                                  animations:^{
                                      [slideImage setFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
                                  }
                                  completion:nil];
             }];
            UISwipeGestureRecognizer *freeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(freegesture:)];
            freeGesture.direction= UISwipeGestureRecognizerDirectionRight;
            // CouponImgview.tag=4000;
            [CouponImgview addSubview:titleLabel];
            [CouponImgview addSubview:showLabel];
            [CouponImgview addSubview:swipeLabel];
            [CouponImgview addSubview:secondArrow];
            [CouponImgview addSubview:barcodeImage];
            [CouponImgview addSubview:redeemLabel];
            [CouponImgview addSubview:slideImage];
            [CouponImgview addGestureRecognizer:freeGesture];
        }
    }
    if (coupons.count > 1) {
        
        NSDictionary *dictt;
        
        if ([coupons isKindOfClass:[NSMutableDictionary class]]) {
            
            dictt = (NSMutableDictionary *)coupons;
            
        } else {
            
            dictt = [coupons objectAtIndex:1];
            
        }
        
        NSInteger secondCouponID = [[dictt objectForKey:@"id"]integerValue];
        NSMutableArray *secondcoupon = [Helper CouponDetails:secondCouponID];
        if (secondcoupon.count) {
            [self createCouponView:secondcoupon];
        }
    }

    if (coupons.count > 2) {
        
        NSDictionary *dictt;
        
        if ([coupons isKindOfClass:[NSMutableDictionary class]]) {
            
            dictt = (NSMutableDictionary *)coupons;
            
        } else {
            
            dictt = [coupons objectAtIndex:2];
            
        }
        
        NSInteger secondCouponID=[[dictt objectForKey:@"id"]integerValue];
        
        NSMutableArray *secondcoupon = [Helper CouponDetails:secondCouponID];
        
        if (secondcoupon.count) {
            [self createCouponView1:secondcoupon];
        }
    }
}

-(void)createCouponView:(NSMutableArray *)array{
    
    NSMutableDictionary *dict111=[array objectAtIndex:0];
    CouponImgview2 =[[UIImageView alloc]init];
    CouponImgview2.frame=CGRectMake(10,couponTitle.frame.size.height+couponTitle.frame.origin.y+10, self.view.frame.size.width-20, 80);
    CouponImgview2.userInteractionEnabled = YES;
    CouponImgview2.tag =[[dict111 valueForKey:@"id"]integerValue];

    couponTitle2 = [[UILabel alloc]init];
    couponTitle2.text=[dict111 objectForKey:@"title"];
    couponTitle2.textColor=[UIColor redColor];
    couponTitle2.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
    
    couponDetail2 = [[UILabel alloc]init];
    couponDetail2.text=@"Coupon details";
    couponDetail2.textColor=[UIColor blackColor];
    couponExp2 = [[UITextView alloc]init];
    NSString *type=[dict111 objectForKey:@"type"];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"usertype"]) {
        type = @"free";
    }else{
        type=[dict111 objectForKey:@"type"];
    }
    if([type isEqualToString:@"premium"])
    {
        UIFont *font =[UIFont systemFontOfSize:14];
        UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
        NSDictionary *dict1 = @ {NSFontAttributeName :font};
        NSDictionary *dict2 = @ {NSFontAttributeName :boldFont};
        
        NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ \n\u2022 Coupon expires on:",[dict111 valueForKey:@"details"]] attributes:dict1];
        
        NSMutableAttributedString *attributString1 = [[NSMutableAttributedString alloc]initWithString:[dict111 valueForKey:@"exp"] attributes:dict2];
        
        [attributString appendAttributedString:attributString1];
        couponExp2.attributedText = attributString;
        // couponExp.text=[NSString stringWithFormat:@"\n\u2022 Coupon expires on: %@",[dict111 objectForKey:@"exp"]];
        
        CouponImgview2.backgroundColor=[UIColor colorWithRed:234.0/255 green:158.0/255 blue:43.0/255 alpha:1.0];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 150, 25)];
        titleLabel.text = @"LOCKED COUPON";
        titleLabel.textColor = [UIColor redColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        
        UIImageView *lockImage =[[UIImageView alloc]initWithFrame:CGRectMake(3, CouponImgview2.frame.size.height/2+5, 25, 30)];
        lockImage.image=[UIImage imageNamed:@"lock"];
        
        UILabel *redeemLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, CouponImgview2.frame.size.height/2+10, 100, 17)];
        redeemLabel1.text = @"REDEEM NOW";
        redeemLabel1.textColor = [UIColor whiteColor];
        redeemLabel1.font =[UIFont boldSystemFontOfSize:14];
        
        UIImageView *barcodeImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, 10, 25, CouponImgview2.frame.size.height-20)];
        barcodeImage.image=[UIImage imageNamed:@"h_barcode_w"];
        
        
        UILabel *redeemLabel = [[UILabel alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, CouponImgview2.frame.size.height/2+15, 75, 15)];
        redeemLabel.text = @"REDEEM NOW";
        redeemLabel.textColor = [UIColor grayColor];
        redeemLabel.font =[UIFont systemFontOfSize:10];
        
        UIImageView *slideImage =[[UIImageView alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
        slideImage.image=[UIImage imageNamed:@"hand lock"];
        slideImage.userInteractionEnabled = YES;
        [UIView animateWithDuration:2.5f
                              delay:0.0f
                            options:UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [slideImage setFrame:CGRectMake(CouponImgview2.frame.size.width-slideImage.frame.size.width, 10, 30, 35)];
                         }
                         completion:^(BOOL finished)
         {
             // Top right to bottom right
             [UIView animateWithDuration:.0f
                              animations:^{
                                  [slideImage setFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
                              }
                              completion:nil];
         }];
        
        UISwipeGestureRecognizer *lockGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(lockgesture:)];
        lockGesture.direction= UISwipeGestureRecognizerDirectionRight;
        
        [CouponImgview2 addSubview:titleLabel];
        [CouponImgview2 addSubview:lockImage];
        [CouponImgview2 addSubview:redeemLabel1];
        
        [CouponImgview2 addSubview:barcodeImage];
        [CouponImgview2 addSubview:redeemLabel];
        [CouponImgview2 addSubview:slideImage];
        [slideImage addGestureRecognizer:lockGesture];
        [CouponImgview2 addGestureRecognizer:lockGesture];
        
    }
    else if([type isEqualToString:@"free"])
    {
        
        UIFont *font =[UIFont systemFontOfSize:14];
        UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
        NSDictionary *dict1 = @ {NSFontAttributeName :font};
        NSDictionary *dict2 = @ {NSFontAttributeName :boldFont};
        
        NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ \n\u2022 Coupon expires on:",[dict111 valueForKey:@"details"]] attributes:dict1];
        
        NSMutableAttributedString *attributString1 = [[NSMutableAttributedString alloc]initWithString:[dict111 valueForKey:@"exp"] attributes:dict2];
        
        [attributString appendAttributedString:attributString1];
        couponExp2.attributedText = attributString;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 150, 25)];
        titleLabel.text = @"YOUR COUPON";
        titleLabel.textColor = [UIColor colorWithRed:(203.0 / 255.0) green:(15.0 / 255.0) blue:(34.0 / 255.0) alpha:1.0];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, CouponImgview2.frame.size.height/2+10, 60, 17)];
        showLabel.text = [NSString stringWithFormat:@"SHOW >"];
        showLabel.textColor = [UIColor grayColor];
        showLabel.font =[UIFont boldSystemFontOfSize:14];
        
        UILabel *swipeLabel = [[UILabel alloc]initWithFrame:CGRectMake(showLabel.frame.size.width+showLabel.frame.origin.x+2, CouponImgview2.frame.size.height/2+10, 50, 17)];
        
        swipeLabel.text = @"SWIPE";
        swipeLabel.textColor = [UIColor grayColor];
        swipeLabel.font =[UIFont boldSystemFontOfSize:14];
        //swipeLabel.backgroundColor =[UIColor whiteColor];
        
        UILabel *secondArrow =[[UILabel alloc]initWithFrame:CGRectMake(swipeLabel.frame.size.width+swipeLabel.frame.origin.x-1, CouponImgview2.frame.size.height/2+10, 60, 17)];
        secondArrow.text = @"> SAVE!";
        secondArrow.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(150.0 / 255.0) blue:(56.0 / 255.0) alpha:1.0];
        secondArrow.font =[UIFont boldSystemFontOfSize:14];
        
        
        UIImageView *barcodeImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, 10, 25, CouponImgview2.frame.size.height-20)];
        barcodeImage.image=[UIImage imageNamed:@"h_barcode_w"];
        
        UILabel *redeemLabel = [[UILabel alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, CouponImgview2.frame.size.height/2+15, 75, 15)];
        redeemLabel.text = @"REDEEM NOW";
        redeemLabel.textColor = [UIColor grayColor];
        redeemLabel.font =[UIFont systemFontOfSize:10];
        
        UIImageView *slideImage =[[UIImageView alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
        slideImage.image=[UIImage imageNamed:@"hand Free"];
        [UIView animateWithDuration:2.5f
                              delay:0.0f
                            options:UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [slideImage setFrame:CGRectMake(CouponImgview2.frame.size.width-slideImage.frame.size.width, 10, 30, 35)];
                         }
                         completion:^(BOOL finished)
         {
             // Top right to bottom right
             [UIView animateWithDuration:.0f
                              animations:^{
                                  [slideImage setFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
                              }
                              completion:nil];
         }];
        UISwipeGestureRecognizer *freeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(freegesture:)];
        freeGesture.direction= UISwipeGestureRecognizerDirectionRight;
       // CouponImgview2.tag=4000;
        [CouponImgview2 addSubview:titleLabel];
        [CouponImgview2 addSubview:showLabel];
        [CouponImgview2 addSubview:swipeLabel];
        [CouponImgview2 addSubview:secondArrow];
        [CouponImgview2 addSubview:barcodeImage];
        [CouponImgview2 addSubview:redeemLabel];
        [CouponImgview2 addSubview:slideImage];
        [CouponImgview2 addGestureRecognizer:freeGesture];
    }
    for (UIView *v in CouponImgview2.subviews) {
        v.userInteractionEnabled = YES;
        
    }
    [ourCouponView addSubview:couponTitle2];
    [ourCouponView addSubview:CouponImgview2];
    [ourCouponView addSubview:couponDetail2];
    [ourCouponView addSubview:couponExp2];

}
-(void)createCouponView1:(NSMutableArray *)array{
    
    NSMutableDictionary *dict111=[array objectAtIndex:0];
    CouponImgview3 =[[UIImageView alloc]init];
    CouponImgview3.frame=CGRectMake(10,couponTitle.frame.size.height+couponTitle.frame.origin.y+10, self.view.frame.size.width-20, 80);
    CouponImgview3.userInteractionEnabled = YES;
    CouponImgview3.tag =[[dict111 valueForKey:@"id"]integerValue];
    
    couponTitle3 = [[UILabel alloc]init];
    couponTitle3.text=[dict111 objectForKey:@"title"];
    couponTitle3.textColor=[UIColor redColor];
    couponTitle3.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
    
    couponDetail3 = [[UILabel alloc]init];
    couponDetail3.text=@"Coupon details";
    couponDetail3.textColor=[UIColor blackColor];
    couponExp3 = [[UITextView alloc]init];
    NSString *type=[dict111 objectForKey:@"type"];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"usertype"]) {
        type = @"free";
    }else{
        type=[dict111 objectForKey:@"type"];
    }
    if([type isEqualToString:@"premium"])
    {
        UIFont *font =[UIFont systemFontOfSize:14];
        UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
        NSDictionary *dict1 = @ {NSFontAttributeName :font};
        NSDictionary *dict2 = @ {NSFontAttributeName :boldFont};
        
        NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ \n\u2022 Coupon expires on:",[dict111 valueForKey:@"details"]] attributes:dict1];
        
        NSMutableAttributedString *attributString1 = [[NSMutableAttributedString alloc]initWithString:[dict111 valueForKey:@"exp"] attributes:dict2];
        
        [attributString appendAttributedString:attributString1];
        couponExp3.attributedText = attributString;
        // couponExp.text=[NSString stringWithFormat:@"\n\u2022 Coupon expires on: %@",[dict111 objectForKey:@"exp"]];
        
        CouponImgview3.backgroundColor=[UIColor colorWithRed:234.0/255 green:158.0/255 blue:43.0/255 alpha:1.0];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 150, 25)];
        titleLabel.text = @"LOCKED COUPON";
        titleLabel.textColor = [UIColor redColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        
        UIImageView *lockImage =[[UIImageView alloc]initWithFrame:CGRectMake(3, CouponImgview3.frame.size.height/2+5, 25, 30)];
        lockImage.image=[UIImage imageNamed:@"lock"];
        
        UILabel *redeemLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, CouponImgview3.frame.size.height/2+10, 100, 17)];
        redeemLabel1.text = @"REDEEM NOW";
        redeemLabel1.textColor = [UIColor whiteColor];
        redeemLabel1.font =[UIFont boldSystemFontOfSize:14];
        
        UIImageView *barcodeImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, 10, 25, CouponImgview3.frame.size.height-20)];
        barcodeImage.image=[UIImage imageNamed:@"h_barcode_w"];
        
        
        UILabel *redeemLabel = [[UILabel alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, CouponImgview3.frame.size.height/2+15, 75, 15)];
        redeemLabel.text = @"REDEEM NOW";
        redeemLabel.textColor = [UIColor grayColor];
        redeemLabel.font =[UIFont systemFontOfSize:10];
        
        UIImageView *slideImage =[[UIImageView alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
        slideImage.image=[UIImage imageNamed:@"hand lock"];
        [UIView animateWithDuration:2.5f
                              delay:0.0f
                            options:UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [slideImage setFrame:CGRectMake(CouponImgview3.frame.size.width-slideImage.frame.size.width, 10, 30, 35)];
                         }
                         completion:^(BOOL finished)
         {
             // Top right to bottom right
             [UIView animateWithDuration:.0f
                              animations:^{
                                  [slideImage setFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
                              }
                              completion:nil];
         }];
        
        UISwipeGestureRecognizer *lockGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(lockgesture:)];
        lockGesture.direction= UISwipeGestureRecognizerDirectionRight;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hello)];
        [CouponImgview3 addGestureRecognizer:tap];

        [CouponImgview3 addSubview:titleLabel];
        [CouponImgview3 addSubview:lockImage];
        [CouponImgview3 addSubview:redeemLabel1];
        
        [CouponImgview3 addSubview:barcodeImage];
        [CouponImgview3 addSubview:redeemLabel];
        [CouponImgview3 addSubview:slideImage];
       [CouponImgview3 addGestureRecognizer:lockGesture];
        
    }
    else if([type isEqualToString:@"free"])
    {
        
        UIFont *font =[UIFont systemFontOfSize:14];
        UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
        NSDictionary *dict1 = @ {NSFontAttributeName :font};
        NSDictionary *dict2 = @ {NSFontAttributeName :boldFont};
        
        NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ \n\u2022 Coupon expires on:",[dict111 valueForKey:@"details"]] attributes:dict1];
        
        NSMutableAttributedString *attributString1 = [[NSMutableAttributedString alloc]initWithString:[dict111 valueForKey:@"exp"] attributes:dict2];
        
        [attributString appendAttributedString:attributString1];
        couponExp3.attributedText = attributString;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 7, 150, 25)];
        titleLabel.text = @"YOUR COUPON";
        titleLabel.textColor = [UIColor colorWithRed:(203.0 / 255.0) green:(15.0 / 255.0) blue:(34.0 / 255.0) alpha:1.0];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, CouponImgview3.frame.size.height/2+10, 60, 17)];
        showLabel.text = [NSString stringWithFormat:@"SHOW >"];
        showLabel.textColor = [UIColor grayColor];
        showLabel.font =[UIFont boldSystemFontOfSize:14];
        
        UILabel *swipeLabel = [[UILabel alloc]initWithFrame:CGRectMake(showLabel.frame.size.width+showLabel.frame.origin.x+2, CouponImgview3.frame.size.height/2+10, 50, 17)];
        
        swipeLabel.text = @"SWIPE";
        swipeLabel.textColor = [UIColor grayColor];
        swipeLabel.font =[UIFont boldSystemFontOfSize:14];
        //swipeLabel.backgroundColor =[UIColor whiteColor];
        
        UILabel *secondArrow =[[UILabel alloc]initWithFrame:CGRectMake(swipeLabel.frame.size.width+swipeLabel.frame.origin.x-1, CouponImgview3.frame.size.height/2+10, 60, 17)];
        secondArrow.text = @"> SAVE!";
        secondArrow.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(150.0 / 255.0) blue:(56.0 / 255.0) alpha:1.0];
        secondArrow.font =[UIFont boldSystemFontOfSize:14];
        
        
        UIImageView *barcodeImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, 10, 25, CouponImgview3.frame.size.height-20)];
        barcodeImage.image=[UIImage imageNamed:@"h_barcode_w"];
        
        UILabel *redeemLabel = [[UILabel alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, CouponImgview3.frame.size.height/2+15, 75, 15)];
        redeemLabel.text = @"REDEEM NOW";
        redeemLabel.textColor = [UIColor grayColor];
        redeemLabel.font =[UIFont systemFontOfSize:10];
        
        UIImageView *slideImage =[[UIImageView alloc]initWithFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
        slideImage.image=[UIImage imageNamed:@"hand Free"];
        [UIView animateWithDuration:2.5f
                              delay:0.0f
                            options:UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [slideImage setFrame:CGRectMake(CouponImgview3.frame.size.width-slideImage.frame.size.width, 10, 30, 35)];
                         }
                         completion:^(BOOL finished)
         {
             // Top right to bottom right
             [UIView animateWithDuration:.0f
                              animations:^{
                                  [slideImage setFrame:CGRectMake(barcodeImage.frame.size.width+barcodeImage.frame.origin.x+10, 10, 30, 35)];
                              }
                              completion:nil];
         }];
//     Henrik
//        UISwipeGestureRecognizer *freeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(freegesture:)];
//        freeGesture.direction= UISwipeGestureRecognizerDirectionRight;
//        CouponImgview3.tag=4000;
        [CouponImgview3 addSubview:titleLabel];
        [CouponImgview3 addSubview:showLabel];
        [CouponImgview3 addSubview:swipeLabel];
        [CouponImgview3 addSubview:secondArrow];
        [CouponImgview3 addSubview:barcodeImage];
        [CouponImgview3 addSubview:redeemLabel];
        [CouponImgview3 addSubview:slideImage];
//        [CouponImgview3 addGestureRecognizer:freeGesture];
    }

    [ourCouponView addSubview:couponTitle3];
    [ourCouponView addSubview:CouponImgview3];
    [ourCouponView addSubview:couponDetail3];
    [ourCouponView addSubview:couponExp3];
    
}
-(void)hello{
    NSLog(@"hello");
}



// free coupon gesture
-(void)freegesture:(UISwipeGestureRecognizer *)gesture{
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"lol");
        //        for (UIView *view11 in ourCouponView.subviews) {
        //            if(view11.tag == 4000)
        //            {
        //                    [CouponImgview removeFromSuperview];
        //            }
        //        }
        
        gestureView = gesture.view;
        view =[[UIView alloc]init];
        view.frame = gestureView.frame;
        view.layer.cornerRadius = 10;
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.clipsToBounds = YES;
        view.layer.masksToBounds=YES;
        
        gestureView.hidden=true;
        //CouponImgview.hidden = true;
        
        UILabel *Sure=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width/2-20, view.frame.size.height)];
        Sure.text = @"SURE TO REDEEM?";
        Sure.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:28.0];
        Sure.numberOfLines = 2;
        Sure.lineBreakMode = NSLineBreakByWordWrapping;
        Sure.textAlignment = NSTextAlignmentCenter;
        Sure.textColor=[UIColor colorWithRed:(203.0 / 255.0) green:(15.0 / 255.0) blue:(34.0 / 255.0) alpha:1.0];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(Sure.frame.size.width+Sure.frame.origin.x, 2, 2, view.frame.size.height-4)];
        line.backgroundColor =[UIColor lightGrayColor];
        // line.image=[UIImage imageNamed:@"green_vlineright"];
        
        UIButton *yes=[UIButton buttonWithType:UIButtonTypeCustom];
        yes.tag = gestureView.tag;
        yes.frame = CGRectMake(line.frame.size.width+line.frame.origin.x+5, 0, 65, view.frame.size.height);
        [yes setTitle:@"YES" forState:UIControlStateNormal];
        [yes setTitleColor:[UIColor colorWithRed:(26.0 / 255.0) green:(150.0 / 255.0) blue:(56.0 / 255.0) alpha:1.0]forState:UIControlStateNormal];
        [yes addTarget:self action:@selector(yes:) forControlEvents:UIControlEventTouchUpInside];
        yes.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:40.0];
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(yes.frame.size.width+yes.frame.origin.x+5, 5, 30, view.frame.size.height-10)];
        line2.image=[UIImage imageNamed:@"h_barcode_w"];
        
        
        UIButton *no=[UIButton buttonWithType:UIButtonTypeCustom];
        no.frame = CGRectMake(line2.frame.size.width+line2.frame.origin.x+3                                                                                                                                                                             , 0, 60, view.frame.size.height);
        [no setTitle:@"NO" forState:UIControlStateNormal];
        [no setTitleColor:[UIColor colorWithRed:(203.0 / 255.0) green:(15.0 / 255.0) blue:(34.0 / 255.0) alpha:1.0] forState:UIControlStateNormal];
        [no addTarget:self action:@selector(no) forControlEvents:UIControlEventTouchUpInside];
        no.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:40.0];
        
        [view addSubview:Sure];
        [view addSubview:line];
        [view addSubview:line2];
        [view addSubview:yes];
        
        [view addSubview:no];
        view.tag = 999;
        
        [ourCouponView addSubview:view];
        
    }

}



-(void)yes:(id)sender{
    
    
    if (user_id == 1){
        
        
       ///// Henrik
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Demo mode"
//                                                        message:@"You need a account before you can swipe coupons"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Create a free account"
//                                              otherButtonTitles: nil];
//        alert.alertViewStyle = UIAlertViewStyleDefault;
//        [alert show];
//        
//        
//        
//        //this prevent the ARC to clean up :
//        NSRunLoop *rl = [NSRunLoop currentRunLoop];
//        NSDate *d;
//        d = (NSDate*)[d init];
//        while ([alert isVisible]) {
//            [rl runUntilDate:d];
//        }
        
    }
    
    
    
    if(user_id != 1){
        UIButton *button = sender;
        NSString *urlStr=@"http://couponcms.ontwikkelomgeving.info/swipe_coupon";
        NSString *status= [Helper  UnFavoriteCoupon1:user_id :button.tag :urlStr];
        
        for (UIView *view11 in ourCouponView.subviews) {
            if(view11.tag == 999)
            {
                for (UIView *vv in view11.subviews)
                {
                    [vv removeFromSuperview];
                }
            }
        }
        
        UILabel *Sure=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2-147, 5, 294, 60)];
        Sure.textColor=[UIColor whiteColor];
        //Sure.backgroundColor = [UIColor orangeColor];
        Sure.font = [UIFont boldSystemFontOfSize:17.0];
        Sure.numberOfLines = 2;
        Sure.lineBreakMode = NSLineBreakByWordWrapping;
        Sure.textAlignment = NSTextAlignmentCenter;
        
        UILabel *Sure1=[[UILabel alloc]initWithFrame:CGRectMake(0,view.frame.size.height-25, view.frame.size.width, 20)];
        Sure1.textColor=[UIColor whiteColor];
        Sure1.font = [UIFont systemFontOfSize:15];
        
        Sure1.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor= [UIColor colorWithRed:(19 / 255.0) green:(145 / 255.0) blue:(41 / 255.0) alpha:1.0];
        if([status isEqualToString:@"done"])
        {
            Sure.text = @"THIS COUPON HAS \n SUCCESSFULLY BEEN REDEEMED!";
            
            Sure1.text = @"Thank you for your visit";
            
        }
        else if([status isEqualToString:@"used"])
        {
            Sure.text = @"THIS COUPON HAS BEEN ALREADY USED!";
            Sure1.text = @"Thank you for your visit";
        }
        else
        {
            UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@" error in process" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alv show];
        }
        [view addSubview:Sure];
        [view addSubview:Sure1];
        
    }

    
}

-(void)no{
    
    for (UIView *view11 in ourCouponView.subviews) {
        if (view11.tag == 999) {
            [view11 removeFromSuperview];
        }
    }
    gestureView.hidden=NO;
}

-(void)lockgesture:(UISwipeGestureRecognizer *)gesture{
    if (user_id == 1){
        
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Demo mode"
        //                                                        message:@"You need a account before you can swipe coupons"
        //                                                       delegate:self
        //                                              cancelButtonTitle:@"Create a free account"
        //                                              otherButtonTitles: nil];
        //        alert.alertViewStyle = UIAlertViewStyleDefault;
        //        [alert show];
        //
        //
        //
        //        //this prevent the ARC to clean up :
        //        NSRunLoop *rl = [NSRunLoop currentRunLoop];
        //        NSDate *d;
        //        d = (NSDate*)[d init];
        //        while ([alert isVisible]) {
        //            [rl runUntilDate:d];
        //        }
    }
    
    
    
    if(user_id != 1){
        
        
        
        
        //    if(user_id != 1){
        
        
        if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            paymnetInfoView.hidden = NO;
            shadedimageView.hidden = NO;
            shadedimageView.userInteractionEnabled=NO;
            paymnetInfoView.frame = CGRectMake(WIDTH/2-150,70, 300, self.view.frame.size.height-90);
            
            paymnetInfoView.layer.cornerRadius = 10.0f;
            paymnetInfoView.layer.masksToBounds = YES;
            
            paymentInfoScroll.frame = CGRectMake(0, 0, 300, paymnetInfoView.frame.size.height);
            paymentInfoScroll.contentSize=CGSizeMake(300,500);
            
            PITitle.frame = CGRectMake(0, 10, paymnetInfoView.frame.size.width, 21);
            PIDivider.frame=CGRectMake(0, 40, paymnetInfoView.frame.size.width, 2);
            PITitle2.frame=CGRectMake(15, 51, 270, 72);
            PITitle3.frame=CGRectMake(12, 133, 270, 58);
            PITitle3.backgroundColor=[UIColor whiteColor];
            
            PITitle3.layer.cornerRadius = 10.0f;
            PITitle3.layer.masksToBounds = NO;
            PITitle3.layer.borderWidth =2.0f;
            // PITitle3.layer.borderColor= (__bridge CGColorRef _Nullable)([UIColor greenColor]);
            
            PITitle4.frame=CGRectMake(15, 199, 270, 37);
            PITitle5.frame=CGRectMake(15, 244, 270, 51);
            PITitle6.frame=CGRectMake(15, 305, 270, 30);
            //  paypalButton.frame=CGRectMake(35, 335, 230, 45);
            applePayButton.frame=CGRectMake(30, 310, 243, 62);
            
            PITitle7.frame=CGRectMake(15, 270, 270, 43);
            [self.view bringSubviewToFront:shadedimageView];
            [self.view bringSubviewToFront:paymnetInfoView];
            
        }
        
    }

    
}

-(void)InfoView
{
    if(couponDetailArr.count)
    {
        NSMutableDictionary *dict1 = [couponDetailArr objectAtIndex:0];
        self.listingLatitude=[dict1 objectForKey:@"lat"];
        self.listingLongitude=[dict1 objectForKey:@"lang"];
        NSInteger merchnID=[[dict1 objectForKey:@"fk_merchant_id"] integerValue];
        arrOpeningTime= [[Helper MerchantOpeningClosingTime:merchnID] mutableCopy];
        
        website.text = [dict1 objectForKey:@"website"];
        
        
        NSNumber *number = [dict1 objectForKey:@"phone"];
        phone.text = [NSString stringWithFormat:@"%ld", number.longValue];
        
        
        [phone addGestureRecognizer:phoneGesture];
        [website addGestureRecognizer:websiteGesture];
        // [phone setTitle:[dict1 objectForKey:@"phone"] forState:UIControlStateNormal];
        address.text =[dict1 valueForKey:@"address"];
        titleLbl.text=[dict1 objectForKey:@"merchant_name"];
        // CategoryLbl.text=[dict1 objectForKey:@"category"];
        couponTitle.text=[dict1 objectForKey:@"category"];
        couponTitle.textColor=[UIColor darkGrayColor];
        couponTitle.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];

        detailTxt.text=[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"description"]];
        
        couponDetail.text=@"Address";
        couponDetail.textColor=[UIColor darkGrayColor];
        
        OpenTimes.text=@"Openings Times";
        if(arrOpeningTime.count)
        {
            for(NSMutableDictionary *dict in arrOpeningTime)
            {
                if (![OpenTimesTxtview.text isEqualToString:@""]) {
                    
                    NSString *str=[NSString stringWithFormat:@"\n\n%@\t\t\t%@\t\t\t%@",[dict objectForKey:@"day"],[dict objectForKey:@"open_hour"],[dict objectForKey:@"close_hour"]];
                    OpenTimesTxtview.text=[OpenTimesTxtview.text stringByAppendingString:str];
                }
                else
                {
                    OpenTimesTxtview.text=[NSString stringWithFormat:@"Day\t\t\t\tOpening\t\t\t\tClosing\n\n%@\t\t\t%@\t\t\t%@",[dict objectForKey:@"day"],[dict objectForKey:@"open_hour"],[dict objectForKey:@"close_hour"]];
                }
            }
        }
        //   [self performSelector:@selector(animateImages) withObject:nil afterDelay:4.0];
    }
}

-(void)getSlidingImage:(NSMutableArray *)arrr
{
    if(arrr.count)
    {
        NSDictionary *CouponSlidingImagesDict=[arrr objectAtIndex:0];
        NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",[CouponSlidingImagesDict objectForKey:@"images"]]];
        NSRange range = [[CouponSlidingImagesDict objectForKey:@"images"] rangeOfString:@"."];
        NSString *newString = [[CouponSlidingImagesDict objectForKey:@"images"] substringToIndex:range.location];
        myCacheKey=[NSString stringWithFormat:@"%@.png",newString];
        [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
            if(image !=nil)
            {
                logoImg1.image=image;
            }
            else
            {
                [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    [imageCache  storeImage:image forKey:myCacheKey];
                    logoImg1.image=image;
                }];
            }
        }];
    }
}
-(void)Call
{
    NSMutableArray *arrImage11=[Helper MerchantSlidingImages:couponID];
    
    if(arrImage11.count)
    {
    for(int k=0;k<[arrImage11 count];k++)
    {
        NSMutableDictionary *dict=[arrImage11 objectAtIndex:k];
        NSRange range = [[dict objectForKey:@"photo"] rangeOfString:@"."];
        NSString *newString = [[dict objectForKey:@"photo"] substringToIndex:range.location];
        myCacheKey=[NSString stringWithFormat:@"%@.png",newString];
        
        NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",[dict objectForKey:@"photo"]]];
        
        [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
            if(image !=nil)
            {
                NSData *pictureData=UIImagePNGRepresentation(image);
                [arrImage addObject:pictureData];
                valueType++;
                if(valueType == arrImage11.count)
                {
                    [self animateImages];
                }
            }
            else
            {
                [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize)
                {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                 
            NSData *pictureData=UIImagePNGRepresentation(image);
            [arrImage addObject:pictureData];
                    if (pictureData) {
                        [imageCache  storeImage:image forKey:myCacheKey];
                    }
                    
                    valueType++;
                    if(valueType == arrImage11.count)
                    {
                        [self animateImages];
                    }
                }];
            }
        }];
    }}
}

- (void)animateImages
{
    if(arrImage.count)
    {
      //  CGFloat duration = 6.0 / ([arrImage count] -1);
        logoImg2.image =[UIImage imageWithData:[[arrImage mutableCopy] objectAtIndex:arc4random() % [arrImage count]]];
         logoImg2.alpha = 1.0;
        logoImg1.alpha = 0.0;
        logoImg2.image =[UIImage imageWithData:[[arrImage mutableCopy] objectAtIndex:arc4random() % [arrImage count]]];

    [UIView animateWithDuration:3.0 delay:3.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //Fade out the current image
        logoImg1.image =[UIImage imageWithData: [[arrImage mutableCopy] objectAtIndex:arc4random() % [arrImage count]]];

        logoImg2.alpha = 0.0;
        
        //Fade in the new image
        logoImg1.alpha = 1.0;
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:3.0 delay:3.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //Fade out the current image
            logoImg1.alpha = 0.0;

            logoImg2.alpha = 1.0;
            [self performSelector:@selector(animateImages) withObject:nil afterDelay:3.0];
            //[self animateImages];
            //Fade in the new image
        } completion:NULL];
        
    }];
    }else{
        return;
    }
}

-(IBAction)ourCoupon:(id)sender
{
    mapkitView.hidden=YES;
    couponDetailView.hidden=YES;
    ourCouponView.hidden=NO;

    UIButton *button=(UIButton *)sender;
    
    button.backgroundColor=[UIColor colorWithRed:(239 / 255.0) green:(239 / 255.0) blue:(244 / 255.0) alpha:1.0];
    MapViewBtn.backgroundColor=[UIColor lightGrayColor];
    DetailedBtn.backgroundColor=[UIColor lightGrayColor];
    TopScrll.contentSize=CGSizeMake(self.view.frame.size.width,dot.frame.size.height+dot.frame.origin.y+70);
    ourCouponView.frame =CGRectMake(0, 64, WIDTH, TopScrll.contentSize.height-64);

}

-(IBAction)DetailedBtn :(id)sender
{
    mapkitView.hidden=YES;
    couponDetailView.hidden=NO;
    ourCouponView.hidden=YES;
    MapViewBtn.backgroundColor=[UIColor lightGrayColor];
    OurCouponBtn.backgroundColor = [UIColor lightGrayColor];
    UIButton *button=(UIButton *)sender;
   
    button.backgroundColor=[UIColor colorWithRed:(239 / 255.0) green:(239 / 255.0) blue:(244 / 255.0) alpha:1.0];
   TopScrll.contentSize=CGSizeMake(self.view.frame.size.width,OpenTimesTxtview.frame.size.height+OpenTimesTxtview.frame.origin.y+57);
}
-(IBAction)MapBtn :(id)sender
{
    mapkitView.hidden=NO;
    couponDetailView.hidden=YES;
    ourCouponView.hidden=YES;
    for (UIView *vie in mapkitView.subviews) {
        [vie removeFromSuperview];
    }
    [TopScrll setContentOffset:CGPointZero animated:YES];

    TopScrll.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-54);
    
    DetailedBtn.backgroundColor=[UIColor lightGrayColor];
    OurCouponBtn.backgroundColor=[UIColor lightGrayColor];
    self.mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0,0, TopScrll.frame.size.width,self.view.frame.size.height-54)];
    self.mapView.delegate=self;
   self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [_mapView setShowsPointsOfInterest:YES];

    UIButton *button=(UIButton *)sender;
    button.backgroundColor=[UIColor colorWithRed:(239 / 255.0) green:(239 / 255.0) blue:(244 / 255.0) alpha:1.0];
   
    CLLocationCoordinate2D coordinat;
    coordinat.latitude = [self.listingLatitude doubleValue];
    coordinat.longitude = [self.listingLongitude doubleValue];
    
    Annotation *newAnnotation = [[Annotation alloc] initWithCoordinate:coordinat title:titleLbl.text subtitle:nil];
    [self.mapView addAnnotation:newAnnotation];
    [self.mapView selectAnnotation:newAnnotation animated:YES];
    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(coordinat, 10000, 10000);
    [self.mapView setRegion:rgn];
   // [self layoutSubView:val];
    UIButton *currentLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentLocation addTarget:self action:@selector(getCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    currentLocation.frame = CGRectMake(WIDTH-60, 20, 40, 40);
    [currentLocation setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];

    [self.mapView addSubview:currentLocation];
    [mapkitView addSubview:self.mapView];

}
-(IBAction)Paypal:(id)sender{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.africoupon.com/paypal.php"]];
    
}
-(IBAction)InAppPurchase:(id)sender{
 
    NSSet *mySet = [NSSet setWithObject:@"com.africoupon.unlockallcoupons"];
    // Create a product request object and initialize it with the above set
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:mySet];
    
    request.delegate = self;
    
    // Send the request to the App Store
    [request start];
     [SVProgressHUD showWithStatus:@"Please wait.."];
}

-(void)calling :(UITapGestureRecognizer *)tap{
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone.text]]];
}
-(void)openSafari :(UITapGestureRecognizer *)tap{
    NSString *myURLString = website.text;
    NSURL *myURL;
    if ([myURLString.lowercaseString hasPrefix:@"http://"]) {
        myURL = [NSURL URLWithString:myURLString];
    } else {
        myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myURLString]];
    }
 [[UIApplication sharedApplication]openURL:myURL];
}
-(void)getCurrentLocation{
    
      //[locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    
}
#pragma mark alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        if(user_id == 1){
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
            
         
            
            RegistrationViewController*forgetPasswordview = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
            [self.navigationController pushViewController:forgetPasswordview animated:YES];

        }
        
        NSLog(@"0");
    }else{
       // [SVProgressHUD showWithStatus:@"Please wait.."];
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}
#pragma mark Store kit delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [SVProgressHUD dismiss];
    if ([response.products count] > 0)
    {
        // Use availableProducts to populate your UI
        NSArray *availableProducts = response.products;
        
        [self displayStoreUI :availableProducts];
    }
}
-(void)displayStoreUI :(NSArray *)data{
    
    product = [data objectAtIndex:0];
    UIAlertView *storeUI = [[UIAlertView alloc]initWithTitle:product.localizedTitle message:product.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"BUY", nil];
    storeUI.delegate =self;
    [storeUI show];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
  //  [SVProgressHUD showWithStatus:@"Please wait.."];

    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                [self unlockFeature];
              
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

-(void)unlockFeature
{
    [SVProgressHUD dismiss];

    NSString *result =[Helper UpgradeAccount:user_id];
    if ([result isEqualToString:@"Update successful."]) {
            paymnetInfoView.hidden = YES;
            shadedimageView.hidden = YES;
            
            [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"usertype"];
        NSLog(@"Transaction successful");

            [self.navigationController popViewControllerAnimated:NO];
    }else{
        paymnetInfoView.hidden = YES;
        shadedimageView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Some Error Occurs" message:@"Please Try Again Later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        NSLog(@"Transaction unsuccessful");

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
