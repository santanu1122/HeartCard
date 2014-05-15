//
//  TPCalendar.h
//  HeartCard
//
//  Created by Iphone_2 on 21/08/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TPCalendarDelegate;


@interface TPDateItem : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@end

typedef enum {
    startSunday = 1,
    startMonday = 2,
} TPCalendarStartDay;


@interface TPCalendarView : UIView

- (id)initWithStartDay:(TPCalendarStartDay)firstDay;
- (id)initWithStartDay:(TPCalendarStartDay)firstDay frame:(CGRect)frame;

@property (nonatomic) TPCalendarStartDay calendarStartDay;
@property (nonatomic, strong) NSLocale *locale;

@property (nonatomic, readonly) NSArray *datesShowing;

@property (nonatomic) BOOL onlyShowCurrentMonth;
@property (nonatomic) BOOL adaptHeightToNumberOfWeeksInMonth;

@property (nonatomic, weak) id<TPCalendarDelegate> delegate;

// Theming
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *dateOfWeekFont;
@property (nonatomic, strong) UIColor *dayOfWeekTextColor;
@property (nonatomic, strong) UIFont *dateFont;

- (void)setMonthButtonColor:(UIColor *)color;
- (void)setInnerBorderColor:(UIColor *)color;
- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor;

- (void)selectDate:(NSDate *)date makeVisible:(BOOL)visible;
- (void)reloadData;
- (void)reloadDates:(NSArray *)dates;

// Helper methods for delegates, etc.
- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2;
- (BOOL)dateIsInCurrentMonth:(NSDate *)date;

@end

@protocol TPCalendarDelegate <NSObject>

@optional
- (void)calendar:(TPCalendarView *)calendar configureDateItem:(TPDateItem *)dateItem forDate:(NSDate *)date;
- (BOOL)calendar:(TPCalendarView *)calendar willSelectDate:(NSDate *)date;
- (void)calendar:(TPCalendarView *)calendar didSelectDate:(NSDate *)date;
- (BOOL)calendar:(TPCalendarView *)calendar willDeselectDate:(NSDate *)date;
- (void)calendar:(TPCalendarView *)calendar didDeselectDate:(NSDate *)date;

- (BOOL)calendar:(TPCalendarView *)calendar willChangeToMonth:(NSDate *)date;
- (void)calendar:(TPCalendarView *)calendar didChangeToMonth:(NSDate *)date;

- (void)calendar:(TPCalendarView *)calendar didLayoutInRect:(CGRect)frame;

@end