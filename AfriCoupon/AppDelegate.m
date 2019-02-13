//
//  AppDelegate.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "AppDelegate.h"
#import "Login.h"
#import "MainViewConroller.h"
#import "Reachability.h"

@interface AppDelegate ()
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (nonatomic,readonly)int networkStatus;

-(BOOL) IsConnectionAvailable;
@end

@implementation AppDelegate
@synthesize networkStatus;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    self.internetReachability=[Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self setNetworkStatus];
    Login *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"]; //or the homeController
    self.navController=[[UINavigationController alloc]initWithRootViewController:loginController];
    self.window.rootViewController=self.navController;
    if(networkStatus == NotReachable)
    {
     NSLog(@"network not available");
      //  UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     //   [alv show];
    }
    else
    {
    BOOL CheckAutoLogin=[self AutoUserLoginCheck];
    if(CheckAutoLogin)
    {
      loginController.navigationController.navigationBarHidden=true;
      [loginController performSegueWithIdentifier:@"LoginToMain" sender:self];
    }
    else
    {
     loginController.navigationController.navigationBarHidden=NO;
    }
    [self.window makeKeyAndVisible];
    }
    

    return YES;
}
-(void)setNetworkStatus
{
    Reachability *networkReachability=[Reachability reachabilityForInternetConnection];
    networkStatus =[networkReachability currentReachabilityStatus];
}
-(BOOL) IsConnectionAvailable
{
    return  networkStatus != NotReachable;
}
 //Called by Reachability whenever status changes.

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    networkStatus =[curReach currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"network not available");
        UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alv show];
    }else{
        NSLog(@"network available");
    }
}

-(BOOL)AutoUserLoginCheck
{
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"Email"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"Password"] )
    {
        NSString *post = [NSString stringWithFormat:@"email=%@&password=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Email"],[[NSUserDefaults standardUserDefaults]objectForKey:@"Password"]];
        
        NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_login_second"]];
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
            int userID = [[dict objectForKey:@"userID"]intValue];
            if( success ==1  &&  status == 1 )
            {
                [self checkUserType:userID];
                return true;
            }
        }
    }
        return false;
}
-(void)checkUserType: (int)userId{
    
    NSString *post = [NSString stringWithFormat:@"user_id=%d",userId];
    
    NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length ]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://couponcms.ontwikkelomgeving.info/user_type_check"]];
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
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if ([responseString isEqualToString:@"premium"]) {
            [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"usertype"];
        }else{
           [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"usertype"];
        }
        NSLog(@"%@",responseString);
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
