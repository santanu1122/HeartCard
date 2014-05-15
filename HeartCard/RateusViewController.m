//
//  RateusViewController.m
//  HeartCard
//
//  Created by Iphone_2 on 05/03/14.
//  Copyright (c) 2014 esolz. All rights reserved.
//

#import "RateusViewController.h"
#import "RateuswebViewController.h"
#import "CategoryView.h"

@interface RateusViewController ()<UIAlertViewDelegate>
-(IBAction)GoCancel:(id)sender;
-(IBAction)GoOk:(id)sender;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *ACTINDI;
@property (nonatomic,retain) IBOutlet UIView *ACTIVIEW;
@end

@implementation RateusViewController
@synthesize ACTIVIEW = _ACTIVIEW;
@synthesize ACTINDI=_ACTINDI;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"RateusViewController" bundle:nil]:[super initWithNibName:@"RateusViewControllerSmall" bundle:nil];
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated {
    
    [_ACTINDI startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSString *url=[NSString stringWithFormat:@"%@user_app_visit_V2.php?deviceId=%@", API, DeviceId];
        NSError *error;
        NSString *Totalcounter = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [_ACTINDI stopAnimating];
           if ([Totalcounter intValue] == 5) {
                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Rate happy heART cards" message:@"Please rate my app. I read all \n reviews and I appreciate your time. \n Thanks, Lori Brody" delegate:self cancelButtonTitle:@"No thanks." otherButtonTitles:@"Rate it.", nil];
                [Alert show];
               
            } else {
                CategoryView *Catview = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
                [self.navigationController pushViewController:Catview animated:YES];
            }
        });
        
    });
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==0) {
        CategoryView *Catview = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
        [self.navigationController pushViewController:Catview animated:YES];
    } else {
        RateuswebViewController *cat = [[RateuswebViewController alloc] initWithNibName:@"RateuswebViewController" bundle:nil];
        [self.navigationController pushViewController:cat animated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction)GoCancel:(id)sender {
    CategoryView *cat = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
    [self.navigationController pushViewController:cat animated:YES];
}
-(IBAction)GoOk:(id)sender {
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/happy-heart-cards/id716481893?mt=8"]];
    RateuswebViewController *cat = [[RateuswebViewController alloc] initWithNibName:@"RateuswebViewController" bundle:nil];
    [self.navigationController pushViewController:cat animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
