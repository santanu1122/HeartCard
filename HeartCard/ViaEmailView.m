//
//  ViaEmailView.m
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "ViaEmailView.h"

@interface ViaEmailView ()
{
    UIActionSheet *menu;
    UIDatePicker *datePicker;
    NSOperationQueue *OperationQueueForEmail;
    GlobalMethod *Method;
}

@end

@implementation ViaEmailView

@synthesize ScreenViewEmail, TxtBackView1, TxtBackView2, TxtBackView3, TxtBackView4, TxtBackView5, TxtSelectDate, TxtTheirEmail, TxtTheirName, TxtYourEmail, TxtYourName, LblFrom, LblTo, SVBackView, LblErrorEmail, UniqueCardId, Spinner;
@synthesize ParamChooseMsg, ParamCustomMsg, ParamUploadedImage, ParamLastSenderName, ParamLastSenderEmail;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"ViaEmailViewBig" bundle:nil]:[super initWithNibName:@"ViaEmailView" bundle:nil];
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

-(void)PrepareScreen
{
    [self SetBackground:ScreenViewEmail];
    [self setHeaderSize:19.0f];
    [self AddTopBarToScreenView:ScreenViewEmail withTitle:@"SEND YOUR CARD" WithFavIcon:YES];
    [self AddbuttonBarToSend:ScreenViewEmail];
    
    [[self TxtYourEmail] setText:ParamLastSenderEmail];
    [[self TxtYourName] setText:ParamLastSenderName];

    NSArray *FieldsArray=[[NSArray alloc] initWithObjects:TxtYourEmail, TxtYourName, TxtTheirEmail, TxtSelectDate, TxtTheirName, LblFrom, LblTo, LblErrorEmail, nil];
    [self SetFonttoFields:FieldsArray withSize:14.0f];
    
    NSArray *BorderView=[[NSArray alloc] initWithObjects:TxtBackView1,TxtBackView2,TxtBackView3,TxtBackView4,TxtBackView5, nil];
    [self SetBorderTo:BorderView];
    
    OperationQueueForEmail=[[NSOperationQueue alloc] init];
    
    Method=[[GlobalMethod alloc] init];
    
    datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 320, 100)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    [datePicker setMinimumDate:tomorrow];
    
    NSDateComponents* addOneMonthComponents = [NSDateComponents new] ;
    addOneMonthComponents.year = 1 ;
    NSDate* NextYear = [[NSCalendar currentCalendar] dateByAddingComponents:addOneMonthComponents toDate:[NSDate date] options:0];
    [datePicker setMaximumDate:NextYear];
    
    menu = [[UIActionSheet alloc] initWithTitle:@"Select a Date" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    
}

-(void)goBack
{
    [self PerformGoBackTo:@"SendView"];
}


#pragma mark for Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField!=TxtSelectDate && textField!=TxtYourEmail && textField!=TxtYourName)
    {
        float height=SVBackView.frame.size.height;
        height+=146.0f;
        
        SVBackView.contentSize = CGSizeMake(SVBackView.frame.size.width, height);
        
        CGPoint bottomOffset = CGPointMake(0.0f, SVBackView.contentSize.height - SVBackView.bounds.size.height);
        [SVBackView setContentOffset:bottomOffset animated:YES];

    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.40f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         SVBackView.contentSize = CGSizeMake(SVBackView.frame.size.width, SVBackView.frame.size.height-50.0f);
                         
                     }completion:^(BOOL finished)
     {
         
         
     }];
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[self view] endEditing:YES];
    if(textField==TxtSelectDate)
    {
        [self ShowDatePicker];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}





-(void)ShowDatePicker
{
    [menu setUserInteractionEnabled:YES];
    [menu addSubview:datePicker];
    [menu showInView:ScreenViewEmail];
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

-(void)SendMyCard
{
    [[self view] endEditing:YES];
    
    if(!IsIphone5)
    {
        float height=SVBackView.frame.size.height;
        height+=30.0f;
        
        SVBackView.contentSize = CGSizeMake(SVBackView.frame.size.width, height);
        
        CGPoint bottomOffset = CGPointMake(0.0f, SVBackView.contentSize.height - SVBackView.bounds.size.height);
        [SVBackView setContentOffset:bottomOffset animated:YES];
    }
    
    if(![[TxtYourName text] length]>0)
    {
        [LblErrorEmail setText:@"Please Enter Your Name"];
    }
    else if(![[TxtYourEmail text] length]>0)
    {
        [LblErrorEmail setText:@"Please Enter Your Email"];
    }
    else if(![[TxtTheirName text] length]>0)
    {
        [LblErrorEmail setText:@"Please Enter Their Name"];
    }
    else if(![[TxtTheirEmail text] length]>0)
    {
        [LblErrorEmail setText:@"Please Enter Their Email"];
    }
    else if(![[TxtSelectDate text] length]>0)
    {
        [LblErrorEmail setText:@"Please Select a date"];
    }
    else
    {
        bool IsReady=FALSE;
        NSString *emailid = TxtYourEmail.text;
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
        if(!myStringMatchesRegEx)
        {
            [LblErrorEmail setText:@"Your Email is Invalid"];
        }
        else
        {
            emailid = TxtTheirEmail.text;
            myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
            if(!myStringMatchesRegEx)
            {
                [LblErrorEmail setText:@"Their Email is Invalid"];
            }
            else
                IsReady=TRUE;
        }
        
        if(IsReady)
        {
            [LblErrorEmail setText:@""];
            [self ShowAnimation];
            //Send Card
            
            NSMutableDictionary *ObjectCarrier;
            ObjectCarrier=[[NSMutableDictionary alloc] init];
            [ObjectCarrier setObject:[TxtYourName text] forKey:@"name"];
            [ObjectCarrier setObject:[TxtYourEmail text] forKey:@"email"];
            [ObjectCarrier setObject:[TxtTheirEmail text] forKey:@"rEmail"];
            [ObjectCarrier setObject:[TxtTheirName text] forKey:@"rName"];
            [ObjectCarrier setObject:[TxtSelectDate text] forKey:@"sendDate"];
            if(ParamUploadedImage)
            {
                [ObjectCarrier setObject:ParamUploadedImage forKey:@"AttachtedImage"];
            }
            [ObjectCarrier setObject:ParamChooseMsg forKey:@"message1"];
            [ObjectCarrier setObject:ParamCustomMsg forKey:@"message2"];
            
            [BtnSendCard setUserInteractionEnabled:NO];
            [Spinner startAnimating];
            
            float height=SVBackView.frame.size.height;
            height+=145.0f;
            
            SVBackView.contentSize = CGSizeMake(SVBackView.frame.size.width, height);
            
            CGPoint bottomOffset = CGPointMake(0.0f, SVBackView.contentSize.height - SVBackView.bounds.size.height);
            [SVBackView setContentOffset:bottomOffset animated:YES];
            
            [self ChangeCredit];
            
            NSInvocationOperation *SendOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(SendViaEmail:) object:ObjectCarrier];
            [OperationQueueForEmail addOperation:SendOperation];
            
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
    [OperationQueueForEmail addOperation:Operation];
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


-(void)SendViaEmail:(NSMutableDictionary *)Param
{
    @try
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm/dd/yyyy"];
        NSDate *newDateFormat=[dateFormatter dateFromString:(NSString *)[Param objectForKey:@"sendDate"]];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
        NSString *NewDateFormat = [dateFormatter stringFromDate:newDateFormat];
        
        NSString *url=[NSString stringWithFormat:@"%@SendCard_V2.php?rEmail=%@&email=%@&rName=%@&name=%@&date=%@&cardId=%@&message=%@&cMessage=%@&via=1&deviceId=%@", API, [Method Encoder:[Param objectForKey:@"rEmail"]],[Method Encoder:[Param objectForKey:@"email"]], [Method Encoder:[Param objectForKey:@"rName"]], [Method Encoder:[Param objectForKey:@"name"]], [Method Encoder:NewDateFormat], UniqueCardId, [Method Encoder:[Param objectForKey:@"message1"]], [Method Encoder:[Param objectForKey:@"message2"]], DeviceId];
        NSLog(@"%@", url);
        
       // NSURL* Stringurl = [NSURL URLWithString:url];
        
      //  NSData *returnData = [[NSData alloc] initWithContentsOfURL:Stringurl options:nil error:nil];
        
        
        NSData *imageData = (NSData *)[Param objectForKey:@"AttachtedImage"];
        
        NSLog(@"attached image ---- %@",[Param objectForKey:@"AttachtedImage"]);
        NSData *returnData = nil;
        if(imageData > 0) {
            
            NSData *imageData = imageData;
            // setting up the URL to post to
            NSString *urlString = url;
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Disposition: form-data; name=\"image_upload\"; filename=\"sampleImage.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:[Param objectForKey:@"AttachtedImage"]]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            // now lets make the connection to the web
            returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
           
//            
//            
//            
//            
//            
//            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//            [request setURL:[NSURL URLWithString:url]];
//            [request setHTTPMethod:@"POST"];
//            NSLog(@"the data formetnotupdate Successfully");
//            NSString *boundary = @"---------------------------14737809831466499882746641449";
//            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//            
//            NSMutableData *body = [NSMutableData data];
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_upload\"; filename=\"sampleImage.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[NSData dataWithData:imageData]];
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [request setHTTPBody:body];
//            returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        } else {
            NSURL* Stringurl = [NSURL URLWithString:url];
            returnData = [[NSData alloc] initWithContentsOfURL:Stringurl options:nil error:nil];
        }
       
        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//        [request setHTTPShouldHandleCookies:NO];
//        [request setURL:requestURL];
//        [request setTimeoutInterval:30];
//        [request setHTTPMethod:@"POST"];
//        NSURLResponse *response = nil;
//        NSError *error;
//        
//        NSData *tempimg=(NSData *)[Param objectForKey:@"AttachtedImage"];
//        
//        if(tempimg)
//        {
//            NSString *boundary = [NSString stringWithFormat:@"%0.9u",arc4random()];
//            
//            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//            
//            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//            
//            
//            
//            NSMutableData *body = [NSMutableData data];
//            
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_upload\"; filename=\"sampleImage.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            [body appendData:[NSData dataWithData:tempimg]];
//            
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            [request setHTTPBody:body];
//        }
//        
//      NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"ReturnString: %@", returnString);
        if([returnString isEqualToString:@"Success"])
        {
            [self performSelectorOnMainThread:@selector(CardHasSent) withObject:nil waitUntilDone:NO];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSUserDefaults *UserDefaults=[[NSUserDefaults alloc] init];
                
                int NewCredit=(int)[UserDefaults integerForKey:SESSION_USERCREDITS];
                NewCredit-=1;
                
                [UserDefaults setInteger:NewCredit forKey:SESSION_USERCREDITS];
                [UserDefaults synchronize];
                
                NSString *URL=[NSString stringWithFormat:@"%@userCredits_V2.php?objectType=set&TotalCredit=%d&deviceId=%@", API, NewCredit, DeviceId];
                NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Fire:) object:URL];
                [OperationQueueForEmail addOperation:Operation];
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"It's embarrassing, but we failed to sent your card. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            });
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self PerformGoBackTo:@"CategoryView"];
    }
}

@end
