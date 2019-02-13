//
//  SettingSubViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 27/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "SettingSubViewController.h"
#import "SVProgressHUD.h"
@interface SettingSubViewController ()
{
    IBOutlet UIScrollView *unlockScrl;
    CGRect frame;
}
@end

@implementation SettingSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    unlockScrl.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    NavView.frame=CGRectMake(0, 0, self.view.frame.size.width, 64);
    titleLbl.frame=CGRectMake(self.view.frame.size.width/2-105,23, 211,35);
    back.frame=CGRectMake(10,23, 30,30);
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"Website"])
    {
         [SVProgressHUD showWithStatus:@"Loading.."];
        webSiteWV.hidden=NO;
        termScrollView.hidden=YES;
    webSiteWV.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    NSURL *url=[NSURL URLWithString:@"http://www.africoupon.com/"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webSiteWV loadRequest:request];
    }
    else if ([[NSUserDefaults standardUserDefaults]boolForKey:@"RedemeeCoupon"] )
    {
        webSiteWV.hidden=YES;
        termScrollView.hidden=YES;
        titleLbl.text=@"REDEEMINF COUPON";

        [self RedemeeCouponView];
    }
    else if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Terms"] )
    {
        webSiteWV.hidden=YES;
        termScrollView.hidden=NO;
        titleLbl.text=@"TERMS & CONDITIONS";
        [self TermsView];
    }
    
}

-(void)TermsView
{
    termScrollView.frame=CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height);
    AccLbl.frame=CGRectMake(10,0,termScrollView.frame.size.width-20, 30);
    UITextView *AccTxtView=[[UITextView alloc]init];
    AccTxtView.frame=CGRectMake(10,AccLbl.frame.size.height+AccLbl.frame.origin.y,termScrollView.frame.size.width-20, 50);
    AccTxtView.scrollEnabled=YES;
    AccTxtView.userInteractionEnabled=NO;
    AccTxtView.text=@"By installing this Africoupon App and / or by using Africoupon services through the Africoupon App, you accept the terms and conditions of use issued by 'Africoupon Mobile Marketing' ('Africoupon' or 'We')";
    [AccTxtView sizeToFit];
    AccTxtView.scrollEnabled=NO;
    AccTxtView.textColor=[UIColor lightGrayColor];


    GenerlLbl.frame=CGRectMake(10,AccTxtView.frame.size.height+AccTxtView.frame.origin.y,termScrollView.frame.size.width-20, 30);
    UITextView *GenerlTxtView=[[UITextView alloc]init];
    GenerlTxtView.frame=CGRectMake(10,GenerlLbl.frame.size.height+GenerlLbl.frame.origin.y,termScrollView.frame.size.width-20, 50);
    GenerlTxtView.scrollEnabled=YES;
    GenerlTxtView.text=@"Africoupon (brandname 'Africoupon') provides an interactive online service, accessed by you through Africoupon App comprising coupon offers of various merchants. Also Africoupon may transmit advertisements etc. Foregoing services are collectively called 'Africoupon Services'. Your right to access the Africoupon Services is personal. You are solely responsible for securing your devices and passwords necessary for accessing Africoupon Services. Africoupon reserves the right to terminate your access to Africoupon Services at any time without assigning any reason. You understand that Africoupon Services are provided over the internet and are subject to exigencies and vulnerabilities of the internet. FURTHERMORE, AFRICOUPON DOES GIVE ANY GUARANTEE OR WARRANTY IN RESPECT OF THE AFRICOUPON SERVICES. WITHOUT PREJUDICE TO THE GENERALITY OF THE FOREGOING, AFRICOUPON DOES NOT GUARANTEE THAT AFRICOUPON SERVICES WILL BE ERROR-FREE. ACCESS TO AFRICOUPON SERVICES MAY BE INTERRUPTED OR SUSPENDED FOR ANY REASON INCLUDING MAINTENANCE WORK";
    GenerlTxtView.userInteractionEnabled=NO;
    GenerlTxtView.textColor=[UIColor lightGrayColor];
    [GenerlTxtView sizeToFit];
    GenerlTxtView.scrollEnabled=NO;
    
    ModifiedTermsLbl.frame=CGRectMake(10,GenerlTxtView.frame.size.height+GenerlTxtView.frame.origin.y,termScrollView.frame.size.width-20, 30);
    UITextView *ModifiedTermsTxtView=[[UITextView alloc]init];
    ModifiedTermsTxtView.frame=CGRectMake(10,ModifiedTermsLbl.frame.size.height+ModifiedTermsLbl.frame.origin.y,termScrollView.frame.size.width-20, 30);
    ModifiedTermsTxtView.scrollEnabled=YES;
    ModifiedTermsTxtView.text=@"Africoupon may at any time modify these Terms or Privacy Policy without prior notification to you. Your subsequent access to Africoupon Services shall be subject to the modified terms";
    ModifiedTermsTxtView.userInteractionEnabled=NO;
    ModifiedTermsTxtView.textColor=[UIColor lightGrayColor];
    [ModifiedTermsTxtView sizeToFit];
    ModifiedTermsTxtView.scrollEnabled=NO;
    
    
    ProhibitionLbl.frame=CGRectMake(10,ModifiedTermsTxtView.frame.size.height+ModifiedTermsTxtView.frame.origin.y,termScrollView.frame.size.width-20, 30);
    UITextView *ProhibitionTxtView=[[UITextView alloc]init];
    ProhibitionTxtView.frame=CGRectMake(10,ProhibitionLbl.frame.size.height+ProhibitionLbl.frame.origin.y,termScrollView.frame.size.width-20, 50);
    ProhibitionTxtView.scrollEnabled=YES;
    ProhibitionTxtView.text=@"You understand that the Africoupon App (including software and interface) are Africoupon's property, licensed to you for your personal use, only for accessing Africoupon Services. Furthermore, the content (literary, artistic or otherwise) received by you over the Africoupon Services is copyrighted and proprietary. You shall not host, display, upload, modify, publish, transmit, update or share any information that — belongs to another person and to which the user does not have any right to; is grossly harmful, harassing, blasphemous defamatory, obscene, pornographic, paedophilic, libellous, invasive of another's privacy, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, or otherwise unlawful in any manner whatever; harm minors in any way; infringes any patent, trademark, copyright or other proprietary rights; violates any law for the time being in force; deceives or misleads the addressee about the origin of such messages or communicates any information which is grossly offensive or menacing in nature; impersonate another person; contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer resource; threatens the unity, integrity, defence, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognisable offence or prevents investigation of any offence or is insulting any other nation";
    frame = ProhibitionTxtView.frame;
    frame.size.height = ProhibitionTxtView.contentSize.height;
    ProhibitionTxtView.frame = frame;
    [ProhibitionTxtView sizeToFit];
    ProhibitionTxtView.scrollEnabled=NO;
    ProhibitionTxtView.userInteractionEnabled=NO;
    ProhibitionTxtView.textColor=[UIColor lightGrayColor];

    
    purchaseLbl.frame=CGRectMake(10,ProhibitionTxtView.frame.size.height+ProhibitionTxtView.frame.origin.y,termScrollView.frame.size.width-20, 30);
    UITextView *purchaseTxtView=[[UITextView alloc]init];
    purchaseTxtView.frame=CGRectMake(10,purchaseLbl.frame.size.height+purchaseLbl.frame.origin.y,termScrollView.frame.size.width-20, 50);
    purchaseTxtView.scrollEnabled=YES;
     purchaseTxtView.text=@"User understands that Africoupon is merely a platform which allows merchants to offer deals to users. All deals are subject to Standard Terms and Conditions, Specific Terms and Conditions and the rules of the specific merchant. If there is any dispute regarding a merchant's product or services, you will need to directly seek redress from the merchant. Merchant (and not Africoupon) is solely responsible for all claims and liabilities arising from goods and services.";
    frame = purchaseTxtView.frame;
    frame.size.height = purchaseTxtView.contentSize.height;
    purchaseTxtView.frame = frame;
    [purchaseTxtView sizeToFit];
    purchaseTxtView.scrollEnabled=NO;
    purchaseTxtView.userInteractionEnabled=NO;
    purchaseTxtView.textColor=[UIColor lightGrayColor];

    StandardTermsLbl.frame=CGRectMake(10,purchaseTxtView.frame.size.height+purchaseTxtView.frame.origin.y,termScrollView.frame.size.width-20, 35);
    UITextView *StandardTermsTxtView=[[UITextView alloc]init];
    StandardTermsTxtView.frame=CGRectMake(10,StandardTermsLbl.frame.size.height+StandardTermsLbl.frame.origin.y,termScrollView.frame.size.width-20, 50);
    StandardTermsTxtView.scrollEnabled=YES;
    StandardTermsTxtView.text=@"Merchant (not Africoupon) liable for products and services delivered. Usable within specified validity period Vouchers not encashable or refundable in whole or in part. Vouchers not transferable ‘Lost’ vouchers not replaceable A Voucher not be combined with another offer Vouchers not redeemable for tax, shipping, handling charges, tips etc.";
    frame = StandardTermsTxtView.frame;
    frame.size.height = StandardTermsTxtView.contentSize.height;
    StandardTermsTxtView.frame = frame;
    [StandardTermsTxtView sizeToFit];
    StandardTermsTxtView.scrollEnabled=NO;
    StandardTermsTxtView.userInteractionEnabled=NO;
    StandardTermsTxtView.textColor=[UIColor lightGrayColor];

    
    PrivacyLbl.frame=CGRectMake(10,StandardTermsTxtView.frame.size.height+StandardTermsTxtView.frame.origin.y,termScrollView.frame.size.width-20, 30);
    UITextView *PrivacyTxtView=[[UITextView alloc]init];
    PrivacyTxtView.frame=CGRectMake(10,PrivacyLbl.frame.size.height+PrivacyLbl.frame.origin.y,termScrollView.frame.size.width-20, 100);
    PrivacyTxtView.scrollEnabled=YES;
      PrivacyTxtView.text=@"User messages and posts are public communications. Africoupon disclaims any liability arising from such communications. However, users grant a royalty-free, perpetual and irrevocable license to Africoupon to use the content of such communications as it deems fit.";
    frame = PrivacyTxtView.frame;
    frame.size.height = PrivacyTxtView.contentSize.height;
    PrivacyTxtView.frame = frame;
    [PrivacyTxtView sizeToFit];
    PrivacyTxtView.scrollEnabled=NO;
    PrivacyTxtView.userInteractionEnabled=NO;
    PrivacyTxtView.textColor=[UIColor lightGrayColor];


    IndeminationLbl.frame=CGRectMake(10,PrivacyTxtView.frame.size.height+PrivacyTxtView.frame.origin.y,termScrollView.frame.size.width-20, 30);
    UITextView *IndeminationTxtview=[[UITextView alloc]init];
    IndeminationTxtview.frame=CGRectMake(10,IndeminationLbl.frame.size.height+IndeminationLbl.frame.origin.y,termScrollView.frame.size.width-20, 30);
    IndeminationTxtview.scrollEnabled=YES;
     IndeminationTxtview.text=@"User indemnifies Africoupon for liabilities and losses arising from breach of these terms.";
    frame = IndeminationTxtview.frame;
    frame.size.height = IndeminationTxtview.contentSize.height;
    IndeminationTxtview.frame = frame;
    [IndeminationTxtview sizeToFit];
    IndeminationTxtview.scrollEnabled=NO;
    IndeminationTxtview.userInteractionEnabled=NO;
    IndeminationTxtview.textColor=[UIColor lightGrayColor];

    ThirdPartyLbl.frame=CGRectMake(10,IndeminationTxtview.frame.size.height+IndeminationTxtview.frame.origin.y,termScrollView.frame.size.width-20, 30);
    UITextView *ThirdPartyTxtView=[[UITextView alloc]init];
    ThirdPartyTxtView.frame=CGRectMake(10,ThirdPartyLbl.frame.size.height+ThirdPartyLbl.frame.origin.y,termScrollView.frame.size.width-20, 30);
    ThirdPartyTxtView.scrollEnabled=YES;
    ThirdPartyTxtView.text=@" Africoupon disclaims any liability arising from third party websites and services even if accessed through Africoupon Services.";
    frame = ThirdPartyTxtView.frame;
    frame.size.height = ThirdPartyTxtView.contentSize.height;
    ThirdPartyTxtView.textColor=[UIColor lightGrayColor];
    ThirdPartyTxtView.frame = frame;
    [ThirdPartyTxtView sizeToFit];
    ThirdPartyTxtView.scrollEnabled=NO;
    ThirdPartyTxtView.userInteractionEnabled=NO;
   
    
    [termScrollView addSubview:AccTxtView];
    [termScrollView addSubview:GenerlTxtView];
    [termScrollView addSubview:PrivacyTxtView];
    [termScrollView addSubview:ProhibitionTxtView];
    [termScrollView addSubview:ThirdPartyTxtView];
    [termScrollView addSubview:StandardTermsTxtView];
    [termScrollView addSubview:ModifiedTermsTxtView];
    [termScrollView addSubview:IndeminationTxtview];
    [termScrollView addSubview:purchaseTxtView];
    termScrollView.contentSize=CGSizeMake(self.view.frame.size.width, ThirdPartyTxtView.frame.size.height+ThirdPartyTxtView.frame.origin.y+60);
    unlockScrl.contentSize=CGSizeMake(self.view.frame.size.width, termScrollView.frame.size.height);
}
-(void)RedemeeCouponView
{
  

    UITextView *firstTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,64,unlockScrl.frame.size.width-20, 120)];
    firstTxtView.text=@"Probably you already found an interesting coupon you want to redeem while going through our app looking for nice discounts.\n\nRedeeming the coupon(s) of your choice is very easy.\n\nShow, Swipe & Save!\n";
    firstTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    firstTxtView.textColor=[UIColor lightGrayColor];
    firstTxtView.scrollEnabled=NO;
    firstTxtView.userInteractionEnabled=NO;
    
    UITextView *secondTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10,firstTxtView.frame.size.height+firstTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 120)];
    secondTxtView.text=@"Step 1 - Visit the merchant that offers the coupon\nStep 2 - Buy or order the item described in the coupon (read the coupondetails)\nStep 3 - Show the specific coupon to the cashier or the person in charge\nStep 4 - The coupon will be Swiped to be redeemed and you will have the discount offered in that specific coupon!\n";
    secondTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    secondTxtView.textColor=[UIColor darkGrayColor];
    secondTxtView.scrollEnabled=NO;
    secondTxtView.userInteractionEnabled=NO;

    UITextView *ThirdTxtView=[[UITextView alloc]initWithFrame:CGRectMake(10, secondTxtView.frame.size.height+secondTxtView.frame.origin.y,unlockScrl.frame.size.width-20, 120)];
    ThirdTxtView.text=@"Once a coupon is swiped and redeemed it will be removed from the coupons in the app offered by that specific merchant.\nOf course you can still profit from the all other coupons the merchants offer in our app and realize a lot of savings!\nHave fun with showing, swiping and saving.";
    ThirdTxtView.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:13.0];
    ThirdTxtView.textColor=[UIColor lightGrayColor];
    ThirdTxtView.scrollEnabled=NO;
    ThirdTxtView.userInteractionEnabled=NO;

    [unlockScrl addSubview:firstTxtView];
    [unlockScrl addSubview:secondTxtView];
    [unlockScrl addSubview:ThirdTxtView];

    unlockScrl.contentSize=CGSizeMake(self.view.frame.size.width, ThirdTxtView.frame.size.height+ThirdTxtView.frame.origin.y+20);
}

-(IBAction)back:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Website"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"RedemeeCoupon"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Terms"];
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [SVProgressHUD dismiss];

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
