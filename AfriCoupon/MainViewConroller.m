 //
//  MainViewConroller.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "MainViewConroller.h"
#import "DropDownCell.h"
#import "AllCouponTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Helper.h"
#import "SVProgressHUD.h"
#import "TAbInfoClassViewController.h"
#import "CategorySearchViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewConroller ()<UIAlertViewDelegate>
{
    UIButton *expireBtn;
    NSArray *sectionArray;
    NSInteger user_id;
    NSString *password;
    NSInteger SendValue;
    int yAxis;
    UITapGestureRecognizer *infoTapGes;
    UITapGestureRecognizer *CouponViewGesture;
    NSMutableArray *catArr;
    BOOL dropCell;
    BOOL showBanner;
    NSArray *arrCouponType;
    UIDatePicker *datePickerView;
    NSString *dateTxt;
    NSString *selectedValue;
    NSMutableArray *merchant_categoryArr;
    NSArray *filteredArray;
   // NSString *selectedCategoryType;
    UILabel *dateLbl;
    SDImageCache *imageCache ;
    NSString *stringPath;
}
@property(strong,nonatomic)   IBOutlet  UIView *vc;

@end

@implementation MainViewConroller
- (void)viewDidLoad {
    [super viewDidLoad];
    yAxis=0;
    dropCell=false;

    // http://couponcms.ontwikkelomgeving.info/new_coupon_notification
    UITapGestureRecognizer *gestureRec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [gestureRec setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:gestureRec];
    
    arrCouponType=[NSArray arrayWithObjects:@"No filter",@"Free",@"Premium", nil];
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationItem.leftBarButtonItem=self.menu;
    SWRevealViewController *revealViewController = self.revealViewController;
    revealViewController.navigationController.navigationBarHidden=true;
    if ( revealViewController )
    {
        [self.menu setTarget:self.revealViewController];
        [self.menu setAction:@selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-70, 5, 150, 35)];
    // navigationView.backgroundColor = [UIColor grayColor];
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    logoView.image =[UIImage imageNamed:@"logoview"];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,7, 150, 25)];
    titleLabel.text = @"AFRICOUPON";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [navigationView addSubview:logoView];
    [navigationView addSubview:titleLabel];
    self.navigationItem.titleView = navigationView;
    
    sectionArray=[NSArray arrayWithObjects:@"Country", @"Expiry",@"Category",@"Coupon Types",@"CouponTypes",nil];
    NSLog(@"%@", arrCouponType);
    self.CouponFilterSubView=[[UIView alloc]init];
    user_id= [[NSUserDefaults standardUserDefaults]integerForKey:@"user_id"];
    password=[[NSUserDefaults standardUserDefaults]objectForKey:@"Password"];
    
    self.MyFavSubView=[[UIView alloc]init];
    self.AllCouponTbl.frame=CGRectMake(0, self.AllCouponView.frame.size.height+self.AllCouponView.frame.origin.y
                                       , self.view.frame.size.width, self.view.frame.size.height);
    self.AllCouponTbl.delegate=self;
    self.AllCouponTbl.dataSource=self;
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"BackFromTab"];
    [self CoupnFilterSubView];
    imageCache = [[SDImageCache alloc] initWithNamespace:@"myNamespace"];
    //[Helper UserFavoriteCoupon:user_id];
    [self showRandomBanner];
    
  

}
-(IBAction)updateLabel:(id)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year   =    [[calendar components:NSCalendarUnitYear    fromDate:[datePickerView date]] year];
    NSInteger month  =    [[calendar components:NSCalendarUnitMonth   fromDate:[datePickerView date]] month];
    NSInteger day    =    [[calendar components:NSCalendarUnitDay     fromDate:[datePickerView date]] day];
    dateTxt = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year, (long)month, (long)day];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MM-dd";
    NSDate *yourDate = [dateFormatter dateFromString:dateTxt];
    dateFormatter.dateFormat = @"EEE, MMM dd, YYYY";
    dateLbl.text=[dateFormatter stringFromDate:yourDate];
}

-(void)viewWillAppear:(BOOL)animated
{
    
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedExpiry"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey :@"selectedCategory"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"searchText"];
        self.CouponFilterImg.image=[UIImage imageNamed:@"uparr.png"];
        self.MyFavImg.image=[UIImage imageNamed:@"uparr.png"];
        self.AllCouponImg.image=[UIImage imageNamed:@"dwnarr.png"];
        self.backImg.hidden=YES;
        self.backImg.userInteractionEnabled=NO;
        self.backImg.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        CouponFilterBool =false;
        MyFavBool=false;
        AllCouponBool=false;
        self.MyFavSubView.hidden=YES;
        CGRect frame = _CouponFilterBtn.frame;
        frame.size.width = self.view.frame.size.width;
        _CouponFilterBtn.frame = frame;
        frame  = _MyFavBtn.frame;
        frame.size.width = self.view.frame.size.width;
        _MyFavBtn.frame =frame;
        
        frame  = _AllCouponBtn.frame;
        frame.size.width = self.view.frame.size.width;
        _AllCouponBtn.frame =frame;
        
        
        NSInteger val=1;
        
        dispatch_queue_t queue = dispatch_queue_create("com.example.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            [self AllCoupon];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.AllCouponTbl reloadData];
                [self AllCouponAct:self];
            });
        });
        dispatch_queue_t queue11 = dispatch_queue_create("com.example.MyQueue11", NULL);
        dispatch_async(queue11, ^{
            // Do some computation here.
            catArr=[Helper GetCategory];
            [self UserFavoriteCoupon];
        });
        [self layoutSubview:val];
    NSLog(@"%@", CouponData);

}

-(void)viewWillDisappear:(BOOL)animated
{
    
}
-(void)layoutSubview:(NSInteger )val
{
    self.TopScrollView.frame=CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height);
    self.TopScrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.TopSearchBAr.frame=CGRectMake(0,0, self.view.frame.size.width, 44);
    self.LoadMoreBtn.hidden=YES;
    self.LoadMoreBtn.frame=CGRectMake(0, self.TopScrollView.frame.size.height-104, self.view.frame.size.width, 40);
    self.AllCouponTbl.hidden=YES;

    
    self.CouponFilterView.frame=CGRectMake(0, self.TopSearchBAr.frame.origin.y+self.TopSearchBAr.frame.size.height, self.view.frame.size.width,40);
    self.CouponFilterImg.frame=CGRectMake(self.CouponFilterView.frame.size.width-40, 5,30,30);

    if(val ==1)
    {
   
    self.CouponFilterSubView.frame=CGRectMake(0, self.CouponFilterView.frame.origin.y+self.CouponFilterView.frame.size.height, self.view.frame.size.width,230);
    self.CouponFilterSubView.hidden=YES;
    self.MyFavView.frame=CGRectMake(0, self.CouponFilterView.frame.origin.y+self.CouponFilterView.frame.size.height, self.view.frame.size.width,  40);
    self.MyFavImg.frame=CGRectMake(self.MyFavView.frame.size.width-40, 5,30,30);
   

    self.AllCouponView.frame=CGRectMake(0, self.MyFavView.frame.origin.y+self.MyFavView.frame.size.height, self.view.frame.size.width, 40);
        self.AllCouponImg.frame=CGRectMake(self.AllCouponView.frame.size.width-40, 5,30,30);
       
    int heh = (self.TopScrollView.frame.size.height-(self.AllCouponView.frame.size.height+self.AllCouponView.frame.origin.y)-104);
    
    self.AllCouponTbl.frame=CGRectMake(0, self.AllCouponView.frame.origin.y+self.AllCouponView.frame.size.height, self.view.frame.size.width,heh);
   
    }
    else if(val ==2)
    {
        long y;
        if(MyFavArrData.count)
        {
         y=(long)[MyFavArrData count] *72;
        }
        self.MyFavView.frame=CGRectMake(0, self.CouponFilterView.frame.origin.y+self.CouponFilterView.frame.size.height, self.view.frame.size.width,  40);
        self.MyFavSubView.frame=CGRectMake(0, self.MyFavView.frame.origin.y+self.MyFavView.frame.size.height, self.view.frame.size.width,y);
      self.AllCouponView.frame=CGRectMake(0, self.MyFavSubView.frame.origin.y+ self.MyFavSubView.frame.size.height, self.view.frame.size.width, 40);
       self.TopScrollView.contentSize=CGSizeMake(self.view.frame.size.width,self.MyFavView.frame.size.height+self.MyFavView.frame.origin.y+y+self.AllCouponView.frame.size.height+64);
        self.TopScrollView.scrollEnabled=YES;
    }
}

#pragma mark - UIPickerView Delegate methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (expireBtn.tag == 3) {
         return [catArr count]+1;
    }else{
    return [arrCouponType count];
    }
    
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (expireBtn.tag == 3) {
        if (row == 0) {
    [expireBtn setTitle:@"No Filter" forState:UIControlStateNormal];
            category =@"";
        }else{
         NSMutableDictionary *dict=[catArr objectAtIndex:row-1];
     [expireBtn setTitle:[dict objectForKey:@"category_name"] forState:UIControlStateNormal];
            category =[dict objectForKey:@"category_name"];
    }
    }else if (expireBtn.tag == 4){
        [expireBtn setTitle:[arrCouponType objectAtIndex:row] forState:UIControlStateNormal];
        type= [arrCouponType objectAtIndex:row];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    if (expireBtn.tag == 3) {
        if (row==0) {
            title = @"No Filter";
        }else{
        NSMutableDictionary *dict=[catArr objectAtIndex:row-1];
       
            title =[dict objectForKey:@"category_name"];
        }
        
}
    else if (expireBtn.tag == 4){
        title = [arrCouponType objectAtIndex:row];
        
    }
    return title;

}
#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return arrayForDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AllCoupon";
    AllCouponTableViewCell *cell=(AllCouponTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell ==nil)
        {
            cell=[[AllCouponTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    CouponViewGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CouponLocked:)];
    CouponViewGesture.numberOfTapsRequired=1;
    cell.tag=indexPath.row+1;
    [cell addGestureRecognizer:CouponViewGesture];
    
    NSMutableDictionary *dict = [arrayForDisplay objectAtIndex:indexPath.row];
    
    cell.logo.frame=CGRectMake(10,10,self.view.frame.size.width*1/3-25,50);
    
    
    NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",[dict objectForKey:@"merchant_logo"]]];
    NSRange range = [[dict objectForKey:@"merchant_logo"] rangeOfString:@"."];
    NSString *newString = [[dict objectForKey:@"merchant_logo"] substringToIndex:range.location];

    NSString *myCacheKey=[NSString stringWithFormat:@"%@.png",newString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
        if(image !=nil)
        {
            cell.logo.image=image;
        }
        else
        {
            [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {

            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                CGSize destinationSize = CGSizeMake(240, 150);
                UIGraphicsBeginImageContext(destinationSize);
                [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [imageCache  storeImage:newImage forKey:myCacheKey];
                cell.logo.image=image;
            }];
        }
    }];
    
    infoTapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MoveView:)];
    infoTapGes.numberOfTapsRequired=1;
    cell.logo.userInteractionEnabled=YES;
    cell.logo.tag=indexPath.row+1;
    [cell.logo addGestureRecognizer:infoTapGes];
    
    cell.seprator.frame=CGRectMake(cell.logo.frame.origin.x+cell.logo.frame.size.width+10,5,1,self.view.frame.size.height-10);
    cell.seprator.image=[UIImage imageNamed:@"divider-1"];
    
    cell.LogoName.frame=CGRectMake(cell.logo.frame.origin.x+cell.logo.frame.size.width+15,5,self.view.frame.size.width*1/3-5, 14);
    cell.LogoName.text=[dict objectForKey:@"merchant_name"];
    
    cell.categoryName.frame=CGRectMake(cell.logo.frame.origin.x+cell.logo.frame.size.width+15,19,self.view.frame.size.width*1/3-5, 10);
    cell.categoryName.text=[dict objectForKey:@"merchant_category"];
    
    cell.timerImg.frame=CGRectMake(cell.logo.frame.origin.x+cell.logo.frame.size.width+15,43,21,21);
    cell.timerImg.image=[UIImage imageNamed:@"expire.png"];

    cell.expiryDate.frame=CGRectMake(cell.logo.frame.origin.x+cell.logo.frame.size.width+40,45,self.view.frame.size.width*1/3-40, 20);
    cell.expiryDate.text=[dict objectForKey:@"exp"];
   
    cell.seprator1.frame=CGRectMake(cell.LogoName.frame.origin.x+cell.LogoName.frame.size.width+5,5,1,  self.view.frame.size.height-10);
    cell.seprator1.image=[UIImage imageNamed:@"divider-1"];
    
    cell.Shorttitle.frame=CGRectMake(cell.LogoName.frame.origin.x+cell.LogoName.frame.size.width+10,0,self.view.frame.size.width*1/3-30, cell.frame.size.height);
    cell.Shorttitle.text=[dict objectForKey:@"shorttitle"];
    
    [cell.star setFrame:CGRectMake(self.view.frame.size.width-30,cell.frame.size.height/2-10,25,20)];
    if([[dict objectForKey:@"fav"]intValue] == 0)
    {
        [ cell.star setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal ];
    }
    else
    {
        [cell.star setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal ];
    }
    [cell.star addTarget:self action:@selector(AddCouponToFavorite:) forControlEvents:UIControlEventTouchUpInside];
    cell.star.tag=indexPath.row+1;
    BOOL * testje = [[NSUserDefaults standardUserDefaults]boolForKey:@"usertype"];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"usertype"]) {
    cell.unlock.frame = CGRectMake(self.view.frame.size.width-37,cell.frame.size.height/2+10,35,20);
    if ([[dict objectForKey:@"type"] isEqualToString:@"premium"]) {
        cell.unlock.image = [UIImage imageNamed:@"locked_icon"];
    }else{
        cell.unlock.image = [UIImage imageNamed:@""];

    }
    }else{
        cell.unlock.image = [UIImage imageNamed:@""];

    }
    cell.divider.frame=CGRectMake(10,cell.frame.size.height-2,self.view.frame.size.width,2);

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"log");
}

-(void)MoveView:(UITapGestureRecognizer*)sender
{
    
    UIView *view = sender.view;
    NSLog(@"%ld", (long)view.tag);
    NSMutableDictionary *dict;
    NSString *name;
    NSMutableArray *array =[NSMutableArray new];

    if((long)view.tag >10000)
    {
        int index=(int)view.tag-10000-1;
        if(MyFavArrData.count)
        {
            dict=[MyFavArrData objectAtIndex:index];
            name=[dict valueForKey:@"merchant_name"];
            
        }
    }
    else
    {
        if(arrayForDisplay.count)
        {
            dict=[arrayForDisplay objectAtIndex:(long)view.tag-1];
            [array addObject:dict];
            name=[dict valueForKey:@"merchant_name"];
            
        }
    }
    for (NSDictionary *dic in arrayForDisplay) {
        NSString *name1 =[dic valueForKey:@"merchant_name"];
        if ([name1 isEqualToString:name]) {
            if (![array containsObject:dic]) {
                [array addObject:dic];
            }
        }
    }
    TAbInfoClassViewController *tabInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"TAbInfoClassViewController"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"CouponLocked"];
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"dict"];
    [self.navigationController pushViewController:tabInfo animated:YES];
    //[self  presentViewController:tabInfo animated:YES completion:nil];
    
}

-(void)CouponLocked:(UITapGestureRecognizer*)sender
{
   
    self.backImg.hidden=YES;
    UIView *view = sender.view;
    NSLog(@"%ld", (long)view.tag);
    NSMutableDictionary *dict;
    NSMutableArray *array =[NSMutableArray new];
    NSString *name;
    if((long)view.tag >10000)
    {
        int index=(int)view.tag-10000-1;
        if(MyFavArrData.count)
        {
        dict=[MyFavArrData objectAtIndex:index];
            name=[dict valueForKey:@"merchant_name"];

        }
    }
    else
    {
        if(arrayForDisplay.count)
        {
        dict=[arrayForDisplay objectAtIndex:(long)view.tag-1];
            [array addObject:dict];
            name=[dict valueForKey:@"merchant_name"];
          
        }
    }
    for (NSDictionary *dic in arrayForDisplay) {
        NSString *name1 =[dic valueForKey:@"merchant_name"];
        if ([name1 isEqualToString:name]) {
            if (![array containsObject:dic]) {
                [array addObject:dic];
            }
        }
    }
    TAbInfoClassViewController *tabInfo=[self.storyboard instantiateViewControllerWithIdentifier:@"TAbInfoClassViewController"];
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"CouponLocked"];
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"dict"];
    [self.navigationController pushViewController:tabInfo animated:YES];
    
   // [self  presentViewController:tabInfo animated:YES completion:nil];
    
}
-(IBAction)DropDown:(id)sender
{
    expireBtn=(UIButton *)sender;
    if(expireBtn.tag == 2)
    {
        if(dropCell == false)
        {
            dropCell=true;
            self.backImg.hidden=NO;
            self.TopScrollView.userInteractionEnabled=NO;
            self.vc=[[UIView alloc]init];
            
            self.vc.frame=CGRectMake(10,self.view.frame.size.height/2-175, self.TopScrollView.frame.size.width-20,350);
            self.vc.backgroundColor=[UIColor whiteColor];
            self.vc.tag=5000;
            
            dateLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.vc.frame.size.width,45)];
            dateLbl.textColor=[UIColor colorWithRed:(66.0 / 255.0) green:(176.0 / 255.0) blue:(255.0 / 255.0) alpha:1.0];
            // dateLbl.textAlignment=NSTextAlignmentCenter;
            dateLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0];
            datePickerView=[[UIDatePicker alloc]init];
            UIView *seprator=[[UIView alloc]initWithFrame:CGRectMake(0, 45, self.vc.frame.size.width, 2)];
            seprator.backgroundColor=[UIColor colorWithRed:(66.0 / 255.0) green:(176.0 / 255.0) blue:(255.0 / 255.0) alpha:1.0];
            datePickerView.frame= CGRectMake(0,25, self.vc.frame.size.width, self.vc.frame.size.height-50);
            [datePickerView addTarget:self action:@selector(updateLabel:) forControlEvents:UIControlEventValueChanged];
            datePickerView.datePickerMode = UIDatePickerModeDate;
            NSDate *today = [NSDate date];
            datePickerView.date = today;
            datePickerView.datePickerMode = UIDatePickerModeDate;
            [datePickerView setMinimumDate:[NSDate date]];
            UIView *seprator1=[[UIView alloc]initWithFrame:CGRectMake(0, self.vc.frame.size.height-52, self.vc.frame.size.width, 1)];
            seprator1.backgroundColor=[UIColor lightGrayColor];
            UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [doneBtn setFrame:CGRectMake(0,self.vc.frame.size.height-50,self.vc.frame.size.width, 50)];
            [doneBtn addTarget:self action:@selector(DoneSearch) forControlEvents:UIControlEventTouchUpInside];
            doneBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            [self.vc addSubview:dateLbl];
            [self.vc addSubview:seprator];
            [self.vc addSubview:datePickerView];
            [self.vc addSubview:seprator1];
            [self.vc addSubview:doneBtn];
            [self.view addSubview:self.vc];
            [self updateLabel:self];
        }
        else
        {
            dropCell=false;
            self.backImg.hidden=YES;
            self.TopScrollView.userInteractionEnabled=YES;

            self.vc.hidden=YES;
            for(UIView *vv in self.TopScrollView.subviews)
            {
                if(vv.tag == 5000)
                {
                    [vv removeFromSuperview];
                }
            }
        }
    }
    else  if(expireBtn.tag == 3)
    {
        /*Category*/
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Coupontype"];

    if(dropCell == false)
    {
    //int YAXIS=0;
    
//    UIScrollView *scr=[[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,180,self.view.frame.size.width/2-10, 200)];
//    scr.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor darkGrayColor]);
//    scr.layer.borderWidth=2.0;
//    scr.layer.masksToBounds = YES;
//    scr.backgroundColor=[UIColor lightGrayColor];
//        long hh;
        pickerView = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-150, self.view.frame.size.width-20, 250)];
        pickerView.backgroundColor = [UIColor whiteColor ];
        pickerView.layer.cornerRadius = 8.0;
        
        pickerView.layer.masksToBounds = NO;
        pickerView.layer.shadowOffset = CGSizeMake(0, 0);
        pickerView.layer.shadowRadius = 2;
        pickerView.layer.shadowOpacity = 0.7;
        
        mPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width-20, 200)];
        mPickerView.dataSource = self;
        mPickerView.delegate = self;
        mPickerView.showsSelectionIndicator = YES;
        
        UIView *seprator1=[[UIView alloc]initWithFrame:CGRectMake(0, pickerView.frame.size.height-52, pickerView.frame.size.width, 1)];
        seprator1.backgroundColor=[UIColor lightGrayColor];
        UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneBtn setFrame:CGRectMake(0,pickerView.frame.size.height-50,pickerView.frame.size.width, 50)];
        [doneBtn addTarget:self action:@selector(DonePickerView) forControlEvents:UIControlEventTouchUpInside];
        doneBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        
        [pickerView addSubview:mPickerView];
        [pickerView addSubview:seprator1];
        [pickerView addSubview:doneBtn];

        
     if(catArr.count)
     {
    // hh=[catArr count]*35;
       // for(int k=0;k<[catArr count];k++)
//    {
//        NSMutableDictionary *dict=[catArr objectAtIndex:k];
//        UIButton *cat_view= [UIButton buttonWithType:UIButtonTypeCustom];
//        cat_view.frame=CGRectMake(0, YAXIS, scr.frame.size.width, 30);
//        [cat_view addTarget:self action:@selector(MOVENOW:) forControlEvents:UIControlEventTouchUpInside];
//       
//        cat_view.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
//        [cat_view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        cat_view.titleLabel.numberOfLines = 1;
//        cat_view.titleLabel.adjustsFontSizeToFitWidth = YES;
//        cat_view.titleLabel.lineBreakMode = NSLineBreakByClipping;
//        [scr addSubview:cat_view];
//        YAXIS=YAXIS+35;
//
//        if(k==0)
//        {
//            [cat_view setTitle:@"No Filter" forState:UIControlStateNormal];
//cat_view.tag=444;
//        }
//        else
//        {
//            [cat_view setTitle:[dict objectForKey:@"category_name"] forState:UIControlStateNormal];
//            cat_view.tag=k+1;
//        }
//    }
       // scr.contentSize=CGSizeMake(100,hh+10);
       // scr.tag=10000;
      //  [self.TopScrollView addSubview:scr];
         [self.TopScrollView addSubview:pickerView];
        //dropCell=true;
    }
    
    else
    {
    dropCell=false;
       for(UIView *vv in self.TopScrollView.subviews)
       {
           if(vv.tag == 10000)
           {
               [vv removeFromSuperview];
           }
       }
    }
    }
    }
    else if(expireBtn.tag == 4)
    {
        /* Coupon type*/
        if(dropCell == false)
        {
        //dropCell=true;
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"Coupontype"];
//        UIScrollView *scr=[[UIScrollView alloc]initWithFrame:CGRectMake(148,225, 140, 100)];
//        scr.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor darkGrayColor]);
//        scr.layer.borderWidth=2.0;
//        scr.layer.masksToBounds = YES;
//        scr.backgroundColor=[UIColor lightGrayColor];
//        scr.tag=99;
       
            pickerView = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-150, self.view.frame.size.width-20, 250)];
            pickerView.backgroundColor = [UIColor whiteColor ];
            pickerView.layer.cornerRadius = 8.0;
            
            pickerView.layer.masksToBounds = NO;
            pickerView.layer.shadowOffset = CGSizeMake(0, 0);
            pickerView.layer.shadowRadius = 2;
            pickerView.layer.shadowOpacity = 0.7;
            
            mPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width-20, 200)];
            mPickerView.dataSource = self;
            mPickerView.delegate = self;
            mPickerView.showsSelectionIndicator = YES;
            
            UIView *seprator1=[[UIView alloc]initWithFrame:CGRectMake(0, pickerView.frame.size.height-52, pickerView.frame.size.width, 1)];
            seprator1.backgroundColor=[UIColor lightGrayColor];
            UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [doneBtn setFrame:CGRectMake(0,pickerView.frame.size.height-50,pickerView.frame.size.width, 50)];
            [doneBtn addTarget:self action:@selector(DonePickerView) forControlEvents:UIControlEventTouchUpInside];
            doneBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            
            [pickerView addSubview:mPickerView];
            [pickerView addSubview:seprator1];
            [pickerView addSubview:doneBtn];

            [self.TopScrollView addSubview:pickerView];

            
//        int yy=0;
//        for(int k=0;k<[arrCouponType count];k++)
//        {
//            UIButton *cat_view= [UIButton buttonWithType:UIButtonTypeCustom];
//            cat_view.frame=CGRectMake(0, yy, 140, 30);
//            [cat_view addTarget:self action:@selector(MOVENOW:) forControlEvents:UIControlEventTouchUpInside];
//            cat_view.tag=k+1;
//            [cat_view setTitle: [arrCouponType objectAtIndex:k] forState:UIControlStateNormal];
//            cat_view.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
//            [cat_view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            cat_view.titleLabel.numberOfLines = 1;
//            cat_view.titleLabel.adjustsFontSizeToFitWidth = YES;
//            cat_view.titleLabel.lineBreakMode = NSLineBreakByClipping;
//            
//            [scr addSubview:cat_view];
//            yy=yy+30;
//        }
      //  [self.TopScrollView addSubview:scr];
        }
        else
        {
            dropCell=false;
            for(UIView *vv in self.TopScrollView.subviews)
            {
                if(vv.tag == 99)
                {
                    [vv removeFromSuperview];
                }
            }
        }
    }
    else if(expireBtn.tag == 5)
    {
        
        [SVProgressHUD showWithStatus:@"Loading.."];
        dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
        
                
//                if([arrCouponType containsObject:selectedValue] )
//                {
//                    
//                    NSMutableArray *arr=[[NSMutableArray alloc]init];
//                   if( CouponData)
//                   {
//                    for(NSMutableDictionary *dict in CouponData)
//                    {
//                        NSString *exp= [dict objectForKey:@"type"];
//                        
//                        if ([exp isEqualToString:[selectedValue lowercaseString]])
//                        {
//                            NSLog(@"exp %@ is earlier than selectedCouponType  %@",exp,selectedValue);
//                            [arr addObject:dict];
//                        }
//                    }
//                    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"selectedExpiry"];
//                   }
//                }
//                else
//                {
//                [[NSUserDefaults standardUserDefaults]setObject:selectedValue forKey:@"selectedCategory"];
//                }
                
                country = @"";
                if (!dateTxt ) {
                    dateTxt = @"No Filter";
                }
                if (!category ) {
                    category = @"No Filter";
                }
                if (!type ) {
                    type = @"No Filter";
                }
                NSMutableArray *filterData = [Helper filterData:country :dateTxt :category :type :user_id];
                [[NSUserDefaults standardUserDefaults]setObject:filterData forKey:@"selectedExpiry"];
                CategorySearchViewController *cat=[self.storyboard instantiateViewControllerWithIdentifier:@"CategorySearchViewController"];
                [self.navigationController pushViewController:cat animated:YES];
            //  [self presentViewController:cat animated:YES completion:nil];
                [SVProgressHUD dismiss];
            });
        });
    }

}
-(void)DonePickerView{
    [pickerView removeFromSuperview];
}
-(void)DoneSearch
{
   
    NSLog(@"%@",dateTxt);
    [expireBtn setTitle:dateTxt forState:UIControlStateNormal];
    dropCell=false;
    
    for(UIView *vv in self.view.subviews)
    {
        if(vv.tag == 5000)
        {
            [vv removeFromSuperview];
        }
    }
    
    self.backImg.hidden=YES;
    self.TopScrollView.userInteractionEnabled=YES;
    
    if(dateTxt.length)
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        if(arrayForDisplay.count)
        {
            for(NSMutableDictionary *dict in arrayForDisplay)
            {
                NSDateFormatter *df=[[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy/MM/dd"];
                NSDate * selectedDate = [df dateFromString:dateTxt];
                
                NSString *exp= [dict objectForKey:@"exp"];
                NSDateFormatter *df111=[[NSDateFormatter alloc]init];
                [df111 setDateFormat:@"dd/MM/yyyy"];
                NSDate * date = [df111 dateFromString:exp];
                
                if ([date compare:selectedDate] == NSOrderedAscending)
                {
                    NSLog(@"date %@ is earlier than selectedDate  %@",date,selectedDate);
                    [arr addObject:dict];
                }
            }
        }
    }
    for (UIView *view in self.CouponFilterSubView.subviews) {
        
    }
    

}

-(IBAction)MOVENOW:(id)sender
{
    
    if( [[NSUserDefaults standardUserDefaults]boolForKey:@"Coupontype"]==false)
    {
    UIButton *btn=(UIButton *)sender;
       
    NSLog(@"%ld",(long)btn.tag);
    dropCell=false;
    
    for(UIView *vv in self.CouponFilterSubView.subviews)
    {
        if(vv.tag == 3  && [vv isKindOfClass:[UIView class]])
        {
            for(UIView *vv11 in vv.subviews)
            {
                  if([vv11 isKindOfClass:[UIButton class]]  && (vv11.tag == 3 ))
                  {
            UIButton *filterBtn=(UIButton *)vv11;
                      if(btn.tag==444)
                      {
                          [filterBtn setTitle:@"No Filter" forState:UIControlStateNormal];
                          selectedValue=@"No Filter";

                      }
else
{
            NSMutableDictionary *dict=[catArr objectAtIndex:btn.tag-1];
            NSString *cat_name=[dict objectForKey:@"category_name"];
            [filterBtn setTitle:cat_name forState:UIControlStateNormal];
             selectedValue=cat_name;
            category=cat_name;

}
                }
        }
    }
        }
    for(UIView *vv in self.TopScrollView.subviews)
    {
                if(vv.tag == 10000)
                {
                    [vv removeFromSuperview];
                }
    }
    }
    else
    {
        UIButton *btn=(UIButton *)sender;
        NSLog(@"%ld",(long)btn.tag);
        dropCell=false;
        for(UIView *vv in self.CouponFilterSubView.subviews)
        {
            if(vv.tag == 4  && [vv isKindOfClass:[UIView class]])
            {
                for(UIView *vv11 in vv.subviews)
                {
                    if([vv11 isKindOfClass:[UIButton class]]  && (vv11.tag == 4 ))
                    {
                        UIButton *filterBtn=(UIButton *)vv11;
                         NSString *cat_name=[arrCouponType objectAtIndex:btn.tag-1];
                        [filterBtn setTitle:cat_name forState:UIControlStateNormal];
                        selectedValue=cat_name;
                        type = cat_name;
                    }
                }
            }
        }
        
        for(UIView *vv in self.TopScrollView.subviews)
        {
            if(vv.tag == 99)
            {
                [vv removeFromSuperview];
            }
        }
    }
}
#pragma mark- Private Methods

-(IBAction)LoadMoreAct:(id)sender
{
    //Last CouponData count
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeBlack];
    SendValue = [CouponData count];
    NSMutableArray *arr=[Helper AllCoupon:SendValue :user_id];
    NSMutableArray *arrOld = [arrayForDisplay mutableCopy];
    
    CouponData = [[NSMutableArray alloc] init];
    [CouponData addObjectsFromArray:arrOld];
    [CouponData addObjectsFromArray:arr];
    
    
    
    
    if (user_id == 1) {
        
        arrayForDisplay = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in CouponData) {
            
            if ([[dic objectForKey:@"type"] isEqualToString:@"free"]) {
                
                [arrayForDisplay addObject:dic];
                
            }
        }
    } else  {
        
        arrayForDisplay = [[NSMutableArray alloc] initWithArray:CouponData];
    }
    
    
    [self.AllCouponTbl reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - Couponfilter Methods

-(IBAction)CouponFilterAct:(id)sender
{
    [self.view endEditing:YES];
    [self closeadsView];
    MyFavBool=false;
    AllCouponBool=false;
    self.AllCouponTbl.hidden=YES;
    self.LoadMoreBtn.hidden=YES;
    self.MyFavSubView.hidden=YES;
    if(CouponFilterBool ==false)
    {
        self.CouponFilterImg.image=[UIImage imageNamed:@"dwnarr.png"];
        self.MyFavImg.image=[UIImage imageNamed:@"uparr.png"];
        self.AllCouponImg.image=[UIImage imageNamed:@"uparr.png"];
        CouponFilterBool=true;
        self.CouponFilterSubView.hidden=NO;
        self.CouponFilterView.frame=CGRectMake(0,44, self.view.frame.size.width,40);
        self.MyFavView.frame=CGRectMake(0,self.CouponFilterSubView.frame.origin.y+self.CouponFilterSubView.frame.size.height, self.view.frame.size.width,40);
        self.AllCouponView.frame=CGRectMake(0,self.MyFavView.frame.origin.y+self.MyFavView.frame.size.height, self.view.frame.size.width,40);
    }
    else
    {
        self.CouponFilterImg.image=[UIImage imageNamed:@"uparr.png"];
               self.CouponFilterSubView.hidden=YES;
        CouponFilterBool=false;
        [self layoutSubview:1];
    }
}
-(void)CoupnFilterSubView
{
    yAxis=0;
    UIView *bView;
    for (int i=0; i<[sectionArray count]; i++) {
       
        if(i ==4)
        {
            bView=[[UIView alloc]initWithFrame:CGRectMake(0,yAxis, self.view.frame.size.width,44)];
             bView.tag=i+1;
            UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom ];
            searchBtn.frame=CGRectMake(self.view.frame.size.width/2-12,10,24, 24);
            [searchBtn  setImage:[UIImage imageNamed:@"coupon_search.png"]  forState:UIControlStateNormal];
            [searchBtn addTarget:self action:@selector(DropDown:) forControlEvents:UIControlEventTouchUpInside];
            searchBtn.tag=i+1;
            [bView addSubview:searchBtn];
            [self.CouponFilterSubView addSubview:bView];
        }
        else
        {
        bView=[[UIView alloc]initWithFrame:CGRectMake(0,yAxis, self.view.frame.size.width,44)];
            bView.tag=i+1;

        UILabel *textlbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        textlbl.text=[sectionArray objectAtIndex:i];
        textlbl.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
        textlbl.textColor=[UIColor lightGrayColor];
        UIImageView *imv=[[UIImageView alloc]init];
        imv.image=[UIImage imageNamed:@"Arrow.png"];
        imv.frame=CGRectMake(120, 15, 9, 9);
     
        UIButton *filterContent=[UIButton buttonWithType:UIButtonTypeCustom ];
        filterContent.frame=CGRectMake(imv.frame.size.width+imv.frame.origin.x,5,150, 35);
        [filterContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        filterContent.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
        [filterContent setTitle:@"No Filter" forState:UIControlStateNormal];
            [filterContent addTarget:self action:@selector(DropDown:) forControlEvents:UIControlEventTouchUpInside];
            filterContent.tag=i+1;
            filterContent.titleLabel.numberOfLines = 1;
            filterContent.titleLabel.adjustsFontSizeToFitWidth = YES;
            filterContent.titleLabel.lineBreakMode = NSLineBreakByClipping;
        UIImageView *divider=[[UIImageView alloc]initWithFrame:CGRectMake(0,bView.frame.size.height+bView.frame.origin.x,self.view.frame.size.width,2)];
        divider.image=[UIImage imageNamed:@"Line"];

        [bView addSubview:textlbl];
        [bView addSubview:imv];
        [bView addSubview:filterContent];
        [bView addSubview:divider];

        [self.CouponFilterSubView addSubview:bView];
        }
        [self.TopScrollView addSubview:self.CouponFilterSubView];
        yAxis=yAxis+46;
    }
}


#pragma mark - MyFav Methods

-(IBAction)MyFavAct:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeBlack];
    [self.view endEditing:YES];
    CouponFilterBool=false;
    AllCouponBool=false;
    self.CouponFilterSubView.hidden=YES;
    self.AllCouponTbl.hidden=YES;
    self.LoadMoreBtn.hidden=YES;
    [self layoutSubview:1];
    [self closeadsView];
    if(MyFavBool ==false)
    {
        self.MyFavImg.image=[UIImage imageNamed:@"dwnarr.png"];
        self.CouponFilterImg.image=[UIImage imageNamed:@"uparr.png"];
        self.AllCouponImg.image=[UIImage imageNamed:@"uparr.png"];
        MyFavBool=true;
        self.MyFavSubView.hidden=NO;
        showBanner = false;
        imageview1.hidden = true;
        imageview2.hidden = true;
        [self CreateView];
        if(MyFavArrData.count)
        {
            [self layoutSubview:2];
        }
    }
    else
    {
        self.MyFavImg.image=[UIImage imageNamed:@"uparr.png"];
       
        [self closeadsView];
        MyFavBool=false;
        self.MyFavSubView.hidden=YES;
        showBanner = false;
       
    }
    [SVProgressHUD dismiss];
}

-(void)UserFavoriteCoupon
{
     MyFavArrData =  [Helper UserFavoriteCoupon:user_id];
    NSLog(@"MyFavArrData -%@",MyFavArrData);

}

-(void)CreateView
{
    for(UIView *viiew in self.MyFavSubView.subviews)
    {
        [viiew removeFromSuperview];
    }
if(MyFavArrData.count)
{
    yAxis=0;
    for(int ii=0;ii< [MyFavArrData count] ;ii++)
    {
        NSMutableDictionary *dict=[MyFavArrData objectAtIndex:ii];
        UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0,yAxis, self.view.frame.size.width, 70)];
        CouponViewGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CouponLocked:)];
        CouponViewGesture.numberOfTapsRequired=1;
        baseView.tag=ii+10001;
        [baseView addGestureRecognizer:CouponViewGesture];
        /*First view*/
        UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,self.view.frame.size.width*1/3-25,50)];
        NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",[dict objectForKey:@"merchant_logo"]]];
        NSRange range = [[dict objectForKey:@"merchant_logo"] rangeOfString:@"."];
        NSString *newString = [[dict objectForKey:@"merchant_logo"] substringToIndex:range.location];
        NSString *myCacheKey=[NSString stringWithFormat:@"%@.png",newString];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
            if(image !=nil)
            {
                logo.image=image;
            }
            else
            {
                [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    CGSize destinationSize = CGSizeMake(240, 150);
                    UIGraphicsBeginImageContext(destinationSize);
                    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    [imageCache  storeImage:newImage forKey:myCacheKey];
                    logo.image=image;
                }];
            }
        }];
        infoTapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MoveView:)];
        infoTapGes.numberOfTapsRequired=1;
        logo.userInteractionEnabled=YES;
        logo.tag=ii+10001;
        [logo addGestureRecognizer:infoTapGes];
        UIImageView *seprator=[[UIImageView alloc]initWithFrame:CGRectMake(logo.frame.origin.x+logo.frame.size.width+10,5,1,baseView.frame.size.height-10)];
        seprator.image=[UIImage imageNamed:@"divider-1"];
        
        /*second view*/
        
        UILabel *LogoName=[[UILabel alloc]initWithFrame:CGRectMake(logo.frame.origin.x+logo.frame.size.width+15,5,self.view.frame.size.width*1/3-5, 14)];
       // LogoName.backgroundColor=[UIColor greenColor];
        LogoName.text=[dict objectForKey:@"merchant_name"];
        LogoName.adjustsFontSizeToFitWidth=YES;
        LogoName.minimumScaleFactor=0.5;
        LogoName.textColor=[UIColor grayColor];
        LogoName.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
        
        UILabel *categoryName=[[UILabel alloc]initWithFrame:CGRectMake(logo.frame.origin.x+logo.frame.size.width+15,19,self.view.frame.size.width*1/3-5, 10)];
        //categoryName.backgroundColor=[UIColor purpleColor];
        categoryName.text=[dict objectForKey:@"merchant_category"];
        categoryName.adjustsFontSizeToFitWidth=YES;
        categoryName.minimumScaleFactor=0.7;
        categoryName.textColor=[UIColor colorWithRed:(126.0 / 255.0) green:(189.0 / 255.0) blue:(86.0 / 255.0) alpha:1.0];
        
        categoryName.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:8.0];
        
        UIImageView *timerImg=[[UIImageView alloc]initWithFrame:CGRectMake(logo.frame.origin.x+logo.frame.size.width+15,47,20,20)];
        timerImg.image=[UIImage imageNamed:@"expire.png"];
        UILabel *expiryDate=[[UILabel alloc]initWithFrame:CGRectMake(logo.frame.origin.x+logo.frame.size.width+40,45,self.view.frame.size.width*1/3-40, 20)];
        //expiryDate.backgroundColor=[UIColor orangeColor];
        expiryDate.text=[dict objectForKey:@"exp"];
        expiryDate.adjustsFontSizeToFitWidth=YES;
        expiryDate.minimumScaleFactor=0.7;
        expiryDate.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:8.0];
        
        
        UIImageView *seprator1=[[UIImageView alloc]initWithFrame:CGRectMake(LogoName.frame.origin.x+LogoName.frame.size.width+5,5,1,baseView.frame.size.height-10)];
        seprator1.image=[UIImage imageNamed:@"divider-1"];
        
        /*third view*/
        
        UITextView *Shorttitle=[[UITextView alloc]initWithFrame:CGRectMake(LogoName.frame.origin.x+LogoName.frame.size.width+10,5,self.view.frame.size.width*1/3-35, 60)];
       // Shorttitle.backgroundColor=[UIColor orangeColor];
        Shorttitle.text=[dict objectForKey:@"title"];
        Shorttitle.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
        Shorttitle.userInteractionEnabled=NO;
        
        UIButton *star=[UIButton buttonWithType:UIButtonTypeCustom];
    
        [star setFrame:CGRectMake(Shorttitle.frame.origin.x+Shorttitle.frame.size.width,baseView.frame.size.height/2-10,25,20)];
        [star setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal ];
        [star addTarget:self action:@selector(AddCouponToFavorite:) forControlEvents:UIControlEventTouchUpInside];
        star.tag=ii+1;
        
        NSLog(@"yAxis -%d",yAxis);
        
        
        yAxis=yAxis+70;
        UIView *divider=[[UIView alloc]initWithFrame:CGRectMake(10,yAxis,self.view.frame.size.width,2)];
        yAxis=yAxis+2;
        //divider.image=[UIImage imageNamed:@"Line"];
        divider.backgroundColor=[UIColor lightGrayColor];
        [baseView addSubview:logo];
        [baseView addSubview:seprator];
        [baseView addSubview:LogoName];
        [baseView addSubview:categoryName];
        [baseView addSubview:seprator1];
        [self.MyFavSubView addSubview:divider];
        [baseView addSubview:timerImg];
        [baseView addSubview:expiryDate];
        [baseView addSubview:Shorttitle];
        [baseView addSubview:star];
        [self.MyFavSubView addSubview:baseView];
    }
     [self.TopScrollView addSubview:self.MyFavSubView];
}else if (MyFavArrData.count==0){
    
    [self MyFavAct:self];
}
}


#pragma mark - AllCoupon Methods

-(IBAction)AllCouponAct:(id)sender
{
    [self.view endEditing:YES];
    self.CouponFilterSubView.hidden=YES;
    CouponFilterBool=false;
    MyFavBool=false;
    self.MyFavSubView.hidden=YES;

    [self layoutSubview:1];
    if(AllCouponBool ==false)
    {
        self.AllCouponImg.image=[UIImage imageNamed:@"dwnarr.png"];
        self.MyFavImg.image=[UIImage imageNamed:@"uparr.png"];
        self.CouponFilterImg.image=[UIImage imageNamed:@"uparr.png"];

        AllCouponBool=true;
        showBanner = true;
        self.AllCouponTbl.hidden=NO;
        self.LoadMoreBtn.hidden=NO;
       

    }
    else
    {
        self.AllCouponImg.image=[UIImage imageNamed:@"uparr.png"];

        AllCouponBool=false;
        showBanner = false;
        self.AllCouponTbl.hidden=YES;
        self.LoadMoreBtn.hidden=YES;
        [self closeadsView];
       
    }
}

-(IBAction)AddCouponToFavorite:(id)sender
{
    
    UIButton *button = (UIButton*)sender;
    NSMutableDictionary *dict;
    int fav;
    NSString *responseString;
    NSInteger  coupon_id = 0;
    NSString *urlStr;
    NSMutableArray *arr;
    
    if(AllCouponBool == true)
    {
        if(arrayForDisplay.count)
        {
            dict=[[arrayForDisplay objectAtIndex:button.tag-1] mutableCopy] ;
            
            fav=[[dict objectForKey:@"fav"]intValue];
            
            coupon_id=[[dict objectForKey:@"id"]integerValue];
            
            if(fav  ==  0)
            {
                [SVProgressHUD showWithStatus:@"Please Wait.." maskType:SVProgressHUDMaskTypeBlack];
                /* AddCouponFavorite */
                [SVProgressHUD showWithStatus:@"Please wait.." maskType:SVProgressHUDMaskTypeBlack];
                urlStr=@"http://couponcms.ontwikkelomgeving.info/add_favourite_coupon";
                arr=[Helper GetCoupons:coupon_id : user_id :urlStr];
                if(arr.count)
                {
                    responseString=[[arr objectAtIndex:0]objectForKey:@"msg"];
                    if([responseString isEqualToString:@"Coupon is successfully added to your favourite"])
                    {
                        id favValue = @"1" ;
                        [dict setValue:favValue forKey:@"fav"];
                        NSMutableArray *arr = [arrayForDisplay mutableCopy];
                        [arr replaceObjectAtIndex:button.tag-1 withObject:dict];
                        arrayForDisplay=[[NSMutableArray alloc]init];
                        [arrayForDisplay addObjectsFromArray:arr];
                        [self UserFavoriteCoupon];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag-1 inSection:0];
                        
                        [self.AllCouponTbl  reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                  withRowAnimation:UITableViewRowAnimationNone];
                        [SVProgressHUD dismiss];
                        UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Coupon is successfully added to your favorite" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [showAlert show];
                    }
                    else if([responseString isEqualToString:@"Coupon already added to favourite"])
                    {
                        [SVProgressHUD dismiss];
                        UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Coupon already added to favourite" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [showAlert show];
                    }
                }
            }
            
        }
    }
    if(MyFavBool ==true)
    {
        [SVProgressHUD showWithStatus:@"Please wait.." maskType:SVProgressHUDMaskTypeBlack];
        if(MyFavArrData.count)
        {
            dict=[[MyFavArrData objectAtIndex:button.tag-1] mutableCopy] ;
            coupon_id=[[dict objectForKey:@"id"]integerValue];
            //responseString=[Helper UnFavoriteCoupon1:user_id :coupon_id];
            urlStr=@"http://couponcms.ontwikkelomgeving.info/coupon_unfavourite";
            
            responseString=[Helper UnFavoriteCoupon1:user_id :coupon_id :urlStr];
            //        “success” or “unsuccess”
            if([responseString isEqualToString:@"success"])
            {
                
                [self UserFavoriteCoupon];
                [self CreateView];
                if(MyFavArrData.count)
                {
                    [self layoutSubview:2];
                }
                
                [SVProgressHUD dismiss];
                UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Coupon is successfully unfavourite" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
                
            }
            else if([responseString isEqualToString:@"unsuccess"])
            {
                [SVProgressHUD dismiss];
                UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Coupon already unfavourite" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            }
        }
    }
    
}

-(void)AllCoupon
{
    SendValue=0;
    //{value: 0, user_id: value}
    CouponData= [Helper AllCoupon:SendValue :user_id];
    
    if(CouponData.count)
    {
        NSLog(@"before coupon data = %@", CouponData);
        merchant_categoryArr=[[NSMutableArray alloc]init];
        for(NSMutableDictionary *dict in CouponData)
        {
            NSString *merchant_category=[dict objectForKey:@"merchant_category"];
            NSString *merchant_name=[dict objectForKey:@"merchant_name"];
            
            if (![merchant_categoryArr containsObject:merchant_category] || ![merchant_categoryArr containsObject:merchant_name])
            {
                [merchant_categoryArr addObject:merchant_category];
                [merchant_categoryArr addObject:merchant_name];
                
            }
        }
        //    NSLog(@"merchant_categoryArr -%@",merchant_categoryArr);
        
        if (user_id == 1) {
            
            arrayForDisplay = [[NSMutableArray alloc] init];
            
            for (int i=0; i<CouponData.count; i++) {
                
                NSDictionary *dic = [CouponData objectAtIndex:i];
                
                if ([[dic objectForKey:@"type"] isEqualToString:@"free"]) {
        
                    [arrayForDisplay addObject:dic];
                }
            }
            
            
            NSLog(@"After removed = %@", CouponData);
            
        } else {
            
            arrayForDisplay = [[NSMutableArray alloc] initWithArray:CouponData];
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"SELF contains[c] %@",
                              searchText];
//    for (NSString *str in merchant_categoryArr) {
//        
//    }
    filteredArray = [merchant_categoryArr filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",filteredArray);
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.TopSearchBAr resignFirstResponder];
    // Do the search...
 
        
        country = [searchBar.text lowercaseString];
        NSMutableArray *filterData = [Helper search:country:user_id];
    [[NSUserDefaults standardUserDefaults]setObject:filterData forKey:@"searchText"];
        CategorySearchViewController *cat=[self.storyboard instantiateViewControllerWithIdentifier:@"CategorySearchViewController"];
        [self.navigationController pushViewController:cat animated:YES];
      //  [self presentViewController:cat animated:YES completion:nil];
    
}

-(void)showRandomBanner
{
    
    bannerdata =  [Helper randomBanner];
    imageArray =[[NSMutableArray alloc]init];
    for (NSMutableDictionary *dict in bannerdata) {
        NSString *imageName =[dict valueForKey:@"image"];
        NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",imageName]];
        NSRange range = [imageName rangeOfString:@"."];
        NSString *newString = [imageName substringToIndex:range.location];
        
        NSString *myCacheKey=[NSString stringWithFormat:@"%@.png",newString];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
            if(image !=nil)
            {
                NSData *pictureData=UIImagePNGRepresentation(image);
                [imageArray addObject:pictureData];
                if(imageArray.count == bannerdata.count){
                [self performSelector:@selector(bannerAnimation) withObject:nil afterDelay:3.0];
                }

            }
            else
            {
                [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    CGSize destinationSize = CGSizeMake(240, 150);
                    UIGraphicsBeginImageContext(destinationSize);
                    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    [imageCache  storeImage:newImage forKey:myCacheKey];
                    NSData *pictureData=UIImagePNGRepresentation(image);
                    [imageArray addObject:pictureData];
                   // [self bannerAnimation];
                    [self performSelector:@selector(bannerAnimation) withObject:nil afterDelay:6.0];

                }];
            }
        }];
       

       // [self bannerAnimation];

    }
       NSLog(@"bannr data -%@",bannerdata);
}
-(void)bannerAnimation{
    if (imageArray.count) {
        imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-235, self.view.frame.size.width, 200)];
        imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height-235, self.view.frame.size.width, 200)];
        closeAds=[UIButton buttonWithType:UIButtonTypeCustom];
        closeAds.frame = CGRectMake(self.view.frame.size.width-30, self.view.frame.size.height-225, 25, 25);
        [closeAds setTitle:@"X" forState:UIControlStateNormal];
        [closeAds addTarget:self action:@selector(closeadsView) forControlEvents:UIControlEventTouchUpInside];
        [closeAds setBackgroundColor:[UIColor lightGrayColor]];
        
        imageview1.tag= 999;
        imageview2.tag = 999;
        closeAds.tag = 999;
        [self.view addSubview:imageview1];
        [self.view addSubview:imageview2];
        [self.view addSubview:closeAds];
        [self.view bringSubviewToFront:closeAds];
        
        imageview1.image = [UIImage imageWithData:[imageArray objectAtIndex:arc4random() % [imageArray count]]];
        imageview2.image = [UIImage imageWithData:[imageArray objectAtIndex:arc4random() % [imageArray count]]];
        [self performSelector:@selector(startBannerAnimation) withObject:nil afterDelay:5.0];
   
    }
}

-(void)startBannerAnimation{
    if (showBanner == true) {
            [UIView animateWithDuration:3.0 delay:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                imageview1.frame= CGRectMake(0, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                
                imageview1.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                
                imageview2.frame =CGRectMake(self.view.frame.size.width, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                
                imageview2.frame= CGRectMake(0, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                
               
            } completion:^(BOOL finished) {
                [imageview1 removeFromSuperview];
                if (showBanner == true) {
                    
                
                imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height-235, self.view.frame.size.width, 200)];
                imageview1.tag= 999;

                [self.view addSubview:imageview1];
                [self.view bringSubviewToFront:closeAds];

                imageview1.image = [UIImage imageWithData:[imageArray objectAtIndex:arc4random() % [imageArray count]]];
                [UIView animateWithDuration:3.0 delay:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    imageview1.frame= CGRectMake(self.view.frame.size.width, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                    
                    imageview1.frame = CGRectMake(0, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                    imageview2.frame= CGRectMake(0, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                    imageview2.frame =CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-235, self.view.frame.size.width, 200);
                
                }
                 completion:^(BOOL finished) {
                    [imageview2 removeFromSuperview];
                    imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height-235, self.view.frame.size.width, 200)];
                    imageview2.tag= 999;

                    [self.view addSubview:imageview2];
                    [self.view bringSubviewToFront:closeAds];

                    imageview2.image = [UIImage imageWithData:[imageArray objectAtIndex:arc4random() % [imageArray count]]];
                     [self performSelector:@selector(startBannerAnimation) withObject:nil afterDelay:5.0];


            }];
                }
            }];
    }
}

-(void)closeadsView{
    
    showBanner = false;
    [self.view.layer removeAllAnimations];
    for (UIView *view in self.view.subviews) {
        if (view.tag == 999) {
            [view removeFromSuperview];
        }
    }
    NSLog(@"clode add");
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [imageCache clearMemory];
    [imageCache clearDisk];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.

@end
