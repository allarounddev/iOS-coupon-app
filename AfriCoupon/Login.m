//
//  Login.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "Login.h"
#import "MainViewConroller.h"
#import "ForgetPasswordVC.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

@interface Login ()
{
    UIAlertView *showAlert;
}
@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Test
    
    
    
    
    /*Keybard Hide */
    UITapGestureRecognizer *gestureRec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [gestureRec setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:gestureRec];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.emailTxtFld.text=@"";
    self.passwordTxtFld.text=@"";
    self.navigationController.navigationBarHidden=YES;
    [self layoutSubview];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}
#pragma mark -Private Methods
-(void)layoutSubview
{
    if (HEIGHT < 500) {
        logoImage.frame = CGRectMake(0, 15, WIDTH, WIDTH-90);
        forgetPassword.frame =CGRectMake(WIDTH-140, HEIGHT-40, 123, 30);
        _SkipBtn.frame = CGRectMake(WIDTH-300, HEIGHT-40, 150, 30);
        

    }else{
        logoImage.frame = CGRectMake(0, 15, WIDTH, WIDTH-70);
        forgetPassword.frame =CGRectMake(WIDTH-140, HEIGHT-50, 123, 30);
        _SkipBtn.frame = CGRectMake(WIDTH-300, HEIGHT-50, 150, 30);

    }
    
    welcome.frame = CGRectMake(0, HEIGHT/2, WIDTH, 25);
    self.emailTxtFld.frame=CGRectMake(0,HEIGHT/2+30, WIDTH,40);
    
    UIImageView *seprator=[[UIImageView alloc]initWithFrame:CGRectMake(0,  self.emailTxtFld.frame.size.height+self.emailTxtFld.frame.origin.y, self.view.frame.size.width,2)];
    seprator.image=[UIImage imageNamed:@"Seprator.png"];
    
    self.passwordTxtFld.frame=CGRectMake(0, self.emailTxtFld.frame.origin.y+self.emailTxtFld.frame.size.height+10,self.view.frame.size.width, 40);
    UIImageView *seprator1=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.passwordTxtFld.frame.size.height+self.passwordTxtFld.frame.origin.y, self.view.frame.size.width,2)];
    seprator1.image=[UIImage imageNamed:@"Seprator.png"];
    
    self.LoginBtn.frame=CGRectMake(self.view.frame.size.width/2-150, self.passwordTxtFld.frame.origin.y+self.passwordTxtFld.frame.size.height+30,140, 40);
    self.LoginBtn.backgroundColor=[UIColor colorWithRed:(43.0 / 255.0) green:(165.0 / 255.0) blue:(49.0 / 255.0) alpha:1.0];
    self.LoginBtn.layer.cornerRadius=15;
    self.LoginBtn.layer.masksToBounds=YES;
    self.SignUpBtn.frame=CGRectMake(self.view.frame.size.width/2+10, self.passwordTxtFld.frame.origin.y+self.passwordTxtFld.frame.size.height+30,140, 40);
    self.SignUpBtn.backgroundColor=[UIColor colorWithRed:(43.0 / 255.0) green:(165.0 / 255.0) blue:(49.0 / 255.0) alpha:1.0];
    self.SignUpBtn.layer.cornerRadius=15;
    self.SignUpBtn.layer.masksToBounds=YES;
    
    [self.view addSubview:seprator];
    [self.view addSubview:seprator1];
    
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
- (IBAction)login:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
    if (self.emailTxtFld.text.length==0)
    {
        UIAlertView *mPasswordAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter password " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [mPasswordAlert show];
    }
    else if (self.passwordTxtFld.text.length==0)
    {
        UIAlertView *mPasswordAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter password " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [mPasswordAlert show];
    }
   else
   {
   // {email : value ,password : value}
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@",self.emailTxtFld.text,self.passwordTxtFld.text];
    
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_login"]];
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
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        arr=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",arr);
        NSMutableDictionary *dict=[arr objectAtIndex:0];
        
        NSLog(@"%@,%@,%@",
        [dict objectForKey:@"userID"],
        [dict objectForKey:@"success"],
        [dict objectForKey:@"status"]);
        int success=[[dict objectForKey:@"success"] intValue];
        int status=[[dict objectForKey:@"status"] intValue];
        int userID  = [[dict objectForKey:@"userID"]intValue];
        if( success ==0)
         {
                     showAlert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Login Record not found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     [showAlert show];
         }
        else if(status ==0 )
        {
                    showAlert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Your account is no longer activate" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [showAlert show];
        }
        else
        {
            self.navigationController.navigationBarHidden = true;
            [[NSUserDefaults standardUserDefaults]setObject:self.emailTxtFld.text forKey:@"Email"];
            [[NSUserDefaults standardUserDefaults]setObject:self.passwordTxtFld.text forKey:@"Password"];
            [[NSUserDefaults standardUserDefaults]setInteger:userID forKey:@"user_id"];

            [[NSUserDefaults standardUserDefaults]synchronize];
          [self performSegueWithIdentifier:@"LoginToMain" sender:self];
        }
    
    }}
    [SVProgressHUD dismiss];
});
});
}
-(IBAction)SignUp:(id)sender
{
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:@"Registration" sender:self];
}
-(IBAction)forgetPassword:(id)sender{
    
    ForgetPasswordVC *forgetPasswordview = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordVC"];
    [self.navigationController pushViewController:forgetPasswordview animated:YES];
    
}
- (IBAction)demo:(id)sender {
  

    
    
    UIAlertView *alert =
                          [[UIAlertView alloc] initWithTitle:@"Demo"
                                                     message:@"By skipping the registration process you will not be able to swipe coupons!"
                                                    delegate:self
                                           cancelButtonTitle:@"Register me for free!"
                           
                                           otherButtonTitles:@"Oke, no problem",nil];
    [alert performSelector:@selector(show)
                  onThread:[NSThread mainThread]
                withObject:nil
             waitUntilDone:NO];
    
    

    //[netWork show];
    
   
     
   // [alert show];
    
    
    
}

-(void)showa{
    
   
    
    
  //  [netWork performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSString *post = [NSString stringWithFormat:@"email=%@&password=%@",@"kevin@odserver.com",@"123"];
        
        NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_login"]];
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
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            arr=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",arr);
            NSMutableDictionary *dict=[arr objectAtIndex:0];
            
            NSLog(@"%@,%@,%@",
                  [dict objectForKey:@"userID"],
                  [dict objectForKey:@"success"],
                  [dict objectForKey:@"status"]);
            int success=[[dict objectForKey:@"success"] intValue];
            int status=[[dict objectForKey:@"status"] intValue];
            int userID  = [[dict objectForKey:@"userID"]intValue];
            if( success ==0)
            {
                showAlert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Login Record not found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            }
            else if(status ==0 )
            {
                showAlert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Your account is no longer activate" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            }
            else
            {
                self.navigationController.navigationBarHidden = true;
                [[NSUserDefaults standardUserDefaults]setObject:self.emailTxtFld.text forKey:@"Email"];
                [[NSUserDefaults standardUserDefaults]setObject:self.passwordTxtFld.text forKey:@"Password"];
                [[NSUserDefaults standardUserDefaults]setInteger:userID forKey:@"user_id"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self performSegueWithIdentifier:@"LoginToMain" sender:self];
            }
            
        }}
}
/*
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        NSString *post = [NSString stringWithFormat:@"email=%@&password=%@",@"kevin@odserver.com",@"123"];
        
        NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_login"]];
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
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            arr=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",arr);
            NSMutableDictionary *dict=[arr objectAtIndex:0];
            
            NSLog(@"%@,%@,%@",
                  [dict objectForKey:@"userID"],
                  [dict objectForKey:@"success"],
                  [dict objectForKey:@"status"]);
            int success=[[dict objectForKey:@"success"] intValue];
            int status=[[dict objectForKey:@"status"] intValue];
            int userID  = [[dict objectForKey:@"userID"]intValue];
            if( success ==0)
            {
                showAlert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Login Record not found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            }
            else if(status ==0 )
            {
                showAlert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Your account is no longer activate" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            }
            else
            {
                self.navigationController.navigationBarHidden = true;
                [[NSUserDefaults standardUserDefaults]setObject:self.emailTxtFld.text forKey:@"Email"];
                [[NSUserDefaults standardUserDefaults]setObject:self.passwordTxtFld.text forKey:@"Password"];
                [[NSUserDefaults standardUserDefaults]setInteger:userID forKey:@"user_id"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self performSegueWithIdentifier:@"LoginToMain" sender:self];
            }
            
        }}
//    [SVProgressHUD dismiss];

    //}
}
 */

#pragma mark -UITEXTFIELD Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    [self.view endEditing:YES];
}
-(void)animateTextField :(UITextField *)textField up:(BOOL)up
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.1 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction > .30)
    {
        
        const int movementDistance = -50; // tweak as needed
        const float movementDuration = 0.4f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    if (heightFraction > .65)
        
    {
        const int movementDistance = -60; // tweak as needed
        const float movementDuration = 0.4f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    
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
