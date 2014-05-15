//
//  StoreLocatorView.m
//  HeartCard
//
//  Created by Iphone_2 on 19/11/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "StoreLocatorView.h"

@interface StoreLocatorView ()
{
    CGRect initialFrame;
}


@end

@implementation StoreLocatorView

@synthesize ScreenView, SVBack, BackView, HeaderTitleString;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"StoreLocatorViewBig" bundle:nil]:[super initWithNibName:@"StoreLocatorView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self PrepareScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)PrepareScreen
{
    [[self BackView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:(IsIphone5)?@"background_scroll.jpg":@"background_scroll4.jpg"]]];
    [self AddTopBarToScreenView:ScreenView withTitle:HeaderTitleString WithFavIcon:NO];
    [self AddButtonBarToScreenView:ScreenView];
    [SVBack setContentSize:CGSizeMake(320.0f, 850.0f)];
    initialFrame=[BackView frame];
    initialFrame.size.height=2000.0f;
    [BackView setFrame:initialFrame];
}

-(void)goBack
{
    [self PerformGoBackTo:@"MoreMenuView"];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(initialFrame.size.height>0)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect TempRect=initialFrame;
        TempRect.origin.y-=offset.y;
        [BackView setFrame:TempRect];
    }
}
@end
