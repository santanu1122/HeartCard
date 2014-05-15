//
//  MoreOptionDetails.m
//  HeartCard
//
//  Created by Iphone_2 on 10/09/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "MoreOptionDetails.h"

@interface MoreOptionDetails ()
{
    
    CGRect initialFrame;
}

@end

@implementation MoreOptionDetails

@synthesize ScreenViewCategory, TVDescription, BackView, ParamMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"MoreOptionDetailsBig" bundle:nil]:[super initWithNibName:@"MoreOptionDetails" bundle:nil];
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
    [self AddButtonBarToScreenView:ScreenViewCategory];
    
    //[[self BackView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:(IsIphone5)?@"background_scroll.jpg":@"background_scroll4.jpg"]]];
    [[self BackView] setBackgroundColor:[UIColor clearColor]];
    [[self TVDescription] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_scroll.jpg"]]];
    
    [self AddTopBarToScreenView:ScreenViewCategory withTitle:[ParamMethod Name]];
    [TVDescription setText:[NSString stringWithFormat:@"\n%@\n\n",[ParamMethod Description]]];
    [TVDescription setFont:[UIFont fontWithName:@"papyrus" size:15.0f]];
    [TVDescription setTextColor:UIColorFromRGB(0xe8661c)];
    
    initialFrame=[BackView frame];
    initialFrame.size.height+=[[TVDescription text] sizeWithFont:[UIFont fontWithName:@"papyrus" size:15.0f]].height;
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
