//
//  CalendarView.m
//  HeartCard
//
//  Created by Iphone_2 on 21/08/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "TPCalendar.h"
#import "CalendarView.h"
#import "ScheduledCards.h"


@interface CalendarView ()<TPCalendarDelegate>
{
    NSMutableArray *ScheduledDatesArray;
    NSOperationQueue *OperationQueueForCalendar;
    GlobalMethod *Method;
}

@property(nonatomic, weak) TPCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSMutableArray *disabledDates;

@end

@implementation CalendarView

@synthesize ScreenViewCalendar, VInnerViewCalendar, ImgCalendarBack,  SVCalendarBack;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"CalendarViewBig" bundle:nil]:[super initWithNibName:@"CalendarView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self PrepareScreens];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [self LoadCalendar];
}

-(void)PrepareScreens
{
    [self SetBackground:ScreenViewCalendar];
    [self AddTopBarToScreenView:ScreenViewCalendar withTitle:@"CALENDAR" WithFavIcon:YES];
    [self AddButtonBarToScreenView:ScreenViewCalendar];
    [ImgCalendarBack setImage:[UIImage imageNamed:@"calender_bg.png"]];
    
    if(!IsIphone5)
    {
        SVCalendarBack.contentSize = CGSizeMake(SVCalendarBack.frame.size.width, SVCalendarBack.frame.size.height+50.0f);
    }
    
    ScheduledDatesArray=[[NSMutableArray alloc] init];
    OperationQueueForCalendar=[[NSOperationQueue alloc] init];
    Method=[[GlobalMethod alloc] init];
    
    [self AssingWork];
}

-(void)LoadCalendar
{
    for(UIView *InnerSub in [VInnerViewCalendar subviews])
    {
        [InnerSub removeFromSuperview];
    }
    
    TPCalendarView *calendar = [[TPCalendarView alloc] initWithStartDay:startSunday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"01/01/2013"];
    
    
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = NO;
    
    
    calendar.frame = CGRectMake(0.0f, 0.0f, 280.0f, 308.0f);
    [VInnerViewCalendar addSubview:calendar];
    
}

-(void)goBack
{
    [self PerformGoBackTo:@"CategoryView"];
}


-(void)AssingWork
{
    @autoreleasepool
    {
        NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getScheduledDates) object:nil];
        [OperationQueueForCalendar addOperation:Operation];
    }
}





#pragma mark For Thread Segments
 
-(void)getScheduledDates
{
    @try
    {
        NSString *URL=[NSString stringWithFormat:@"%@ScheduledCards.php?deviceId=%@&today=%@", API, DeviceId, [Method Encoder:[self LocalDate]]];
        NSLog(@"%@", URL);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>0)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            for(NSDictionary *var in getArray)
            {
                [ScheduledDatesArray addObject:[var objectForKey:@"sendDate"]];
            }
            if([ScheduledDatesArray count]>0)
            {
                [self performSelectorOnMainThread:@selector(gotScheduledDates) withObject:nil waitUntilDone:YES];
            }
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getCardsFor : %@", juju);
    }
}





#pragma mark for Main Thread Segments

-(void)gotScheduledDates
{
    NSDateFormatter *formatter, *Formatter1;
    
    formatter = [[NSDateFormatter alloc] init];
    Formatter1 = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [Formatter1 setDateFormat:@"dd/MM/yyyy"];
    
    @try
    {
        NSMutableArray *SelectedDatesArray;
        SelectedDatesArray=[[NSMutableArray alloc] init];
        
        for(NSString *DateString in ScheduledDatesArray)
        {
            [SelectedDatesArray addObject:[self.dateFormatter dateFromString:[Formatter1 stringFromDate:[formatter dateFromString:DateString]]]];
        }
        
        self.disabledDates=SelectedDatesArray;
        
        if([SelectedDatesArray count]>0)
        {
            [self LoadCalendar];
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"%@", juju);
    }
    
}



#pragma mark - TPCalendarDelegate

- (void)calendar:(TPCalendarView *)calendar configureDateItem:(TPDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date])
    {
        dateItem.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"calendar_date_selected.png"]];
        dateItem.textColor=[UIColor redColor];
    }
}

- (BOOL)calendar:(TPCalendarView *)calendar willSelectDate:(NSDate *)date
{
    //return ![self dateIsDisabled:date];
    return TRUE;
}

- (void)calendar:(TPCalendarView *)calendar didSelectDate:(NSDate *)date
{
    ScheduledCards *ScheduledCardsNib=[[ScheduledCards alloc] init];
    [ScheduledCardsNib setSelectedDate:date];
    [[self navigationController] pushViewController:ScheduledCardsNib animated:YES];
}

- (BOOL)calendar:(TPCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    if ([date laterDate:self.minimumDate] == date)
    {
        //self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    }
    else
    {
        //self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(TPCalendarView *)calendar didLayoutInRect:(CGRect)frame
{
    //NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (BOOL)dateIsDisabled:(NSDate *)date
{
    for (NSDate *disabledDate in self.disabledDates)
    {
        if ([disabledDate isEqualToDate:date])
        {
            return YES;
        }
    }
    return NO;
}

@end
