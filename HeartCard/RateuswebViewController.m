//
//  RateuswebViewController.m
//  HeartCard
//
//  Created by Iphone_2 on 05/03/14.
//  Copyright (c) 2014 esolz. All rights reserved.
//

#import "RateuswebViewController.h"
#import "CategoryView.h"
@interface RateuswebViewController ()<UIWebViewDelegate>
-(IBAction)GoCancel:(id)sender;
@property(nonatomic,retain) IBOutlet UIWebView *Mywebview;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *ActivityIndi;
@end

@implementation RateuswebViewController
@synthesize Mywebview       = _Mywebview;
@synthesize ActivityIndi    = _ActivityIndi;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"RateuswebViewController" bundle:nil]:[super initWithNibName:@"RateuswebViewControllerSmall" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *LblTopTitile = (UILabel *)[self.view viewWithTag:11];
    [LblTopTitile setBackgroundColor:[UIColor clearColor]];
    [LblTopTitile setTextAlignment:NSTextAlignmentCenter];
    [LblTopTitile setFont:[UIFont fontWithName:@"papyrus" size:22.0f]];
    [LblTopTitile setTextColor:UIColorFromRGB(0x0571af) ];
    [LblTopTitile setShadowColor:UIColorFromRGB(0xb8ddf2)];
    // Do any additional setup after loading the view from its nib.
    
    
    UIWebView *CuponRedemView = _Mywebview;
    [_Mywebview setBackgroundColor:[UIColor clearColor]];
    [CuponRedemView setDelegate:self];
    NSString *url=@"https://itunes.apple.com/us/app/happy-heart-cards/id716481893?mt=8";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [CuponRedemView loadRequest:nsrequest];
    
}
#pragma mark - Private for uiwebview

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_ActivityIndi startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_ActivityIndi stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [_ActivityIndi stopAnimating];
    NSLog(@"There is some err, plz try again later");
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)GoCancel:(id)sender {
    CategoryView *cat = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
    [self.navigationController pushViewController:cat animated:YES];
}
@end
