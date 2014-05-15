//
//  ViaTextMessageView.m
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "ViaTextMessageView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViaTextMessageView ()
{
    UIActionSheet *menu;
    UIDatePicker *datePicker;
    GlobalMethod *Method;
    NSOperationQueue *OperationQueueForTextMessage;
}

@end

@implementation ViaTextMessageView

@synthesize ScreenViewViaMessage, TxtName, TxtPhone, LblFrom, LblTo, UVBackTxt1, UVBackTxt2, LblErrorMessage, UniqueCardId, TxtSelectDate, UVBackTxt3;
@synthesize ParamChooseMsg, ParamCustomMsg, ParamUploadedImage, ParamLastSenderName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
         self=(IsIphone5)?[super initWithNibName:@"ViaTextMessageViewBig" bundle:nil]:[super initWithNibName:@"ViaTextMessageView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self PrepareScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ShowAnimation
{
    UIImageView *FavImage=[[UIImageView alloc] initWithFrame:CGRectMake(138, 483, 40, 40)];
    NSLog(@"------ %@",FavImage);
    [FavImage setImage:[UIImage imageNamed:@"heart-red.png"]];
    [self.view addSubview:FavImage];
    
    [UIImageView animateWithDuration:1.0f animations:^{
        
        CGRect FavRect=[FavImage frame];
        FavRect.origin.y-=300.0f;
        FavRect.origin.x-=27.0f;
        FavRect.size.height+=50.0f;
        FavRect.size.width+=50.0f;
        [FavImage setFrame:FavRect];
        [FavImage setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        [FavImage removeFromSuperview];
        
    }];
}
-(void)PrepareScreen
{
    [self SetBackground:ScreenViewViaMessage];
    [self setHeaderSize:19.0f];
    [self AddTopBarToScreenView:ScreenViewViaMessage withTitle:@"SEND YOUR CARD" WithFavIcon:YES];
    [self AddbuttonBarToSend:ScreenViewViaMessage];
    
    [self SetFontToLabel:LblFrom withSize:14.0f];
    [self SetFontToLabel:LblTo withSize:14.0f];
    [self SetFontToLabel:LblErrorMessage withSize:14.0f];
    [self SetFontToTextField:TxtName withSize:14.0f];
    [self SetFontToTextField:TxtPhone withSize:14.0f];
    [self SetFontToTextField:TxtSelectDate withSize:14.0f];
    
    [[UVBackTxt1 layer] setBorderColor:[UIColorFromRGB(0xc88e00) CGColor]];
    [[UVBackTxt2 layer] setBorderColor:[UIColorFromRGB(0xc88e00) CGColor]];
    [[UVBackTxt3 layer] setBorderColor:[UIColorFromRGB(0xc88e00) CGColor]];
    
    [[UVBackTxt1 layer] setBorderWidth:1.0f];
    [[UVBackTxt2 layer] setBorderWidth:1.0f];
    [[UVBackTxt3 layer] setBorderWidth:1.0f];
    
    Method=[[GlobalMethod alloc] init];
    
    
    [[self TxtName] setText:ParamLastSenderName];
    
    
    datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 320, 100)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    [datePicker setMinimumDate:tomorrow];
    
    NSDateComponents* addOneMonthComponents = [NSDateComponents new] ;
    addOneMonthComponents.year = 1 ;
    NSDate* NextYear = [[NSCalendar currentCalendar] dateByAddingComponents:addOneMonthComponents toDate:[NSDate date] options:0];
    [datePicker setMaximumDate:NextYear];
    
    
    OperationQueueForTextMessage=[[NSOperationQueue alloc] init];
    
    [datePicker setMinimumDate:tomorrow];
    
    menu = [[UIActionSheet alloc] initWithTitle:@"Select a Date" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    
}

-(void)goBack
{
    [self PerformGoBackTo:@"SendView"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[self view] endEditing:YES];
    if(textField==TxtSelectDate)
    {
        [self ShowDatePicker];
        return NO;
    }
    else if(textField==TxtPhone)
    {
        if([[textField text] length]>0)
        {
            return YES;
        }
        else
        {
            [self ShowAllContacts];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


-(void)ShowAllContacts
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(void)PopulateContactsInfo :(ABRecordRef)person
{
   // NSString *name = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    NSString* phone = nil;
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,  kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneNumbers) > 0)
    {
        phone = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    }
    else
    {
        phone = @"";
    }
    
    [TxtPhone setText:phone];
    
    CFRelease(phoneNumbers);
}


-(void)ShowDatePicker
{
    [menu setUserInteractionEnabled:YES];
    [menu addSubview:datePicker];
    [menu showInView:ScreenViewViaMessage];
    [menu setBounds:CGRectMake(0,0,320, 600)];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Cancel"])
    {
        [datePicker removeFromSuperview];
    }
    else if ([buttonTitle isEqualToString:@"Done"])
    {
        NSArray *tempArray=[[NSString stringWithFormat:@"%@",[datePicker date]] componentsSeparatedByString:@" "];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
        NSDate *newDateFormat=[dateFormatter dateFromString:(NSString *)[tempArray objectAtIndex:0]];
        [dateFormatter setDateFormat:@"mm/dd/yyyy"];
        [TxtSelectDate setText:[dateFormatter stringFromDate:newDateFormat]];
    }
}



-(void)SendMyCard
{
    [[self view] endEditing:YES];
    
    if(![[TxtName text] length]>0)
    {
        [LblErrorMessage setText:@"Please Enter Your Name"];
    }
    else if(![[TxtPhone text] length]>0)
    {
        [LblErrorMessage setText:@"Please Enter Their Phone"];
    }
    else
    {
        [BtnSendCard setUserInteractionEnabled:NO];
        [LblErrorMessage setText:@""];
        [self ShowAnimation];
        @autoreleasepool
        {            
            NSMutableDictionary *ObjectCarrier;
            ObjectCarrier=[[NSMutableDictionary alloc] init];
            [ObjectCarrier setObject:[TxtName text] forKey:@"name"];
            [ObjectCarrier setObject:[TxtPhone text] forKey:@"rPhone"];
            [ObjectCarrier setObject:[TxtSelectDate text] forKey:@"sendDate"];
            if(ParamUploadedImage)
            {
                [ObjectCarrier setObject:ParamUploadedImage forKey:@"AttachtedImage"];
            }
            [ObjectCarrier setObject:ParamChooseMsg forKey:@"message1"];
            [ObjectCarrier setObject:ParamCustomMsg forKey:@"message2"];
            
            [self ChangeCredit];
            
            NSInvocationOperation *SendOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(SendViaTextMessage:) object:ObjectCarrier];
            [OperationQueueForTextMessage addOperation:SendOperation];
        }
    }
}

#pragma marks for Thread Segments


-(void)ChangeCredit
{
    
    NSUserDefaults *UserDefaults=[[NSUserDefaults alloc] init];
    
    int NewCredit=(int)[UserDefaults integerForKey:SESSION_USERCREDITS];
    NewCredit-=1;
    
    [UserDefaults setInteger:NewCredit forKey:SESSION_USERCREDITS];
    [UserDefaults synchronize];
    
    NSString *URL=[NSString stringWithFormat:@"%@userCredits_V2.php?objectType=set&TotalCredit=%d&deviceId=%@", API, NewCredit, DeviceId];
    NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Fire:) object:URL];
    [OperationQueueForTextMessage addOperation:Operation];
}

-(void)Fire:(NSString *)URL
{
    @try
    {
        NSLog(@"%@", URL);
        [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from Fire: %@", juju);
    }
}


-(void)SendViaTextMessage:(NSMutableDictionary *)Param
{
    @try
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm/dd/yyyy"];
        NSDate *newDateFormat=[dateFormatter dateFromString:(NSString *)[Param objectForKey:@"sendDate"]];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
        NSString *NewDateFormat = [dateFormatter stringFromDate:newDateFormat];
                
        NSString *url=[NSString stringWithFormat:@"%@SendCard_V2.php?name=%@&date=%@&cardId=%@&message=%@&cMessage=%@&via=4&deviceId=%@&rPhoneNo=%@", API, [Method Encoder:[Param objectForKey:@"name"]], [Method Encoder:NewDateFormat], UniqueCardId, [Method Encoder:[Param objectForKey:@"message1"]], [Method Encoder:[Param objectForKey:@"message2"]], DeviceId, [Method Encoder:[Param objectForKey:@"rPhone"]]];
        NSLog(@"%@", url);
        
        NSURL* requestURL = [NSURL URLWithString:url];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setURL:requestURL];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        NSURLResponse *response = nil;
        NSError *error;
        
        NSData *tempimg=(NSData *)[Param objectForKey:@"AttachtedImage"];
        
        if(tempimg)
        {
            NSString *boundary = [NSString stringWithFormat:@"%0.9u",arc4random()];
            
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            
            
            NSMutableData *body = [NSMutableData data];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_upload\"; filename=\"sampleImage.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[NSData dataWithData:tempimg]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
        }
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if([returnData length]>2)
        {
            NSMutableDictionary *returnArray=[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
            
            if([(NSString *)[returnArray valueForKey:@"response_type"] isEqualToString:@"Success"])
            {
                [self performSelectorOnMainThread:@selector(CardHasSent) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(Faild:) withObject:@"Sorry!! Failed to send your card." waitUntilDone:NO];
            }
        }
    }
    @catch(NSException *juju)
    {
        //Play with your little juju.
        NSLog(@"Reporting Juju :: %@", juju);
    }
}

-(void)CardHasSent
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Card has been scheduled successfully and will be sent automatically." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)Faild:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}




#pragma mark for delegates method



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self PerformGoBackTo:@"CategoryView"];
}


-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self PopulateContactsInfo:person];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    return NO;
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    return NO;
    
}

@end
