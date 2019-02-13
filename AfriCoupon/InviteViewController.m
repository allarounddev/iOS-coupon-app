//
//  InviteViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 29/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    mBackButton.frame = CGRectMake(0, 20, 40, 30);
    mTitle.frame = CGRectMake(self.view.frame.size.width/2-68, 20, 136, 30);
    mSepratorImage.frame = CGRectMake(0, 60, self.view.frame.size.width, 2);
    mFbButton.frame = CGRectMake(self.view.frame.size.width/2-120, 90, 70, 70);
    mTwiterButton.frame = CGRectMake(self.view.frame.size.width/2+50, 90, 70, 70);
    mFb.frame = CGRectMake(self.view.frame.size.width/2-120, 165, 75, 21);
    mtwitter.frame = CGRectMake(self.view.frame.size.width/2+50, 165, 75, 21);

}
-(IBAction)facebook:(id)sender{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
   // [controller addURL:[NSURL URLWithString:@"https://play.google.com/store/apps/details?id=Orion.Soft"]];
    //[controller addImage:[UIImage imageNamed:@"icon_circle"]];
    [controller setInitialText:@"https://play.google.com/store/apps/details?id=Orion.Soft"];
    
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)twitter:(id)sender{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [controller addURL:[NSURL URLWithString:@"https://play.google.com/store/apps/details?id=Orion.Soft"]];
    //[controller addImage:[UIImage imageNamed:@"icon_circle"]];
    //[controller setInitialText:@"Bhavuk you're great!"];
    
    [self presentViewController:controller animated:YES completion:nil];

}
-(IBAction)back:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
