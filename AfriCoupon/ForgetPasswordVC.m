//
//  ForgetPasswordVC.m
//  AfriCoupon
//
//  Created by Deepak on 23/02/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "ResetPasswordVC.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
//static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
//static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *gestureRec=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [gestureRec setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:gestureRec];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [self layoutSubview];
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
-(void)layoutSubview
{
    if (HEIGHT < 500) {
        logoImage.frame = CGRectMake(0, 15, WIDTH, WIDTH-90);
        
    }else{
        logoImage.frame = CGRectMake(0, 15, WIDTH, WIDTH-70);
        
    }
    
    ForgetPassword.frame = CGRectMake(0, HEIGHT/2, WIDTH, 25);
    enterYourMail.frame=CGRectMake(0,HEIGHT/2+30, WIDTH,40);
    
       
    emailField.frame=CGRectMake(0, enterYourMail.frame.origin.y+enterYourMail.frame.size.height+20,self.view.frame.size.width, 40);
    UIImageView *seprator1=[[UIImageView alloc]initWithFrame:CGRectMake(0,emailField.frame.size.height+emailField.frame.origin.y, self.view.frame.size.width,2)];
    seprator1.image=[UIImage imageNamed:@"Seprator.png"];
    
    getOTP.frame=CGRectMake(self.view.frame.size.width/2-150, emailField.frame.origin.y+emailField.frame.size.height+30,140, 40);
    getOTP.backgroundColor=[UIColor colorWithRed:(43.0 / 255.0) green:(165.0 / 255.0) blue:(49.0 / 255.0) alpha:1.0];
    getOTP.layer.cornerRadius=15;
    getOTP.layer.masksToBounds=YES;
    cancel.frame=CGRectMake(self.view.frame.size.width/2+10, emailField.frame.origin.y+emailField.frame.size.height+30,140, 40);
    cancel.backgroundColor=[UIColor colorWithRed:(43.0 / 255.0) green:(165.0 / 255.0) blue:(49.0 / 255.0) alpha:1.0];
    cancel.layer.cornerRadius=15;
    cancel.layer.masksToBounds=YES;
    
    [self.view addSubview:seprator1];
    
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


-(IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)getOTP:(id)sender{
    NSString *returnValue = [NSString stringWithFormat:@"%@",[Helper GetOTP:emailField.text]];
    if ([returnValue isEqualToString:@"1"]) {
        ResetPasswordVC *reset =[self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
        reset.email =emailField.text;
        [self.navigationController pushViewController:reset animated:YES];
    }else{
        UIAlertView *mAlert =[[UIAlertView alloc]initWithTitle:nil  message:@"Email not register" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [mAlert show];
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
