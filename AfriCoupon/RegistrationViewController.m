//
//  RegistrationViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "RegistrationViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *gestureRec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [gestureRec setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:gestureRec];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

    [self layoutSubview];
}
#pragma mark -Private Methods
-(void)layoutSubview
{
    self.nameFld.frame=CGRectMake(0, 85,self.view.frame.size.width, 40);
    UIImageView *seprator1=[[UIImageView alloc]initWithFrame:CGRectMake(0,  self.nameFld.frame.size.height+self.nameFld.frame.origin.y, self.view.frame.size.width,2)];
    seprator1.image=[UIImage imageNamed:@"Seprator.png"]; 
    
    self.addressFld.frame=CGRectMake(0, self.nameFld.frame.origin.y+self.nameFld.frame.size.height+25,self.view.frame.size.width, 40);
    UIImageView *seprator2=[[UIImageView alloc]initWithFrame:CGRectMake(0,  self.addressFld.frame.size.height+self.addressFld.frame.origin.y, self.view.frame.size.width,2)];
    seprator2.image=[UIImage imageNamed:@"Seprator.png"];
    
    self.emailTxtFld.frame=CGRectMake(0, self.addressFld.frame.origin.y+self.addressFld.frame.size.height+25, self.view.frame.size.width,40);
    UIImageView *seprator3=[[UIImageView alloc]initWithFrame:CGRectMake(0,  self.emailTxtFld.frame.size.height+self.emailTxtFld.frame.origin.y, self.view.frame.size.width,2)];
    seprator3.image=[UIImage imageNamed:@"Seprator.png"];
    
    self.passwordTxtFld.frame=CGRectMake(0, self.emailTxtFld.frame.origin.y+self.emailTxtFld.frame.size.height+25,self.view.frame.size.width, 40);
    UIImageView *seprator4=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.passwordTxtFld.frame.size.height+self.passwordTxtFld.frame.origin.y, self.view.frame.size.width,2)];
    seprator4.image=[UIImage imageNamed:@"Seprator.png"];
    
    
    self.freeBtn.frame=CGRectMake(0, self.passwordTxtFld.frame.origin.y+self.passwordTxtFld.frame.size.height+50,self.view.frame.size.width, 40);
    self.freeBtn.layer.borderWidth=2;
    self.freeBtn.layer.cornerRadius=5;
    self.submitBtn.frame=CGRectMake(self.view.frame.size.width/2-100, self.freeBtn.frame.origin.y+self.freeBtn.frame.size.height+30,200, 40);
    self.submitBtn.backgroundColor=[UIColor colorWithRed:(43.0 / 255.0) green:(165.0 / 255.0) blue:(49.0 / 255.0) alpha:1.0];
    self.submitBtn.layer.cornerRadius=15;
    self.submitBtn.layer.masksToBounds=YES;
    [self.view addSubview:seprator1];
    [self.view addSubview:seprator2];
    [self.view addSubview:seprator3];
    [self.view addSubview:seprator4];
}
-(IBAction)submit  :(id)sender
{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    dispatch_queue_t concurrentQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
    [self.view endEditing:YES];
    if(self.nameFld.text.length==0)
    {
        UIAlertView *mEmailAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter user name" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [mEmailAlert show];
    }
 //   else if (self.addressFld.text.length==0)
//    {
  //      UIAlertView *mPasswordAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter address " delegate:self cancelButtonTitle:@"ok" //otherButtonTitles: nil];
      //  [mPasswordAlert show];
   // }
    else if (self.emailTxtFld.text.length==0)
    {
        UIAlertView *mPasswordAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter email " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [mPasswordAlert show];
    }
    else if (self.passwordTxtFld.text.length==0)
    {
        UIAlertView *mPasswordAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Enter password " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [mPasswordAlert show];
    }
    else
    {
        
      //  name: value ,address: value ,email: value ,password: value ,type: Free}
        NSString *post = [NSString stringWithFormat:@"name=%@&address=%@&email=%@&password=%@&type=Free",self.nameFld.text ,@"none",self.emailTxtFld.text,self.passwordTxtFld.text];
       
        NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_registration"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
      NSString*   str=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *responseArray=[[NSMutableArray alloc]init];
        responseArray=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSMutableDictionary *dict=[responseArray objectAtIndex:0];
            int success=[[dict objectForKey:@"success"] intValue];
            int status=[[dict objectForKey:@"status"] intValue];
            int userID  = [[dict objectForKey:@"userID"]intValue];
            
          if(success==1 && status==1)
          {
//              UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"Registration Successfull" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//              [showAlert show];
              self.navigationController.navigationBarHidden = true;
              [[NSUserDefaults standardUserDefaults]setObject:self.emailTxtFld.text forKey:@"Email"];
              [[NSUserDefaults standardUserDefaults]setObject:self.passwordTxtFld.text forKey:@"Password"];
              [[NSUserDefaults standardUserDefaults]setInteger:userID forKey:@"user_id"];

              [[NSUserDefaults standardUserDefaults]synchronize];
              AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
              [appDelegate checkUserType:userID];
              
              [self performSegueWithIdentifier:@"RegistrationToMain" sender:self];
              
          }
            else if(success==0)
            {
            UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Email already exist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            }else if(success==1 && status ==0 )
            {
                UIAlertView *showAlert=[[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Account is no longer active" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            }
        
    }
            [SVProgressHUD dismiss];
        });
    });}

-(IBAction)back:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

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
