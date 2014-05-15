//
//  ScheduledCards.m
//  HeartCard
//
//  Created by Iphone_2 on 22/08/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "ScheduledCards.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
@interface ScheduledCards ()
{
    NSMutableArray *CardContainerArray;
    NSOperationQueue *OperationQueueForScheduler;
    GlobalMethod *Method;
    NSArray *IObjectCarrier;
    BOOL UserHasExist;
    CGRect initialFrame;
}

@end

@implementation ScheduledCards

static NSString * const CANCELCARD_TITLE                    = @"Cancelling this card?";
static NSString * const CANCELCARD_MESSAGE                  = @"By cancelling this card,\n It will not be sent and \n you will lose this card credit.";
static NSString * const CANCELCARD_NO_BUTTON_TILTLE         = @"Don’t Cancel";
static NSString * const CANCELCARD_YES_BUTTON_TILTLE        = @"Yes Cancel";

@synthesize ScreenViewScheduler, SpinnerScheduler, TVScheduler, SelectedDate, BackView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       self=(IsIphone5)?[super initWithNibName:@"ScheduledCardsBig" bundle:nil]:[super initWithNibName:@"ScheduledCards" bundle:nil];
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


-(void)PrepareScreens
{
    [self AddButtonBarToScreenView:ScreenViewScheduler];
    
    [[self BackView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:(IsIphone5)?@"background_scroll.jpg":@"background_scroll4.jpg"]]];
    UserHasExist=FALSE;
    
    
    NSDateFormatter *DateFormatter;
    
    @autoreleasepool
    {
        CardContainerArray = [[NSMutableArray alloc] init];
        OperationQueueForScheduler=[[NSOperationQueue alloc] init];
        Method=[[GlobalMethod alloc] init];
        DateFormatter=[[NSDateFormatter alloc] init];
    }
    
    [DateFormatter setDateFormat:@"MMMM-dd-yyyy"];
    [self AddTopBarToScreenView:ScreenViewScheduler withTitle:[DateFormatter stringFromDate:SelectedDate] WithFavIcon:YES];
    
    [[self TVScheduler] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self AssignWorks];
}


-(void)goBack
{
    UserHasExist=TRUE;
    [self PerformGoBackTo:@"CalendarView"];
}

-(void)AssignWorks
{
    NSDateFormatter *formatter;
    NSString *SelectedDateString;
    
    @autoreleasepool
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        SelectedDateString = [formatter stringFromDate:SelectedDate];
        
        NSInvocationOperation *operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getCardsFor:) object:SelectedDateString];
        [OperationQueueForScheduler addOperation:operation];
    }    
}


#pragma mark for Thread Segments


-(void)getCardsFor:(NSString *)PSelectedDate
{
    @try
    {
        NSString *URL=[NSString stringWithFormat:@"%@ScheduledCards_V2.php?forDate=%@&deviceId=%@", API, [Method Encoder:PSelectedDate], DeviceId];
        NSLog(@"%@", URL);
        
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        
        if([getData length]>0)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
                        
            for(NSDictionary *var in getArray)
            {
                [CardContainerArray addObject:[[GlobalMethod alloc] initWithId:[var objectForKey:@"card_id"] withMessage1:[var objectForKey:@"message1"] withMessage2:[var objectForKey:@"message2"] withDate:[var objectForKey:@"sendDate"] withCardImage:[var objectForKey:@"card_image"] withAttachedImage:[var objectForKey:@"image"] withSenderName:[var objectForKey:@"sender_name"] withReceiverName:[var objectForKey:@"receiver_name"] withReceiverPhoneNo:[var objectForKey:@"receiver_ph"] withScheduleID:[var objectForKey:@"sendId"] withCancelStatus:[var objectForKey:@"CancelStatus"]]];
            }
            if([CardContainerArray count]>0)
            {
                [self performSelectorOnMainThread:@selector(gotCardss) withObject:nil waitUntilDone:YES];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self ShowError];
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
               [self ShowError];
            });
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from getCardsFor : %@", juju);
    }
}


-(void) DownloadImage:(NSArray *)ParamArray //0.ImageView 1.ImageUrl 2.Spinner
{
    @try
    {
        UIImage *TempCardImage;
//        NSLog(@"ParamArray ---- %@",ParamArray);
//        NSString *ImageUrl=[NSString stringWithFormat:@"%@",[ParamArray objectAtIndex:1]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ImageUrl]];
//        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
//        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            
//            NSMutableArray *ObjectCarrier=[[NSMutableArray alloc] initWithObjects: [ParamArray objectAtIndex:0], responseObject, [ParamArray objectAtIndex:2], nil];
//            [self performSelectorOnMainThread:@selector(FinishImageLoading:) withObject:ObjectCarrier waitUntilDone:NO];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Image error: %@", error);
//        }];
//        [requestOperation start];
        
        NSString *ImageUrl=[NSString stringWithFormat:@"%@",[ParamArray objectAtIndex:1]];
        NSLog(@"ImageUrl -------- %@",ImageUrl);
        NSData *ImageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:ImageUrl]];
        
        TempCardImage=[UIImage imageWithData:ImageData];
        
        NSMutableArray *ObjectCarrier=[[NSMutableArray alloc] initWithObjects: [ParamArray objectAtIndex:0], TempCardImage, [ParamArray objectAtIndex:2], nil];
        [self performSelectorOnMainThread:@selector(FinishImageLoading:) withObject:ObjectCarrier waitUntilDone:NO];
    }
    @catch (NSException *juju)
    {
         NSLog(@"Reporting juju from DownloadImage : %@", juju);
    }
}


#pragma mark for Main Thread Segments


-(void) FinishImageLoading :(NSArray *) ParamArray //0.ImageView 1.Image 2.Spinner
{
    @try
    {
        UIImageView *CardImage=(UIImageView *)[ParamArray objectAtIndex:0];
        [CardImage setImage:(UIImage *)[ParamArray objectAtIndex:1]];
        [CardImage setContentMode:UIViewContentModeScaleToFill];
        UIActivityIndicatorView *TempSpinner=(UIActivityIndicatorView *)[ParamArray objectAtIndex:2];
        [TempSpinner stopAnimating];
        [CardImage setUserInteractionEnabled:YES];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from FinishImageLoading : %@", juju);
    }
}


-(void)ShowError
{
    @try
    {
        if(!UserHasExist)
        {
            UIAlertView *showError=[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"No Card Found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [showError setTag:12];
            [showError show];
        }
    }
    @catch (NSException *juju)
    {
        NSLog(@"Ami j juju sona:: %@", juju);
    }
}


-(void) gotCardss
{
    [[self SpinnerScheduler] stopAnimating];
    [[self TVScheduler] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    initialFrame=[BackView frame];
    initialFrame.size.height+=[CardContainerArray count]*165;
    [BackView setFrame:initialFrame];
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CardContainerArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell=[[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] objectAtIndex:0];
    
    UIView *BackView1=[[UIView alloc] initWithFrame:[cell frame]];
    [BackView1 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
    
    [cell setBackgroundView:BackView1];
    
    Method=[CardContainerArray objectAtIndex:indexPath.row];
    
    if([Method CardImageURL])
    {
        UIImageView *AttachedImage=(UIImageView *)[cell viewWithTag:1];
        [[AttachedImage layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[AttachedImage layer] setBorderWidth:1.0f];
        
        UIActivityIndicatorView *Spinner=(UIActivityIndicatorView *)[AttachedImage viewWithTag:1];
        NSLog(@"Spinner ---- %@",Spinner);
        
        IObjectCarrier=[[NSArray alloc] initWithObjects:AttachedImage, [Method CardImageURL], Spinner, nil];
        [self LoadImage:IObjectCarrier];
    }
    
    UILabel *LblRecieverName=(UILabel *)[cell viewWithTag:2];
    [LblRecieverName setText:[Method ReceiverName]];
    [LblRecieverName setFont:[UIFont fontWithName:@"Papyrus" size:14]];

    
    UITextView *TxtVMessage=(UITextView *)[cell viewWithTag:3];
    [TxtVMessage setText:[Method Message]];
    [TxtVMessage setFont:[UIFont fontWithName:@"Papyrus" size:12]];
    [TxtVMessage setEditable:NO];
    
    UILabel *LblSenderName=(UILabel *)[cell viewWithTag:4];
    [LblSenderName setText:[Method SenderName]];
    [LblSenderName setFont:[UIFont fontWithName:@"Papyrus" size:14]];
    //int i=0;
    
    UIButton *CancelOrSendScheduleButton = (UIButton *)[cell.contentView viewWithTag:900];
    [CancelOrSendScheduleButton setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *CancelOrSendScheduleImage = (UIImageView *)[cell.contentView viewWithTag:888];
    [CancelOrSendScheduleImage setBackgroundColor:[UIColor clearColor]];
    
    UILabel *TextLabel = (UILabel *)[cell.contentView viewWithTag:889];
    [TextLabel setBackgroundColor:[UIColor clearColor]];
    
    if ([[Method ParamCancelStatus] isEqualToString:@"Y"]) {
        
        [CancelOrSendScheduleImage setImage:[UIImage imageNamed:@"CancelOne"]];
        
        [TextLabel setText:@"Cancel"];
        [TextLabel setTextColor:UIColorFromRGB(0xdb0b35)];
        [TextLabel setFont:[UIFont fontWithName:@"Papyrus" size:12]];
        
        [CancelOrSendScheduleButton setTitle:[NSString stringWithFormat:@"%@",[Method ScheduleID]] forState:UIControlStateNormal];
        [CancelOrSendScheduleButton addTarget:self action:@selector(CancelOrSendScheduleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [CancelOrSendScheduleButton.titleLabel removeFromSuperview];
        [CancelOrSendScheduleButton setUserInteractionEnabled:YES];
        
    } else {
        
        [CancelOrSendScheduleImage setImage:[UIImage imageNamed:@"SaveOne"]];
        
        [TextLabel setText:@"Sent"];
        [TextLabel setTextColor:UIColorFromRGB(0x2e801c)];
        [TextLabel setBackgroundColor:[UIColor clearColor]];
        [TextLabel setFont:[UIFont fontWithName:@"Papyrus" size:16]];
        
        [CancelOrSendScheduleButton setTitle:@"0" forState:UIControlStateNormal];
        [CancelOrSendScheduleButton.titleLabel removeFromSuperview];
        [CancelOrSendScheduleButton setUserInteractionEnabled:NO];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}
-(IBAction)CancelOrSendScheduleButtonClicked:(UIButton *)ButtonSender {
    
    UIAlertView *WarningAlert = [[UIAlertView alloc] initWithTitle:CANCELCARD_TITLE message:CANCELCARD_MESSAGE delegate:self cancelButtonTitle:CANCELCARD_NO_BUTTON_TILTLE otherButtonTitles:CANCELCARD_YES_BUTTON_TILTLE, nil];
    [WarningAlert setTag:156];
    [WarningAlert setAccessibilityLabel:ButtonSender.titleLabel.text];
   // WarningAlert.delegate = self;
    [WarningAlert show];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
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


#pragma mark for delegates


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 156) {
        if(buttonIndex==0) {
            NSLog(@"i am clicked on cancel");
        } else {
            NSLog(@"i am clicked on delete card");
            NSLog(@"---- cardid ---- %@",[alertView accessibilityLabel]);
            
            UIActivityIndicatorView *ActivityIndiCator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -10, self.view.frame.size.height/2 -10, 20, 20)];
            [ActivityIndiCator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            [ActivityIndiCator setBackgroundColor:[UIColor clearColor]];
            [ActivityIndiCator setHidesWhenStopped:YES];
            [ActivityIndiCator setUserInteractionEnabled:NO];
            [ActivityIndiCator setHidden:NO];
            [self.view addSubview:ActivityIndiCator];
            [ActivityIndiCator startAnimating];
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                NSString *URL=[NSString stringWithFormat:@"%@cancelCard_V2.php?id=%d&deviceId=%@", API, [[alertView accessibilityLabel] intValue], DeviceId];
                NSLog(@"%@", URL);
                //exit(0);
                NSData *Data=[NSData dataWithContentsOfURL:[Method ConvertStringToNSUrl:URL]];
                NSString *OutPutString=[Method ConvertNSDataToNSString:Data];
                NSLog(@"OutPutString ---- %@",OutPutString);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [ActivityIndiCator stopAnimating];
                    if ([OutPutString isEqualToString:@"Y"]) {
                        UIAlertView *AlertErr = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your card deleted successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [AlertErr setTag:777];
                        [AlertErr show];
                    } else {
                        UIAlertView *AlertErr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some err" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [AlertErr show];
                    }
                });
            });
        }
    } else if (alertView.tag == 777) {
        NSLog(@"i am again going to call assignwork");
        [self PrepareScreens];
    } else {
        if(buttonIndex==0)
        {
            if([alertView tag]==12)
            {
                [self goBack];
            }
        }
    }
}

@end
