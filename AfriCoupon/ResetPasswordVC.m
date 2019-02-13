//
//  ResetPasswordVC.m
//  AfriCoupon
//
//  Created by Deepak on 24/02/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "ResetPasswordVC.h"
#import "Helper.h"
@interface ResetPasswordVC ()

@end

@implementation ResetPasswordVC

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
    
    enterOTP.frame = CGRectMake(0, HEIGHT/2+20, WIDTH, 40);
    UIImageView *seprator1=[[UIImageView alloc]initWithFrame:CGRectMake(0,enterOTP.frame.size.height+enterOTP.frame.origin.y, self.view.frame.size.width,2)];
    seprator1.image=[UIImage imageNamed:@"Seprator.png"];
    
    enterPassword.frame=CGRectMake(0, enterOTP.frame.origin.y+enterOTP.frame.size.height+10,self.view.frame.size.width, 40);

    UIImageView *seprator2=[[UIImageView alloc]initWithFrame:CGRectMake(0,enterPassword.frame.size.height+enterPassword.frame.origin.y, self.view.frame.size.width,2)];
    seprator2.image=[UIImage imageNamed:@"Seprator.png"];
    
    confirmPassword.frame=CGRectMake(0, enterPassword.frame.origin.y+enterPassword.frame.size.height+10,self.view.frame.size.width, 40);
    
    UIImageView *seprator3=[[UIImageView alloc]initWithFrame:CGRectMake(0,confirmPassword.frame.size.height+confirmPassword.frame.origin.y, self.view.frame.size.width,2)];
    seprator3.image=[UIImage imageNamed:@"Seprator.png"];
    
    resetPassword.frame=CGRectMake(self.view.frame.size.width/2-150, confirmPassword.frame.origin.y+confirmPassword.frame.size.height+30,140, 40);
    resetPassword.backgroundColor=[UIColor colorWithRed:(43.0 / 255.0) green:(165.0 / 255.0) blue:(49.0 / 255.0) alpha:1.0];
    resetPassword.layer.cornerRadius=15;
    resetPassword.layer.masksToBounds=YES;
    cancel.frame=CGRectMake(self.view.frame.size.width/2+10, confirmPassword.frame.origin.y+confirmPassword.frame.size.height+30,140, 40);
    cancel.backgroundColor=[UIColor colorWithRed:(43.0 / 255.0) green:(165.0 / 255.0) blue:(49.0 / 255.0) alpha:1.0];
    cancel.layer.cornerRadius=15;
    cancel.layer.masksToBounds=YES;
    
    [self.view addSubview:seprator1];
    [self.view addSubview:seprator2];
    [self.view addSubview:seprator3];
    
}
-(IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)resetPassword:(id)sender{
    
    if ([enterPassword.text isEqualToString:confirmPassword.text]) {
        NSString *returnValue=[Helper ResetPassword:enterOTP.text :_email :enterPassword.text];
        if ([returnValue isEqualToString:@"e1"]) {
            UIAlertView *mAlert =[[UIAlertView alloc]initWithTitle:nil  message:@"Code mismatch" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [mAlert show];
        }else if ([returnValue isEqualToString:@"e2"]){
            UIAlertView *mAlert =[[UIAlertView alloc]initWithTitle:nil  message:@"Code Expired" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [mAlert show];

        }else{
            UIAlertView *mAlert =[[UIAlertView alloc]initWithTitle:@"congratulations"  message:@"Your password has been reset successfully!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [mAlert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *mAlert =[[UIAlertView alloc]initWithTitle:nil  message:@"Password and confirm password not matched" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [mAlert show];
    }
    
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
