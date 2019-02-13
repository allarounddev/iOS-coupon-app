//
//  SettingViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 16/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "SettingViewController.h"
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "SettingSubViewController.h"
#import "Helper.h"
@interface SettingViewController ()
{
    NSArray *sectionArray;
    NSArray *firstArr;
    NSArray *secondArr;
    NSInteger user_id;
    NSInteger statusVal;
    NSMutableArray *cehckNotificArr;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
     self.navigationController.navigationItem.hidesBackButton=YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menu setTarget:self.revealViewController];
        [self.menu setAction:@selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    user_id= [[NSUserDefaults standardUserDefaults]integerForKey:@"user_id"];
   }
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [emailLbl resignFirstResponder];
    [feedbackLbl resignFirstResponder];
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
//    dispatch_queue_t queue = dispatch_queue_create("com.example.MyQueue", NULL);
//    dispatch_async(queue, ^{
        // Do some computation here.
          cehckNotificArr=[Helper checkNotioficSatus:user_id];
        [self.settingTbl reloadData];
        // Update UI after computation.
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    });

 
    if( [[NSUserDefaults standardUserDefaults]boolForKey:@"Feedback"])
    {
        UITapGestureRecognizer *gestureRec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
        [gestureRec setNumberOfTouchesRequired:1];
        
        [self.view addGestureRecognizer:gestureRec];
        self.navigationItem.title=@"FEEDBACK";
        self.settingTbl.hidden=YES;
        feedbackView.hidden=NO;
        topLbl.frame=CGRectMake(10,0, self.view.frame.size.width-20,40);
        topLbl.text=[NSString stringWithFormat:@"We really appreciate your feedback!\nEnjoy  your discount"];
        
        bottomLbl.frame=CGRectMake(10,topLbl.frame.origin.y+topLbl.frame.size.height, self.view.frame.size.width-20,20);
        sepratorTop2.frame=CGRectMake(0,bottomLbl.frame.origin.y+bottomLbl.frame.size.height, self.view.frame.size.width,2);
        emailLbl.frame=CGRectMake(10,sepratorTop2.frame.origin.y+sepratorTop2.frame.size.height, self.view.frame.size.width-20,50);
        emailLbl.minimumFontSize=8.0;
        
        sepratorMid.frame=CGRectMake(0,emailLbl.frame.origin.y+emailLbl.frame.size.height, self.view.frame.size.width,2);
        feedbackLbl.frame=CGRectMake(10,sepratorMid.frame.origin.y+sepratorMid.frame.size.height, self.view.frame.size.width-20,50);
        feedbackLbl.minimumFontSize=8.0;
        
        sepratorEnd.frame=CGRectMake(0,feedbackLbl.frame.origin.y+feedbackLbl.frame.size.height, self.view.frame.size.width,2);
        
        sendFeedback.frame=CGRectMake(0,sepratorEnd.frame.origin.y+sepratorEnd.frame.size.height, self.view.frame.size.width,50);
    }
    else
    {
        self.settingTbl.frame=CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-64);
        self.navigationItem.title=@"SETTING";
        self.settingTbl.hidden=NO;
        feedbackView.hidden=YES;
        firstArr=[NSArray arrayWithObjects:@"Version",@"Website",@"Redeeming Coupons",@"Terms & Conditions", nil];
        secondArr=[NSArray arrayWithObjects:@"All Notification",@"New Coupons",@"Coupons Expiring", nil];
        [self.settingTbl reloadData];
    }
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Website"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"RedemeeCoupon"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Terms"];
}

-(IBAction)sendFeedback:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (emailLbl.text.length==0)
            {
                UIAlertView *mPasswordAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter email " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [mPasswordAlert show];
            }
            else if (feedbackLbl.text.length==0)
            {
                UIAlertView *mPasswordAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter feedback " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [mPasswordAlert show];
            }
            else
            {

    NSString *post = [NSString stringWithFormat:@"email=%@&message=%@",emailLbl.text,feedbackLbl.text];
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/feedback"]];
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
       NSString *responseStr=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        if([responseStr isEqualToString:@"Feedback send successfully"])
        {
            UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"Feedback send successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alv show];
            emailLbl.text=@"";
            feedbackLbl.text=@"";
        }
    }
            }
                [SVProgressHUD dismiss];
            });
        });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger val = 0;
    switch (section)
    {
        case 0:
           val = [firstArr count];
            break;
        case 1:
           val=  [secondArr count];
            break;
    }
 return val;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str;
    switch (section)
    {
        case 0:
            str=@"ABOUT";
            break;
        case 1:
 str=@"NOTIFICATIONS";
            break;
    }
    return str;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *Str;
     UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(20,7,170,30)];
    name.textColor=[UIColor lightGrayColor];
    name.tag=indexPath.row+1;
    name.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
  
  
    UISwitch *onoff = [[UISwitch alloc] initWithFrame: CGRectMake(self.view.frame.size.width-60, 6, 49, 31)];
    for(UIView *vview in cell.contentView.subviews)
    {
        if(vview.tag ==indexPath.row+1)
        {
            [vview removeFromSuperview];
        }
    }

    switch ([indexPath section]) {
        case 0:
            Str=[firstArr objectAtIndex:indexPath.row];
            if([Str isEqualToString:@"Version"])
            {
                UILabel *vLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, 0, 30, 30)];
                vLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
                vLbl.textColor=[UIColor lightGrayColor];
                vLbl.tag=indexPath.row+1;
                vLbl.text=@"1.0";
                [cell.contentView addSubview:vLbl];
            }
            else
            {
                UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30,12,12, 15)];
                imv.image=[UIImage imageNamed:@"rightaro"];
                imv.tag=indexPath.row+1;
                [cell.contentView addSubview:imv];
            }
            break;
        case 1:
            Str=[secondArr objectAtIndex:indexPath.row];
            [onoff addTarget: self action: @selector(flip:) forControlEvents: UIControlEventValueChanged];
            onoff.tag=indexPath.row+1;
            [cell.contentView addSubview:onoff];
             NSString *urlStr;
            if( onoff.tag==1 )
            {
                urlStr=@"http://couponcms.ontwikkelomgeving.info/all_notification_status";
                if(cehckNotificArr.count)
                {
                statusVal=[[[cehckNotificArr objectAtIndex:0] objectForKey:@"all_not_status"]integerValue];
                if(statusVal ==0)
                {
                    [onoff setOn:NO animated:YES];
                }
                else if(statusVal == 1)
                {
                    [onoff setOn:YES animated:YES];
                }
                }
            }
            else if( onoff.tag==2 )
            {
                urlStr=@"http://couponcms.ontwikkelomgeving.info/new_coupon_notification_status";
                if(cehckNotificArr.count)
                {
                statusVal=[[[cehckNotificArr objectAtIndex:0] objectForKey:@"new_coupon_notification_status"]integerValue];
                if(statusVal ==0)
                {
                    [onoff setOn:NO animated:YES];
                }
                else if(statusVal == 1)
                {
                    [onoff setOn:YES animated:YES];
                }
                }
            }
            else if( onoff.tag==3 )
            {
                urlStr=@"http://couponcms.ontwikkelomgeving.info/expire_coupon_notification_status";
                if(cehckNotificArr.count)
                {
                statusVal=[[[cehckNotificArr objectAtIndex:0] objectForKey:@"expire_coupon_notification_status"]integerValue];
                if(statusVal ==0)
                {
                    [onoff setOn:NO animated:YES];
                }
                else if(statusVal == 1)
                {
                    [onoff setOn:YES animated:YES];
                }
                }
            }
            
            break;
       
    }
   
    name.text=Str;
    [cell.contentView addSubview:name];

    // Set the desired frame location of onoff here
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingSubViewController *cat=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingSubViewController"];

    switch ([indexPath section]) {
        case 0:
            if(indexPath.row == 1)
            {
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"Website"];
                [self presentViewController:cat animated:YES completion:nil];

            }
            else if(indexPath.row ==2)
            {
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"RedemeeCoupon"];
                [self presentViewController:cat animated:YES completion:nil];

            }
            else if(indexPath.row ==3)
            {
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"Terms"];
                [self presentViewController:cat animated:YES completion:nil];

            }

            else if(indexPath.row ==4)
            {
               InviteViewController *invite = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
                [self presentViewController:invite animated:YES completion:nil];

            }

            break;
        case 1:
            if(indexPath.row == 0)
            {
               
            }
            else if(indexPath.row ==1)
            {
                
            }
            else if(indexPath.row ==1)
            {
                
            }

            break;
        default:
            break;
    }
 
  
}
- (IBAction) flip: (id) sender
{
    NSString *urlStr;
    NSString *val;
    NSString *notificationType;

    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
   if( onoff.tag==1 )
   {
       urlStr=@"http://couponcms.ontwikkelomgeving.info/all_notification_status";
       notificationType = @"all_not_status";
       if(cehckNotificArr.count)
       {
       statusVal=[[[cehckNotificArr objectAtIndex:0] objectForKey:@"all_not_status"]integerValue];
       if(statusVal ==0)
       {
           val=@"checked";
       }
       else if(statusVal == 1)
       {
           val=@"unchecked";
       }
           [Helper ALLNotificationStatus:user_id :val :urlStr :notificationType];
       }
   }
    else if( onoff.tag==2 )
    {
        urlStr=@"http://couponcms.ontwikkelomgeving.info/new_coupon_notification_status";
        notificationType = @"new_coupon_not_status";

        if(cehckNotificArr.count)
        {
        statusVal=[[[cehckNotificArr objectAtIndex:0] objectForKey:@"new_coupon_notification_status"]integerValue];
        if(statusVal ==0)
        {
            val=@"checked";
        }
        else if(statusVal == 1)
        {
            val=@"unchecked";
        }
            [Helper ALLNotificationStatus:user_id :val :urlStr :notificationType];
        }
    }
    else if( onoff.tag==3 )
    {
        NSString *val;
        urlStr=@"http://couponcms.ontwikkelomgeving.info/expire_coupon_notification_status";
        notificationType = @"expire_coupon_not_status";

        if(cehckNotificArr.count)
        {
        statusVal=[[[cehckNotificArr objectAtIndex:0] objectForKey:@"expire_coupon_notification_status"]integerValue];
        if(statusVal ==0)
        {
            val=@"checked";
        }
        else if(statusVal == 1)
        {
            val=@"unchecked";
        }
            [Helper ALLNotificationStatus:user_id :val :urlStr :notificationType];
        }
    }
    [Helper checkNotioficSatus:user_id];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
