//
//  ScheduledCards.h
//  HeartCard
//
//  Created by Iphone_2 on 22/08/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface ScheduledCards : GlobalViewController< UIGestureRecognizerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @public NSDate *SelectedDate;
    UIGestureRecognizer *TapRecognizer;
}

@property (nonatomic, retain) NSDate *SelectedDate;

@property (strong, nonatomic) IBOutlet UIView *ScreenViewScheduler;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *SpinnerScheduler;
@property (strong, nonatomic) IBOutlet UITableView *TVScheduler;
@property (strong, nonatomic) IBOutlet UIView *BackView;

@end
