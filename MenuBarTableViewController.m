//
//  MenuBarTableViewController.m
//  AfriCoupon
//
//  Created by Rahul Raman  Sharma on 14/01/16.
//  Copyright © 2016 Rahul Raman  Sharma. All rights reserved.
//

#import "MenuBarTableViewController.h"
#import "SWRevealViewController.h"
#import "CategoryViewController.h"
#import "MainViewConroller.h"
#import "SettingViewController.h"

static NSString *const AppGroupId = @"group.tag.AppGroupDemo";

@interface MenuBarTableViewController ()
{
    NSArray *menuArray;
    NSArray *imageArray;
    NSArray *SelectedimageArray;
    NSString *lastSelected;
}
@end

@implementation MenuBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuArray=@[@"COUPONS",@"CATEGORIES",@"SETTINGS",@"FEEDBACK",@"UNLOCK COUPON",@"FAQ",@"Invite Friends"];
  imageArray=@[@"CouponsIcon.png",@"CategoryIcon.png",@"settings.png",@"feedbackicon.png",@"unlockicon.png",@"faqicon.png",@"share"];
  SelectedimageArray=@[@"CouponsIcon.png",@"CategoryIcon.png",@"settings.png",@"feedbackicon.png",@"unlockicon.png",@"faq_pink.png",@"faqicon.png"];
       self.navigationController.navigationBarHidden=YES;
    self.menuTbl.backgroundColor=[UIColor blackColor]; 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuArray.count;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupId];
    arrSites = [NSMutableArray arrayWithArray:[sharedUserDefaults valueForKey:@"SharedExtension"]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
        
    {
                for(UIView *vv in cell.contentView.subviews)
                {
                    if(vv.tag ==indexPath.row+1)
                    {
                    [vv removeFromSuperview];
                    }
                }
    }
   UIView *line=[[UIView alloc]initWithFrame:CGRectMake(cell.frame.origin.x, 0, 2, cell.frame.size.height)];
   
  UILabel  *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(65,0, cell.frame.size.width-10, cell.frame.size.height)];
    titleLabel.text=[menuArray objectAtIndex:indexPath.row];
    titleLabel.tag=indexPath.row+1;
    titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18.0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(lastSelected.length)
    {
        if([[menuArray objectAtIndex:indexPath.row] isEqualToString:lastSelected])
        {
            titleLabel.textColor=[UIColor colorWithRed:(206.0 / 255.0) green:(0.0 / 255.0) blue:(87.0 / 255.0) alpha:1.0];
            line.backgroundColor=[UIColor colorWithRed:(206.0 / 255.0) green:(0.0 / 255.0) blue:(87.0 / 255.0) alpha:1.0];
             cell.imageView.image=[UIImage imageNamed:[SelectedimageArray objectAtIndex:indexPath.row]];
        }
        else
        {
            titleLabel.textColor=[UIColor whiteColor];
            line.backgroundColor=[UIColor blackColor] ;
             cell.imageView.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        }
    }
    else
    {
        titleLabel.textColor=[UIColor whiteColor];
        line.backgroundColor=[UIColor blackColor] ;
         cell.imageView.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    }

    [cell.contentView addSubview:titleLabel];
     [cell.contentView addSubview:line];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    for(UIView *view in cell.contentView.subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *lbl= (UILabel *)view;
            lastSelected=lbl.text;
            lbl.textColor=[UIColor colorWithRed:(206.0 / 255.0) green:(0.0 / 255.0) blue:(87.0 / 255.0) alpha:1.0];
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *lbl= (UIImageView *)view;
            lbl.image=[UIImage imageNamed:[SelectedimageArray objectAtIndex:indexPath.row]];
        }
        else if([view isKindOfClass:[UIView class]])
        {
            UIView *lbl= (UIView *)view;
            lbl.backgroundColor=[UIColor colorWithRed:(206.0 / 255.0) green:(0.0 / 255.0) blue:(87.0 / 255.0) alpha:1.0];
        }
    }
    
    
    
     [self.revealViewController revealToggle:self];
     self.navigationController.navigationBarHidden=YES;

     CategoryViewController *CVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    if(indexPath.row == 0)
    {
        [self.revealViewController performSegueWithIdentifier:@"sw_front" sender:self];
    }
    else if(indexPath.row ==1)
    {
        CVC.MenuTypeVlaue=MenuTypeCategories;
        [self.navigationController pushViewController:CVC animated:YES];
    }
    else if(indexPath.row ==2)
    {
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Feedback"];
        [self.revealViewController performSegueWithIdentifier:@"sw_front1" sender:self];
    }
    else if(indexPath.row ==3)
    {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"Feedback"];
       
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        
        // Configure the fields of the interface.
        [composeVC setToRecipients:@[@"africoupon@gmail.com"]];
        [composeVC setSubject:@"Feedback"];
        [composeVC setMessageBody:@"" isHTML:NO];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
        
    //   [self.revealViewController performSegueWithIdentifier:@"sw_front1" sender:self];
    }
    else if(indexPath.row ==4)
    {
        CVC.MenuTypeVlaue=MenuTypeUnblock;
        [self.navigationController pushViewController:CVC animated:YES];
    }
    else if(indexPath.row ==5)
    {
        CVC.MenuTypeVlaue=MenuTypeFaq;
        [self.navigationController pushViewController:CVC animated:YES];
    }
    else if(indexPath.row ==6)
    {
       
        
       // [self.extensionContext completeRequestReturningItems:outputItems expirationHandler:nil completion:nil];
        
        //InviteViewController *invite = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
        //[self.navigationController pushViewController:invite animated:YES];

       // [self presentViewController:invite animated:YES completion:nil];
//        
//        [self.navigationController popToRootViewControllerAnimated:NO];
    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    
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
