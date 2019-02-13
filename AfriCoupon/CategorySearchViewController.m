//
//  CategorySearchViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 21/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "CategorySearchViewController.h"
#import "Helper.h"
#import "AllCouponTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TAbInfoClassViewController.h"
#import "SVProgressHUD.h"
@interface CategorySearchViewController ()
{
    UINavigationBar *navbar;
    UINavigationItem* navItem ;
    NSMutableArray *categoryArr;
    NSInteger userID;

    NSMutableArray *arrayForDisplay;
}
@end

@implementation CategorySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
   // navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    /* Create navigation item object & set the title of navigation bar. */
   // navItem = [[UINavigationItem alloc] init];
    
    self.navigationItem.title = @"SEARCH RESULT";
   // navItem.title=@"Search View";
    /* Create left button item. */
//    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
//    
//    navItem.leftBarButtonItem = cancelBtn;
    
    /* Assign the navigation item to the navigation bar.*/
    //[navbar setItems:@[navItem]];
    
    /* add navigation bar to the root view.*/
   // [self.view addSubview:navbar];
   userID=[[NSUserDefaults standardUserDefaults]integerForKey:@"user_id"];
    merchant_categoryArr=[[NSMutableArray alloc]init];

    categorySerachTblView.frame=CGRectMake(0, 112, self.view.frame.size.width, self.view.frame.size.height-100);
   if([[NSUserDefaults standardUserDefaults]objectForKey:@"selectedExpiry"])
   {
       categoryArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedExpiry"];
   }
  else if( [[NSUserDefaults standardUserDefaults]objectForKey :@"searchText"])
  {
      categoryArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"searchText"];
  }
    else
    {
         NSString *cat_name= [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedCategory"];
        categoryArr= [Helper searchCategory:cat_name :userID];
    }
    
    if (userID == 1) {
        
        arrayForDisplay = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in categoryArr) {
            
            if ([[dic objectForKey:@"type"] isEqualToString:@"free"]) {
                
                [arrayForDisplay addObject:dic];
            }
        }
        
    } else  {
        
        arrayForDisplay = [[NSMutableArray alloc] initWithArray:categoryArr];
    }

    
    
    UITapGestureRecognizer *gestureRec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [gestureRec setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:gestureRec];
    

    // Do any additional setup after loading the view.
}
-(IBAction)back :(id)sender
{
    self.navigationController.navigationBarHidden=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedExpiry"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey :@"selectedCategory"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"searchText"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    NSMutableDictionary *dict=[arrayForDisplay objectAtIndex:indexPath.row];
    cell.logo.frame=CGRectMake(10,10,self.view.frame.size.width*1/3-25,50);
    
    
    NSURL *fileUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://couponcms.ontwikkelomgeving.info/public/Images/%@",[dict objectForKey:@"merchant_logo"]]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *imageCache = [[SDImageCache alloc] initWithNamespace:@"myNamespace"];
    NSString *myCacheKey=[dict objectForKey:@"merchant_logo"];
    [imageCache queryDiskCacheForKey:myCacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
        if(image !=nil)
        {
            cell.logo.image=image;
        }
        else
        {
            [manager downloadImageWithURL:fileUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                [imageCache  storeImage:image forKey:[dict objectForKey:@"merchant_logo"]];
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
    
    cell.timerImg.frame=CGRectMake(cell.logo.frame.origin.x+cell.logo.frame.size.width+15,47,20,20);
    cell.timerImg.image=[UIImage imageNamed:@"expire.png"];
    
    cell.expiryDate.frame=CGRectMake(cell.logo.frame.origin.x+cell.logo.frame.size.width+40,45,self.view.frame.size.width*1/3-40, 20);
    cell.expiryDate.text=[dict objectForKey:@"exp"];
    
    cell.seprator1.frame=CGRectMake(cell.LogoName.frame.origin.x+cell.LogoName.frame.size.width+5,5,1,  self.view.frame.size.height-10);
    cell.seprator1.image=[UIImage imageNamed:@"divider-1"];
    
    cell.Shorttitle.frame=CGRectMake(cell.LogoName.frame.origin.x+cell.LogoName.frame.size.width+10,0,self.view.frame.size.width*1/3-30,cell.frame.size.height);
    cell.Shorttitle.text=[dict objectForKey:@"shorttitle"];
    
    [cell.star setFrame:CGRectMake(self.view.frame.size.width-25,cell.frame.size.height/2-10,25,20)];
    if([[dict objectForKey:@"fav"]intValue] == 0)
    {
        [ cell.star setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal ];
    }
    else
    {
        [ cell.star setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal ];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"usertype"]) {
        cell.unlock.frame = CGRectMake(self.view.frame.size.width-37,cell.frame.size.height/2+10,35,20);
        if ([[dict objectForKey:@"type"] isEqualToString:@"premium"]) {
            cell.unlock.image = [UIImage imageNamed:@"locked_icon"];
        }else{
            cell.unlock.image = [UIImage imageNamed:@""];
            
        }
    }
    [ cell.star addTarget:self action:@selector(AddCouponToFavorite:) forControlEvents:UIControlEventTouchUpInside];
    cell.star.tag=indexPath.row+1;
    cell.divider.frame=CGRectMake(10,cell.frame.size.height-2,self.view.frame.size.width,2);
    
    
    
    
    return cell;
}
-(IBAction)AddCouponToFavorite:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIButton *button = (UIButton*)sender;
            NSMutableDictionary *dict;
            int fav;
            NSString *responseString;
            NSInteger  coupon_id = 0;
            NSString *urlStr;
            NSMutableArray *arr;
         
            
            dict=[[arrayForDisplay objectAtIndex:button.tag-1]mutableCopy] ;
                fav=[[dict objectForKey:@"fav"]intValue];
                
                coupon_id=[[dict objectForKey:@"id"]integerValue];
                
                if(fav  ==  0)
                {
                    /* AddCouponFavorite */
                    urlStr=@"http://couponcms.ontwikkelomgeving.info/add_favourite_coupon";
                    arr=[Helper GetCoupons:coupon_id : userID :urlStr];
                    if(arr.count)
                    {
                    responseString=[[arr objectAtIndex:0]objectForKey:@"msg"];
                    if([responseString isEqualToString:@"Coupon is successfully added to your favourite"])
                    {
                        UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Coupon is successfully added to your favorite" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [showAlert show];
                        id favValue = @"1" ;
                        [dict setValue:favValue forKey:@"fav"];
                        NSMutableArray *arr=[arrayForDisplay mutableCopy];
                        [arr replaceObjectAtIndex:button.tag-1 withObject:dict];
                        arrayForDisplay=[[NSMutableArray alloc] init];
                        [arrayForDisplay addObjectsFromArray:arr];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag-1 inSection:0];
                        
                        [categorySerachTblView  reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                  withRowAnimation:UITableViewRowAnimationNone];
                    }
                    else if([responseString isEqualToString:@"Coupon already added to favourite"])
                    {
                        UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Coupon already added to favourite" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [showAlert show];
                    }
            }
                }
            [SVProgressHUD dismiss];
        });
    });
}


-(void)MoveView:(UITapGestureRecognizer*)sender {
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIView *view = sender.view;
            NSLog(@"%ld", (long)view.tag);
            NSMutableDictionary *dict;
            dict=[arrayForDisplay objectAtIndex:(long)view.tag-1];
            TAbInfoClassViewController *tabInfo=[self.storyboard instantiateViewControllerWithIdentifier:@"TAbInfoClassViewController"];
            [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"CouponLocked"];
            [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"dict"];
            [self  presentViewController:tabInfo animated:YES completion:nil];
            [SVProgressHUD dismiss];
        });
    });

}

-(void)CouponLocked:(UITapGestureRecognizer*)sender
{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            UIView *view = sender.view;
            NSLog(@"%ld", (long)view.tag);
            NSMutableDictionary *dict;
            NSString *name;
            NSMutableArray *array =[NSMutableArray new];
            
            dict=[arrayForDisplay objectAtIndex:(long)view.tag-1];
            [array addObject:dict];
            name=[dict valueForKey:@"merchant_name"];
            
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
            [SVProgressHUD dismiss];
        });
    });

}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"SELF contains[c] %@",
                              searchText];
    NSMutableArray *arr= [[NSUserDefaults standardUserDefaults]objectForKey :@"merchant_categoryArr"];
    
    filteredArray = [arr filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",filteredArray);
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [categorySearchbar resignFirstResponder];
    // Do the search...
    
    for(NSMutableDictionary *dict in arrayForDisplay)
    {
        NSString *exp=[dict objectForKey:@"merchant_category"];
        if ([filteredArray containsObject:exp])
        {
            [merchant_categoryArr addObject:dict];
        }
    }
    NSLog(@"%@",merchant_categoryArr);
    [categorySerachTblView reloadData];
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
