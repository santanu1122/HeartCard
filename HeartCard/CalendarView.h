//
//  CalendarView.h
//  HeartCard
//
//  Created by Iphone_2 on 21/08/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface CalendarView : GlobalViewController
{
    
}

@property (strong, nonatomic) IBOutlet UIView *ScreenViewCalendar;
@property (strong, nonatomic) IBOutlet UIView *VInnerViewCalendar;
@property (strong, nonatomic) IBOutlet UIImageView *ImgCalendarBack;
@property (strong, nonatomic) IBOutlet UIScrollView *SVCalendarBack;

@end
