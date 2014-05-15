//
//  GlobalMethod.m
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "GlobalMethod.h"

@implementation GlobalMethod

@synthesize Id, Name, ImageUrl, CardImage, Tagger, Counter, UserName, Identifier, CardId, CardImageURL, AttachedImage, Message1, Message2, ScheduledDate, Message, SenderName, ReceiverName, Description, ReceiverPhoneNo, Credit, CreditDate, PackageType, FontSize, FontStyle, FontColor,ScheduleID,ParamCancelStatus;

-(id) initWithId:(NSString *)ParamId withName:(NSString *)ParamName
{
    if(self=[super init])
    {
        [self setName:ParamName];
        [self setId:ParamId];
        [self setTagger:[ParamId integerValue]];
    }
    return self;
}

-(id)initWithId:(NSString *)ParamId withName:(NSString *)ParamName withDescription:(NSString *)ParamDescription
{
    self=[super init];
    if(self)
    {
        [self setName:ParamName];
        [self setId:ParamId];
        [self setDescription:ParamDescription];
    }
    return  self;
}

-(id) initWithId:(NSString *)ParamId withImageUrl:(NSString *)ParamUrl
{
    if(self=[super init])
    {
        [self setId:ParamId];
        [self setImageUrl:[NSURL URLWithString:ParamUrl]];
        [self setTagger:[ParamId integerValue]];
    }
    return  self;
}

-(id)initWithId:(NSString *)ParamId withImageUrl:(NSString *)ParamUrl withCardName:(NSString *)ParamName withCounter:(NSUInteger)ParamCounter
{
    if(self=[super init])
    {
        [self setId:ParamId];
        [self setImageUrl:[NSURL URLWithString:ParamUrl]];
        [self setTagger:[ParamId integerValue]];
        [self setName:ParamName];
        [self setCounter:ParamCounter];
    }
    return  self;
}


-(NSString *) Encoder:(NSString *)str
{
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [trimmedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


-(NSData *)ConvertImageToNSData:(UIImage *)image
{
    return UIImageJPEGRepresentation(image, 1.0);
}

-(NSURL *)ConvertStringToNSUrl:(NSString *)String
{
    return [NSURL URLWithString:String];
}

-(NSString *)ConvertNSDataToNSString:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    @try
    {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }
    @catch (NSException *juju)
    {
        NSLog(@"Reporting juju from colorFromHexString: %@ ", juju);        
    }
    @finally
    {
        return [UIColor blackColor];
    }
}

-(id)initWithId:(NSString *)ParamId withName:(NSString *)ParamName withImageUrl:(NSString *)ParamImageUrl  withUserName:(NSString *)Paramusername
{
    if(self = [super init])
    {
        [self setId:ParamId];
        [self setImageUrl:[self ConvertStringToNSUrl:ParamImageUrl]];
        [self setName:ParamName];
        [self setUserName:Paramusername];
    }
    return self;
}



-(id)initWithId:(NSString *)ParamId withName:(NSString *)ParamName withImageUrl:(NSURL *)ParamImageUrl withIdentifier:(NSUInteger)ParamIdendifier withUserName:(NSString *)Paramusername
{
    if(self = [super init])
    {
        [self setId:ParamId];
        [self setIdentifier:ParamIdendifier];
        [self setImageUrl:ParamImageUrl];
        [self setName:ParamName];
        [self setUserName:Paramusername];
    }
    return self;
}




-(id)initWithId:(NSString *)ParamCardId withMessage1:(NSString *)ParamMessage1 withMessage2:(NSString *)ParamMessage2 withDate:(NSString *)ParamScheduledDate withCardImage:(NSString *)ParamCardImage withAttachedImage:(NSString *)ParamAttachedImage withSenderName:(NSString *)ParamSenderName withReceiverName:(NSString *)ParamReceiverName withReceiverPhoneNo:(NSString *)ParamReceiverPhoneNo withScheduleID:(NSString *)ParamScheduleID withCancelStatus:(NSString *)ParamCancelStatusone
{
    
    if(self = [super init])
    {
        [self setCardId:ParamCardId];
        [self setCardImageURL:[NSURL URLWithString:ParamCardImage]];
        [self setAttachedImage:([ParamAttachedImage length]>0)?[NSURL URLWithString:ParamAttachedImage]:nil];
        [self setMessage:[NSString stringWithFormat:@"%@\n%@", ([ParamMessage1 isEqualToString:@"Choose Your Message"])?@"":ParamMessage1, ([ParamMessage2 isEqualToString:@"Write Your Message"])?@"":ParamMessage2]];
        [self setMessage1:ParamMessage1];
        [self setMessage2:ParamMessage2];
        [self setScheduledDate:ParamScheduledDate];
        [self setSenderName:([ParamSenderName length]>0)?[NSString stringWithFormat:@"-%@", ParamSenderName]:@""];
        [self setReceiverName:([ParamReceiverName length]>0)? [NSString stringWithFormat:@"%@,", ParamReceiverName]:[NSString stringWithFormat:@"%@,", ParamReceiverPhoneNo]];
        [self setScheduleID:ParamScheduleID];
        [self setParamCancelStatus:ParamCancelStatusone];
    }
    return self;
}




-(id)initWithId:(NSString *)ParamId withCredit:(NSString *)ParamCredit withCreditDate:(NSString *)ParamCreditDate withPackageType:(NSString *)ParamPackageType
{
    self=[super init];
    if(self)
    {
        [self setId:ParamId];
        [self setCredit:ParamCredit];
        [self setCreditDate:ParamCreditDate];
        [self setPackageType:[NSString stringWithFormat:@"%@ cards package", ParamPackageType]];
    }
    return  self;
}


@end
#import "AppDelegate.h"

@implementation UpdateUserAppaccessCount

-(int)GetUserVisitcounter:(NSString *)DeviceToken {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSString *url=[NSString stringWithFormat:@"%@user_app_visit_V2.php?deviceId=%@", API, DeviceToken];
        NSError *error;
        NSString *Totalcounter = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //if ([Totalcounter intValue] == 5) {
                AppDelegate *Maindelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                ViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maindelegate.window.frame.size.width, Maindelegate.window.frame.size.height)];
                [ViewOne setBackgroundColor:[UIColor clearColor]];
                MyView = [[[NSBundle mainBundle] loadNibNamed:@"RateUs" owner:self options:nil] objectAtIndex:0];
                UILabel *LblTopTitile = (UILabel *)[MyView viewWithTag:11];
                [LblTopTitile setBackgroundColor:[UIColor clearColor]];
                [LblTopTitile setTextAlignment:NSTextAlignmentCenter];
                [LblTopTitile setFont:[UIFont fontWithName:@"papyrus" size:22.0f]];
                [LblTopTitile setTextColor:UIColorFromRGB(0x0571af) ];
                [LblTopTitile setShadowColor:UIColorFromRGB(0xb8ddf2)];
            
                UIButton *cancelButton = (UIButton *)[MyView viewWithTag:77];
                [cancelButton addTarget:self action:@selector(CancelRateview) forControlEvents:UIControlEventTouchUpInside];
            
                UIButton *OkButton = (UIButton *)[MyView viewWithTag:88];
                [OkButton addTarget:self action:@selector(OkRateview) forControlEvents:UIControlEventTouchUpInside];
            
                [MyView setFrame:CGRectMake(0, 0, Maindelegate.window.frame.size.width, Maindelegate.window.frame.size.height)];
                [ViewOne addSubview:MyView];
                [Maindelegate.window addSubview:ViewOne];
//            } else {
//                NSLog(@"my value is %@",Totalcounter);
//            }
        });
    
    });
}

-(void)CancelRateview {
    NSLog(@"---------i am in cancel");
    [ViewOne removeFromSuperview];
}
-(void)OkRateview {
    NSLog(@"---------i am in ok");
    [MyView removeFromSuperview];
     AppDelegate *Maindelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 50, Maindelegate.window.frame.size.width, Maindelegate.window.frame.size.height-100)];
    NSString *url=@"http://www.google.com";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [ViewOne addSubview:webview];
}
@end
