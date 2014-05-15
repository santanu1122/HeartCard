//
//  GlobalViewController.m
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "GlobalViewController.h"
#import "FavouriteView.h"
#import "CalendarView.h"
#import "MoreMenuView.h"
#import <QuartzCore/QuartzCore.h>

@interface GlobalViewController ()

@end

@implementation GlobalViewController

@synthesize  FavButton, BtnSendCard, HeaderSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    HeaderSize=0.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)AddTopBarToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle
{
    [self AddTopBarToScreenView:ScreenView withTitle:TopTitle withBackButton:YES withFavIcon:YES];
}

-(void)AddTopBarToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle withBackButton:(BOOL)NeedBackButton
{
    [self AddTopBarToScreenView:ScreenView withTitle:TopTitle withBackButton:NeedBackButton withFavIcon:YES];
}

-(void)AddTopBarToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle WithFavIcon:(BOOL)NeedFavButton
{
    [self AddTopBarToScreenView:ScreenView withTitle:TopTitle withBackButton:YES withFavIcon:NeedFavButton];
}

-(void)AddTopBarWithOutButtonToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle
{
    [self AddTopBarToScreenView:ScreenView withTitle:TopTitle withBackButton:NO withFavIcon:NO];
}

-(void)AddTopBarToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle withBackButton:(BOOL)NeedBackButton withFavIcon:(BOOL)NeedFavButton
{
    CGRect TopbarRect=CGRectMake(0.0f, 0.0f, 320.0f, 77.0f);
    
    UIView *TopbarView=[[UIView alloc] initWithFrame:TopbarRect];
    [TopbarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar-bg.png"]]];
    [ScreenView addSubview:TopbarView];
    
    if(NeedBackButton)
    {        
        CGRect BackButtonRect=CGRectMake(10.0f, 18.0f, 30.0f, 25.0f);
        UIButton *backButton=[[UIButton alloc] initWithFrame:BackButtonRect];
        [backButton setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [TopbarView addSubview:backButton];
    }
    
    CGRect TopTitleRect=CGRectMake(40.0f, 15.0f, 246.0f, 40.0f);
    UILabel *LblTopTitile=[[UILabel alloc] initWithFrame:TopTitleRect];
    [LblTopTitile setText:TopTitle];
    [LblTopTitile setBackgroundColor:[UIColor clearColor]];
    [LblTopTitile setTextAlignment:NSTextAlignmentCenter];
    [LblTopTitile setFont:[UIFont fontWithName:@"papyrus" size:(HeaderSize>0.0f)?HeaderSize:20.0f]];
    [LblTopTitile setTextColor:UIColorFromRGB(0x0571af) ];
    [LblTopTitile setShadowColor:UIColorFromRGB(0xb8ddf2)];
    [TopbarView addSubview:LblTopTitile];
    HeaderSize=0.0f;
    
    if(NeedFavButton)
    {
        CGRect FavButtonRect=CGRectMake(276.0f, 18.0f, 34.0f, 29.0f);
        FavButton=[[UIButton alloc] initWithFrame:FavButtonRect];
        [FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        [FavButton addTarget:self action:@selector(FavButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [TopbarView addSubview:FavButton];
    }
}


-(void)AddButtonBarToScreenView:(UIView *)ScreenView
{
    float FromTopForMain=(IsIphone5)?483.0f:395.0f;
    CGRect BottombarRect=CGRectMake(0.0f, FromTopForMain, 320.0f, 85.0f);
    
    float FormTop=40.0f;
    
    UIView *BottomBarView=[[UIView alloc] initWithFrame:BottombarRect];
    [BottomBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar.png"]]];
    [ScreenView addSubview:BottomBarView];
    
    CGRect Button1Rect=CGRectMake(4.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button1=[[UIButton alloc] initWithFrame:Button1Rect];
    [Button1 setImage:[UIImage imageNamed:@"newest.png"] forState:UIControlStateNormal];
    [Button1 addTarget:self action:@selector(newestClicked) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button1];
    
    CGRect Button2Rect=CGRectMake(84.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button2=[[UIButton alloc] initWithFrame:Button2Rect];
    [Button2 setImage:[UIImage imageNamed:@"calendar-button.png"] forState:UIControlStateNormal];
    [Button2 addTarget:self action:@selector(CalenderButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button2];
    
    CGRect Button3Rect=CGRectMake(164.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button3=[[UIButton alloc] initWithFrame:Button3Rect];
    [Button3 setImage:[UIImage imageNamed:@"favorites.png"] forState:UIControlStateNormal];
    [Button3 addTarget:self action:@selector(FavButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button3];
    
    CGRect Button4Rect=CGRectMake(244.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button4=[[UIButton alloc] initWithFrame:Button4Rect];
    [Button4 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [Button4 addTarget:self action:@selector(moreClicked) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button4];
}


-(void)AddButtonBarToPersonalizeView:(UIView *)ScreenView
{
    float FromTopForMain=(IsIphone5)?483.0f:395.0f;
    CGRect BottombarRect=CGRectMake(0.0f, FromTopForMain, 320.0f, 85.0f);
    
    float FormTop=40.0f;
    
    UIView *BottomBarView=[[UIView alloc] initWithFrame:BottombarRect];
    [BottomBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar.png"]]];
    [ScreenView addSubview:BottomBarView];
    
    CGRect Button1Rect=CGRectMake(54.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button1=[[UIButton alloc] initWithFrame:Button1Rect];
    [Button1 setImage:[UIImage imageNamed:@"preview.png"] forState:UIControlStateNormal];
    [Button1 addTarget:self action:@selector(PreviewClicked) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button1];
    
    CGRect Button2Rect=CGRectMake(194.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button2=[[UIButton alloc] initWithFrame:Button2Rect];
    [Button2 setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [Button2 addTarget:self action:@selector(SendButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button2];
}


-(void)AddButtonBarToPreviewView:(UIView *)ScreenView fromTop:(float)top
{
    float FromTopForMain=(IsIphone5)?483.0f:395.0f;
    CGRect BottombarRect=CGRectMake(0.0f, FromTopForMain, 320.0f, 85.0f);
    
    float FormTop=40.0f;
    
    UIView *BottomBarView=[[UIView alloc] initWithFrame:BottombarRect];
    [BottomBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar.png"]]];
    [ScreenView addSubview:BottomBarView];
    
    CGRect Button1Rect=CGRectMake(103.5f, FormTop, 113.0f, 36.0f);
    UIButton *Button1=[[UIButton alloc] initWithFrame:Button1Rect];
    [Button1 setImage:[UIImage imageNamed:@"personalize.png"] forState:UIControlStateNormal];
    //[Button1 addTarget:self action:@selector(newestClicked) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button1];

}

-(void)AddButtonBarToSwipe:(UIView *)BottomBarView withStep:(int)step withIsFav:(bool)IsFav
{
    float FormTop=40.0f;
    
    CGRect Button1Rect, Button2Rect, FavButtonRect;
    UIButton *Button1, *Button2;
    
    switch(step)
    {
        case 1:
            Button1Rect=CGRectMake(34.0f, FormTop, 72.0f, 36.0f);
            Button1=[[UIButton alloc] initWithFrame:Button1Rect];
            [Button1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            [Button1 addTarget:self action:@selector(CancelAnimation) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:Button1];
            
            FavButtonRect=CGRectMake(140.0f, FormTop+5.0f, 34.0f, 29.0f);
            FavButton=[[UIButton alloc] initWithFrame:FavButtonRect];
            if(IsFav)
            {
                [FavButton setImage:[UIImage imageNamed:@"heart-red.png"] forState:UIControlStateNormal];
            }
            else
            {
                [FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
            }
            [FavButton addTarget:self action:@selector(PerformFav) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:FavButton];
            
            Button2Rect=CGRectMake(214.0f, FormTop, 72.0f, 36.0f);
            Button2=[[UIButton alloc] initWithFrame:Button2Rect];
            [Button2 setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
            [Button2 addTarget:self action:@selector(GoStep2) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:Button2];
            break;
            
        case 2:
            Button1Rect=CGRectMake(34.0f, FormTop, 72.0f, 36.0f);
            Button1=[[UIButton alloc] initWithFrame:Button1Rect];
            [Button1 setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
            [Button1 addTarget:self action:@selector(ReturnToStep1) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:Button1];
            
            FavButtonRect=CGRectMake(140.0f, FormTop+5.0f, 34.0f, 29.0f);
            FavButton=[[UIButton alloc] initWithFrame:FavButtonRect];
            if(IsFav)
            {
                [FavButton setImage:[UIImage imageNamed:@"heart-red.png"] forState:UIControlStateNormal];
            }
            else
            {
                [FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
            }

            [FavButton addTarget:self action:@selector(PerformFav) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:FavButton];
            
            Button2Rect=CGRectMake(214.0f, FormTop, 72.0f, 36.0f);
            Button2=[[UIButton alloc] initWithFrame:Button2Rect];
            [Button2 setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
            [Button2 addTarget:self action:@selector(GoStep3) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:Button2];
            break;
            
            
        case 3:
            Button1Rect=CGRectMake(34.0f, FormTop, 72.0f, 36.0f);
            Button1=[[UIButton alloc] initWithFrame:Button1Rect];
            [Button1 setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
            [Button1 addTarget:self action:@selector(ReturnToStep2) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:Button1];
            
            FavButtonRect=CGRectMake(140.0f, FormTop+5.0f, 34.0f, 29.0f);
            FavButton=[[UIButton alloc] initWithFrame:FavButtonRect];
            if(IsFav)
            {
                [FavButton setImage:[UIImage imageNamed:@"heart-red.png"] forState:UIControlStateNormal];
            }
            else
            {
                [FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
            }

            [FavButton addTarget:self action:@selector(PerformFav) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:FavButton];
            
            Button2Rect=CGRectMake(214.0f, FormTop, 72.0f, 36.0f);
            Button2=[[UIButton alloc] initWithFrame:Button2Rect];
            [Button2 setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
            [Button2 addTarget:self action:@selector(sendNow) forControlEvents:UIControlEventTouchUpInside];
            [BottomBarView addSubview:Button2];
            break;
    }
    
}


-(void)AddbuttonBarToSend:(UIView *)ScreenView
{
    float FromTopForMain=(IsIphone5)?483.0f:395.0f;
    CGRect BottombarRect=CGRectMake(0.0f, FromTopForMain, 320.0f, 85.0f);
    
    float FormTop=40.0f;
    
    UIView *BottomBarView=[[UIView alloc] initWithFrame:BottombarRect];
    [BottomBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar.png"]]];
    [ScreenView addSubview:BottomBarView];
    
    CGRect Button1Rect=CGRectMake(104.0f, FormTop, 113.0f, 28.0f);
    BtnSendCard=[[UIButton alloc] initWithFrame:Button1Rect];
    [BtnSendCard setImage:[UIImage imageNamed:@"send_card.png"] forState:UIControlStateNormal];
    [BtnSendCard addTarget:self action:@selector(SendMyCard) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:BtnSendCard];
}

-(void)SetBackground:(UIView *)VictimView
{
    UIGraphicsBeginImageContext(VictimView.frame.size);
    [[UIImage imageNamed:(IsIphone5)?@"bg.png":@"bg4.png"] drawInRect:VictimView.bounds];
    //[[UIImage imageNamed:@"background_scroll.jpg"] drawInRect:VictimView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    VictimView.backgroundColor=[UIColor colorWithPatternImage:image];
}

-(void)SetBackground:(UIView *)VictimView :(NSString *)ImageName
{
    UIGraphicsBeginImageContext(VictimView.frame.size);
    [[UIImage imageNamed:ImageName] drawInRect:VictimView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    VictimView.backgroundColor=[UIColor colorWithPatternImage:image];
}

-(void) PerformGoBackTo:(NSString *)HereWeGo : (BOOL)Animation
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    int index=0;
    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    for(int i=0 ; i<[arr count] ; i++)
    {
        if([[arr objectAtIndex:i] isKindOfClass:NSClassFromString(HereWeGo)])
        {
            index = i;
        }
    }
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToViewController:[arr objectAtIndex:index] animated:NO];
}

-(void)PerformGoBack
{
    @try
    {
        NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
        int index=[arr count]-2;
        
        NSLog(@"Array Length: %d || index: %d", [arr count], index);
        
       // [self.navigationController popToViewController:[arr objectAtIndex:index] animated:YES];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from PerformGoBack: %@", juju);
    }
}


-(void) PerformGoBackTo:(NSString *)HereWeGo
{
    int index=0;
    NSArray* arr = [[NSArray alloc] initWithArray:self.navigationController.viewControllers];
    for(int i=0 ; i<[arr count] ; i++)
    {
        if([[arr objectAtIndex:i] isKindOfClass:NSClassFromString(HereWeGo)])
        {
            index = i;
        }
    }
    [self.navigationController popToViewController:[arr objectAtIndex:index] animated:YES];
}


-(void)AddMesssageSeperator:(UIView *)ParentView fromTop :(float)top
{
    CGRect SeperatorRect=CGRectMake(10.0f, top, 280.0f, 30.0f);
    UILabel *Seperator1=[[UILabel alloc] initWithFrame:SeperatorRect];
    [Seperator1 setText:@"........"];
    [Seperator1 setFont:[UIFont fontWithName:@"papyrus" size:48.0f]];
    [Seperator1 setTextAlignment:NSTextAlignmentCenter];
    [Seperator1 setBackgroundColor:[UIColor clearColor]];
    [ParentView addSubview:Seperator1];
}

-(void)SetFontToLabels:(NSArray *)LblArray withSize:(float)size
{
    for(UILabel *Lbl in LblArray)
    {
        UILabel *TempLabel=(UILabel *)Lbl;
        [TempLabel setFont:[UIFont fontWithName:@"papyrus" size:size]];
        [TempLabel setBackgroundColor:[UIColor clearColor]];
        [TempLabel setTextColor:[UIColor blackColor]];
    }
}

-(void)SetFontToLabel:(UILabel *)VictimLbl withSize:(float)size
{
    [VictimLbl setFont:[UIFont fontWithName:@"papyrus" size:size]];
    [VictimLbl setBackgroundColor:[UIColor clearColor]];
    [VictimLbl setTextColor:UIColorFromRGB(0xe8661c)];
}


-(void)SetFontToTextField:(UITextField *)VictimField withSize:(float)size
{
    [VictimField setFont:[UIFont fontWithName:@"papyrus" size:size]];
    //[VictimField setTextColor:UIColorFromRGB(0xe8661c)];
}


-(void)SetFontToTextView:(UITextView *)VictimField withSize:(float)size
{
    [VictimField setFont:[UIFont fontWithName:@"papyrus" size:size]];
    //[VictimField setTextColor:UIColorFromRGB(0xe8661c)];
}

-(void)SetFonttoFields:(NSArray *)FieldSet withSize:(float)size
{
    [self SetFonttoFields:FieldSet withSize:size withBorderToFields:NO];
}

-(void)SetFonttoFields:(NSArray *)FieldSet withSize:(float)size withBorderToFields:(BOOL)needBorder
{
    for(UIView *tempView in FieldSet)
    {
        if([tempView class]==[UITextField class])
        {
            [self SetFontToTextField:(UITextField *)tempView withSize:size];
            if(needBorder)
            {
                [self SetBorderToField:(UITextField *)tempView];
            }
            
        }
        else if([tempView class]==[UILabel class])
        {
            [self SetFontToLabel:(UILabel *)tempView withSize:size];
        }
        else if([tempView class]==[UITextView class])
        {
            [self SetFontToTextView:(UITextView *)tempView withSize:size];
        }
    }
}

-(void)SetBorderTo:(NSArray *)FieldSet
{
    for(UIView *tempView in FieldSet)
    {
        [self SetBorderToField:tempView];
    }
}



-(NSString *)LocalDate
{
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}


-(UIImage *)TakeASnapShotOf:(UIView *)FamousView
{
    CGSize captureSize = CGSizeMake(320.0f, 280.0f);
    if(UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(captureSize, YES, 0.0);
    else
        UIGraphicsBeginImageContext(captureSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextScaleCTM(context, 1.0f, 1.0f);
    
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(0, 0));
    
    [FamousView.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


-(void)RemoveAllGestureFrom:(UIView *)ScreenView
{
    for (UIGestureRecognizer *recognizer in [ScreenView gestureRecognizers])
    {
        [ScreenView removeGestureRecognizer:recognizer];
    }
}




-(void)SetBorderToField:(UIView *)TxtField
{
    [[TxtField layer] setBorderColor:[UIColorFromRGB(0xc88e00) CGColor]];
    [[TxtField layer] setBorderWidth:1.0f];
}

-(void)FavButtonTouched
{
    FavouriteView *FavouriteViewNib=[[FavouriteView alloc] init];
    [[self navigationController] pushViewController:FavouriteViewNib animated:YES];
}

-(void)CalenderButtonTouched
{
    CalendarView *CalenderViewNib=[[CalendarView alloc] init];
    [[self navigationController] pushViewController:CalenderViewNib animated:YES];
}

-(void)newestClicked
{
    FavouriteView *FavouriteViewNib=[[FavouriteView alloc] init];
    [FavouriteViewNib setIsNewest:YES];
    [[self navigationController] pushViewController:FavouriteViewNib animated:YES];
}

-(void)moreClicked
{
    MoreMenuView *MoreMenuViewNib=[[MoreMenuView alloc] init];
    [[self navigationController] pushViewController:MoreMenuViewNib animated:YES];
}


@end
