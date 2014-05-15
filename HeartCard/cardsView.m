//
//  cardsView.m
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import "cardsView.h"
#import "SendView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
@interface cardsView ()
{
    NSMutableArray *CardContainerArray;
    
    NSOperationQueue *OperationQueueForCards;
    
    GlobalMethod *Method;
    
    //UIView *OverLayView, *CardBackView, *AnimationView, *CardBackLayer1, *CardBackLayer2, *CardBackLayer3, *CardBackLayer4, *PopupBackView, *AnimationBackView, *BottomBarView, *TipsView;
    
    UIView *TipsView, *AnimationBackView ,*BottomBarView, *CardLayer1, *CardLayer2, *CardLayer3, *CardLayer4, *fromNib1, *AnimationMainBackView, *PopupBackView;
    
    UIScrollView *AnimationView;
    
    UIImageView *CardFontImageView, *AttachedImageView;
    
    BOOL IsCardFontOpen,  IsCardBackOpen, PerformNextStep;
    NSData *CardData;
    
    UIPopoverController *popoverController;
    BOOL newMedia, IsFavourite, IsNoneSelected;
    
    UIButton *BtnAttached;
    
    UITextView *TVChooseMessage, *TVWriteMessage, *CustomMessageView;
    
    NSString *StaticMessage1, *StaticMessage2, *StaticMessage3, *UniqueCardIdN;
    
    int CurrentStep;
    
    CGRect InitialRect, InitailRect1;
    UILabel *LblCreditsLine1, *LblChooseAndPersonalize, *LblAttachAnImage;
}

@end

@implementation cardsView

@synthesize ScreenViewCards, SVCards, CardId, CardName, Spinner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self=(IsIphone5)?[super initWithNibName:@"cardsViewBig" bundle:nil]:[super initWithNibName:@"cardsView" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self PrepareScreens];
    
    NSInvocationOperation *Operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(FetchCards) object:nil];
    [OperationQueueForCards addOperation:Operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)PrepareScreens
{
    [self SetBackground:ScreenViewCards];
    [self AddTopBarToScreenView:ScreenViewCards withTitle:CardName WithFavIcon:YES];
    [self AddButtonBarToScreenView:ScreenViewCards];
    CardContainerArray = [[NSMutableArray alloc] init];
    OperationQueueForCards=[[NSOperationQueue alloc] init];
    
    IsCardFontOpen=FALSE;
    IsCardBackOpen=TRUE;
    newMedia=FALSE;
    PerformNextStep=FALSE;
    IsNoneSelected=FALSE;
    
    
    CurrentStep=1;
    
}

-(void)goBack
{
    [self RemoveAllGestureFrom:ScreenViewCards];
    [self PerformGoBackTo:@"CategoryView"];
}


-(void)CancelAnimation
{
//    IsCardFontOpen=FALSE;
//    IsCardBackOpen=TRUE;
//    newMedia=TRUE;
//    PerformNextStep=FALSE;
//    [AnimationBackView removeFromSuperview];
    
    UIAlertView *AlertCancel = [[UIAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure you want to cancel creating this card?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [AlertCancel setTag:190];
    [AlertCancel show];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 190) {
//        if (buttonIndex == 1) {
//            IsCardFontOpen=FALSE;
//            IsCardBackOpen=TRUE;
//            newMedia=TRUE;
//            PerformNextStep=FALSE;
//            [AnimationBackView removeFromSuperview];
//
//        }
//    }
//}

-(void)closeTips
{
    [TipsView removeFromSuperview];
}


-(void)sendNow
{
    IsCardFontOpen=FALSE;
    IsCardBackOpen=TRUE;
    newMedia=FALSE;
    PerformNextStep=FALSE;
    
    [AnimationBackView removeFromSuperview];
    AnimationView=nil;
    
    SendView *SendViewNib=[[SendView alloc] init];
    [SendViewNib setParamUploadedImage:[Method ConvertImageToNSData:[AttachedImageView image]]];
    [SendViewNib setParamChooseMsg:(IsNoneSelected)?@"":[TVChooseMessage text]];
    [SendViewNib setParamCustomMsg:[[TVWriteMessage text] isEqualToString:@"Write Your Message"]?@"":[TVWriteMessage text]];
    [SendViewNib setUniqueCardId:UniqueCardIdN];
    [[self navigationController] pushViewController:SendViewNib animated:YES];
    
}


-(void)OpenImageUploadOptions
{
    NSLog(@"OpenImageUploadOptions");
    NSString *actionSheetTitle = @"Choose an option"; //Action Sheet Title
    NSString *destructiveTitle = @"Cancel"; //Action Sheet Button Titles
    NSString *other1 = @"Use Camera";
    NSString *other2 = @"User Camera Roll";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:destructiveTitle
													otherButtonTitles:other1, other2, nil];
    
    CGRect actionRect = [self.view convertRect:[AttachedImageView frame]  fromView:[AttachedImageView superview]];
    [actionSheet showFromRect:actionRect inView:self.view animated:YES];
}

#pragma marks Thread Segments

-(void)getMessage:(NSString *)PCardId
{
    @try
    {
        NSString *URL=[NSString stringWithFormat:@"%@card_message.php?id=%@", API, PCardId];
        NSLog(@"%@", URL);
        NSError *JsonError;
        NSData *Data=[NSData dataWithContentsOfURL:[Method ConvertStringToNSUrl:URL]];
        NSArray *OutputArray=[NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&JsonError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            StaticMessage1=[OutputArray valueForKey:@"message1"];
            StaticMessage2=[OutputArray valueForKey:@"message2"];
            StaticMessage3=[OutputArray valueForKey:@"message3"];
            [LblCreditsLine1 setText:[OutputArray valueForKey:@"credits"]];
        });
    }
    @catch (NSException *juju)
    {
        //Play with your little juju.
        NSLog(@"Reporting juju :: %@", juju);
    }
}

-(void) FetchCards
{
    @try
    {
        NSString *url=[NSString stringWithFormat:@"%@cards_V2.php?id=%@", API, CardId];
        NSLog(@"%@", url);
        NSData *getData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        if([getData length]>2)
        {
            NSArray *getArray=[NSJSONSerialization JSONObjectWithData:getData options:kNilOptions error:nil];
            
            
            for(NSDictionary *var in getArray)
            {
                [CardContainerArray addObject:[[GlobalMethod alloc] initWithId:[var objectForKey:@"id"] withImageUrl:[var objectForKey:@"cardUrl"]]];
            }
            
            [self performSelectorOnMainThread:@selector(gotCards) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(HandleError) withObject:nil waitUntilDone:YES];
        }
        
    }
    @catch(NSException *excepiton)
    {
        //Play with your cute & beautiful exception.
    }
    
}

-(void) DownloadImage:(NSArray *)ParamArray //0.ImageView 1.ImageUrl 2.Spinner
{
    @try
    {
        //NSString *ImageUrl=[NSString stringWithFormat:@"%@",[ParamArray objectAtIndex:1]];
        
        //NSLog(@"ImageUrl --- %@",ImageUrl);
        
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ImageUrl]];
//        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
//        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSMutableArray *ObjectCarrier=[[NSMutableArray alloc] initWithObjects: [ParamArray objectAtIndex:0], responseObject, [ParamArray objectAtIndex:2], nil];
//            [self performSelectorOnMainThread:@selector(FinishImageLoading:) withObject:ObjectCarrier waitUntilDone:NO];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Image error: %@", error);
//        }];
//        [requestOperation start];
        
        UIImage *TempCardImage;
        
        NSString *ImageUrl=[NSString stringWithFormat:@"%@",[ParamArray objectAtIndex:1]];
        NSLog(@"ImageUrl ------ %@",ImageUrl);
        NSData *ImageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:ImageUrl]];
        
        TempCardImage=[UIImage imageWithData:ImageData];
        
        
        NSMutableArray *ObjectCarrier=[[NSMutableArray alloc] initWithObjects: [ParamArray objectAtIndex:0], TempCardImage, [ParamArray objectAtIndex:2], nil];
        [self performSelectorOnMainThread:@selector(FinishImageLoading:) withObject:ObjectCarrier waitUntilDone:NO];
    }
    @catch (NSException *exception)
    {
        //Play with your cute & beautiful exception.
    }
}


-(void)PerformFavOperation
{
    @try
    {
        NSString *action=(IsFavourite)?@"fav":@"unfav";
        NSString *URL=[NSString stringWithFormat:@"%@favorite.php?id=%@&deviceId=%@&action=%@", API, UniqueCardIdN, DeviceId, action];
        NSLog(@"%@", URL);
        [NSData dataWithContentsOfURL:[Method ConvertStringToNSUrl:URL]];
        
        if([action isEqualToString:@"fav"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *showAlert=[[UIAlertView alloc] initWithTitle:@"A Favorite!" message:@"You have successfully added this card to your Collection of Favorites." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *showAlert=[[UIAlertView alloc] initWithTitle:@"Removed!" message:@"This card will be removed from your Favorites Collection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [showAlert show];
            });
        }
    }
    @catch (NSException *juju)
    {
        //Play with your little juju.
        NSLog(@"Reporting juju :: %@", juju);
    }
}

-(void)IsFav
{
    @try
    {
        NSString *URL=[NSString stringWithFormat:@"%@favorite.php?id=%@&deviceId=%@", API, UniqueCardIdN, DeviceId];
        NSLog(@"%@", URL);
        NSData *Data=[NSData dataWithContentsOfURL:[Method ConvertStringToNSUrl:URL]];
        NSString *OutPutString=[Method ConvertNSDataToNSString:Data];
        
        if([OutPutString isEqualToString:@"fav"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                IsFavourite=TRUE;
                //[FavButton setImage:[UIImage imageNamed:@"heart-red.png"] forState:UIControlStateNormal];
                [self AdjustSizeWithFav:IsFavourite];
            });
        }
    }
    @catch (NSException *juju)
    {
        //Play with your little juju.
        NSLog(@"Reporting juju :: %@", juju);
    }
}

#pragma mark for Main Thread Segments


-(void) FinishImageLoading :(NSArray *) ParamArray //0.ImageView 1.Image 2.Spinner
{
    @try
    {
        //NSLog(@"------- %@",[ParamArray objectAtIndex:1]);
        UIImageView *CardImage=(UIImageView *)[ParamArray objectAtIndex:0];
        [CardImage setImage:(UIImage *)[ParamArray objectAtIndex:1]];
        [CardImage setContentMode:UIViewContentModeScaleToFill];
        UIActivityIndicatorView *TempSpinner=(UIActivityIndicatorView *)[ParamArray objectAtIndex:2];
        [TempSpinner stopAnimating];
        [CardImage setUserInteractionEnabled:YES];
    }
    @catch (NSException *exception)
    {
        //play with your exception.
    }
}

-(void)HandleError
{
    UIAlertView *showError=[[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"No Card found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [showError setTag:14];
    [showError show];
}


-(void)gotCards
{
    @try
    {
        [[self Spinner] stopAnimating];
        unsigned CardContenerLength=[CardContainerArray count];
        float widthSize;
        
        CGRect CardLoaderViewRect, ImageViewRect;
        if(IsIphone5)
        {
            CardLoaderViewRect.size.width=250.0f;
            CardLoaderViewRect.size.height=320.0f;
            CardLoaderViewRect.origin.y=50.0f;
            
            ImageViewRect.origin.x=0.0f;
            ImageViewRect.origin.y=0.0f;
            ImageViewRect.size.width=250.0f;
            ImageViewRect.size.height=310.0f;
            
            widthSize=10.0f;
        }
        else
        {
            CardLoaderViewRect.size.width=230.0f;
            CardLoaderViewRect.size.height=300.0f;
            CardLoaderViewRect.origin.y=20.0f;
            
            ImageViewRect.origin.x=0.0f;
            ImageViewRect.origin.y=0.0f;
            ImageViewRect.size.width=230.0f;
            ImageViewRect.size.height=290.0f;
            
            widthSize=30.0f;
        }
        
        for(unsigned i=0; i<CardContenerLength; i++)
        {
            Method=[CardContainerArray objectAtIndex:i];
            
            CardLoaderViewRect.origin.x=(IsIphone5)?widthSize:widthSize-20;
            
            UIView *CardLoaderView=[[UIView alloc] initWithFrame:CardLoaderViewRect];
            
            [self SetBackground:CardLoaderView :@"card-bg.png"];
            [[self SVCards] addSubview:CardLoaderView];
            
            UIImageView *CardImageView=[[UIImageView alloc] initWithFrame:ImageViewRect];
            TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CardHasTouched:)];
            [TapGesture setDelegate:self];
            [CardImageView setTag:[Method Tagger]];
            [CardImageView addGestureRecognizer:TapGesture];
            [CardLoaderView addSubview:CardImageView];
            
            CGRect SpinnerRect=CGRectMake((CardImageView.frame.size.width/2), (CardImageView.frame.size.height/2), 20, 20);
            UIActivityIndicatorView *SpinnerForLodingImage=[[UIActivityIndicatorView alloc] initWithFrame:SpinnerRect];
            [SpinnerForLodingImage startAnimating];
            [SpinnerForLodingImage hidesWhenStopped];
            [SpinnerForLodingImage setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [SpinnerForLodingImage setColor:[UIColor grayColor]];
            [SpinnerForLodingImage setTag:123];
            [CardImageView addSubview:SpinnerForLodingImage];
            
            NSArray *ObjectCarrier=[[NSArray alloc] initWithObjects:CardImageView, [Method ImageUrl], SpinnerForLodingImage,  nil];
           
            //[self LoadImage:ObjectCarrier];
            NSInvocationOperation *DownloadImageOperation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(DownloadImage:) object:ObjectCarrier];
            [OperationQueueForCards addOperation:DownloadImageOperation];
            
            widthSize+=(IsIphone5)?260.0f:240.0f;
        }
        
        self.SVCards.contentSize = CGSizeMake(widthSize, 1);
        [[self SVCards] setShowsHorizontalScrollIndicator:NO];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@", exception);
    }
}

-(void) CardHasTouched:(UITapGestureRecognizer *)Recognizer
{
    NSLog(@"CardHasTouched");
    //TipsView=[[[NSBundle mainBundle] loadNibNamed:@"AnimationView" owner:self options:nil] objectAtIndex:4];
    
    IsFavourite=FALSE;
    
    UIImageView *TouchedImageView;
    TouchedImageView=(UIImageView *)Recognizer.view;
    CardData=UIImageJPEGRepresentation([TouchedImageView image], 1.0f);
    
    UniqueCardIdN=[NSString stringWithFormat:@"%d", [TouchedImageView tag]];
    
    NSInvocationOperation *operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getMessage:) object:UniqueCardIdN];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [OperationQueueForCards addOperation:operation];
    
    NSInvocationOperation *OperationFav=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(IsFav) object:nil];
    [OperationQueueForCards addOperation:OperationFav];
    
    CGRect AnimationViewRect=[ScreenViewCards frame];
    AnimationBackView=[[UIView alloc] initWithFrame:AnimationViewRect];
    [AnimationBackView setBackgroundColor:[UIColor clearColor]];
    
    [ScreenViewCards addSubview:AnimationBackView];
    
    AnimationView=[[UIScrollView alloc] initWithFrame:AnimationViewRect];
    [AnimationView setBackgroundColor:[UIColor clearColor]];
    [AnimationBackView addSubview:AnimationView];
    
    [UIView animateWithDuration:0.50f animations:^{
        
        [AnimationBackView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
        
    } completion:^(BOOL finished) {
        
//        [AnimationBackView addSubview:TipsView];
//        [AnimationBackView bringSubviewToFront:TipsView];
//        [TipsView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
        

    }];
    
//    UIButton *BtnCloseTips=(UIButton *)[TipsView viewWithTag:1];
//    [BtnCloseTips addTarget:self action:@selector(closeTips) forControlEvents:UIControlEventTouchUpInside];
    
    PanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeTips)];
    [PanGesture setMaximumNumberOfTouches:1];
    [PanGesture setDelegate:self];
    [TipsView addGestureRecognizer:PanGesture];
    
    if(IsIphone5)
    {
       fromNib1 =[[[NSBundle mainBundle] loadNibNamed:@"ExtendedAnimationView" owner:self options:nil] objectAtIndex:1];
    }
    else
    {
        fromNib1 =[[[NSBundle mainBundle] loadNibNamed:@"ExtendedAnimationView" owner:self options:nil] objectAtIndex:0];
    }
    
    [AnimationView addSubview:fromNib1];
    [AnimationView setBounces:NO];
    
    AnimationMainBackView=(UIView *)[fromNib1 viewWithTag:20];
    InitialRect=[AnimationMainBackView frame];
    
    CardLayer3=(UIView *)[AnimationMainBackView viewWithTag:1];
    CardLayer1=(UIView *)[AnimationMainBackView viewWithTag:2];
    CardLayer2=(UIView *)[AnimationMainBackView viewWithTag:3];
    CardLayer4=(UIView *)[AnimationMainBackView viewWithTag:30];
    
    [CardLayer2 setAlpha:0.0f];
    [CardLayer4 setAlpha:0.0f];
    
    LblCreditsLine1=(UILabel *)[CardLayer4 viewWithTag:88];
    UILabel *LblCreditsLine2=(UILabel *)[CardLayer4 viewWithTag:89];
    UILabel *LblCreditsLine3=(UILabel *)[CardLayer4 viewWithTag:90];
    
    [self SetFontToLabels:[NSArray arrayWithObjects:LblCreditsLine1, LblCreditsLine2, LblCreditsLine3, nil] withSize:7.0f];
    
    
    CardFontImageView=(UIImageView *)[CardLayer1 viewWithTag:8];
    [CardFontImageView setImage:[TouchedImageView image]];
    [CardFontImageView setUserInteractionEnabled:YES];
    PanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeToOpen:)];
    [PanGesture setMaximumNumberOfTouches:1];
    [PanGesture setDelegate:self];
    [CardFontImageView addGestureRecognizer:PanGesture];
    
    [CardLayer3 setUserInteractionEnabled:YES];
    PanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeToCloseCard:)];
    [PanGesture setMaximumNumberOfTouches:1];
    [PanGesture setDelegate:self];
    [CardLayer3 addGestureRecognizer:PanGesture];
    
    AttachedImageView =[[UIImageView alloc] initWithFrame:CGRectMake(52.0f, 74.0f, 180.0f, 218.0f)];
    [AttachedImageView setContentMode:UIViewContentModeScaleAspectFit];
    [CardLayer2 addSubview:AttachedImageView];
    
    PanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeToOpen:)];
    [PanGesture setMaximumNumberOfTouches:1];
    [PanGesture setDelegate:self];
    [AttachedImageView addGestureRecognizer:PanGesture];
    
    UIImageView *Layer3ImageView=(UIImageView *)[CardLayer2 viewWithTag:8];
    [Layer3ImageView setUserInteractionEnabled:YES];
    
    PanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeToCloseCard:)];
    [PanGesture setMaximumNumberOfTouches:1];
    [PanGesture setDelegate:self];
    [Layer3ImageView addGestureRecognizer:PanGesture];
            
    
    TVChooseMessage=(UITextView *)[CardLayer3 viewWithTag:1];
    TVWriteMessage=(UITextView *)[CardLayer3 viewWithTag:2];
    LblChooseAndPersonalize=(UILabel *)[CardLayer3 viewWithTag:7];
    [LblChooseAndPersonalize setHidden:YES];
    
    
    TVChooseMessage=(UITextView *)[CardLayer3 viewWithTag:5];
    TVWriteMessage=(UITextView *)[CardLayer3 viewWithTag:6];
    [TVWriteMessage setTextColor:UIColorFromRGB(0xB49E63)];
    
    [TVChooseMessage setDelegate:self];
    [TVWriteMessage setDelegate:self];
    [TVChooseMessage setEditable:NO];
    [TVWriteMessage setEditable:NO];
    [TVWriteMessage setFont:[UIFont fontWithName:@"Segoe Script" size:16.0f]];
    [TVChooseMessage setFont:[UIFont fontWithName:@"Vollkorn-Regular" size:16.0f]];
    [TVChooseMessage setTextColor:UIColorFromRGB(0x776948)];
    
    UILabel *staticLabel=(UILabel *)[CardLayer3 viewWithTag:7];
    [self SetFontToLabel:staticLabel withSize:17.0f];
    
//    NSArray *Fields=[[NSArray alloc] initWithObjects:TVChooseMessage, nil];
//    [self SetFonttoFields:Fields withSize:18.0f];
    
    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenCustomMessageEditor)];
    [TapGesture setDelegate:self];
    [TVWriteMessage addGestureRecognizer:TapGesture];
    
    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenMessageSelector)];
    [TapGesture setDelegate:self];
    [TVChooseMessage addGestureRecognizer:TapGesture];
    
    
    UIImageView *Layer2ImageView=(UIImageView *)[CardLayer2 viewWithTag:8];
    [Layer2ImageView setUserInteractionEnabled:YES];
    
    PanGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeToClose:)];
    [PanGesture setMaximumNumberOfTouches:1];
    [PanGesture setDelegate:self];
    [Layer2ImageView addGestureRecognizer:PanGesture];
    
    LblAttachAnImage=(UILabel *)[CardLayer2 viewWithTag:10];
    [self SetFontToLabel:LblAttachAnImage withSize:17.0f];
    
    BtnAttached=(UIButton *)[CardLayer2 viewWithTag:9];
    [BtnAttached setUserInteractionEnabled:YES];
    [BtnAttached addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    
    float FromTopForMain=(IsIphone5)?483.0f:395.0f;
    FromTopForMain+=50.0f;
    CGRect BottombarRect=CGRectMake(0.0f, FromTopForMain, 320.0f, 85.0f);
    
    float FormTop=40.0f;
    
    BottomBarView=[[UIView alloc] initWithFrame:BottombarRect];
    [BottomBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom-bar.png"]]];
    [AnimationBackView addSubview:BottomBarView];
    
    CGRect Button1Rect, FavButtonRect, Button2Rect;
    
    Button1Rect=CGRectMake(34.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button1=[[UIButton alloc] initWithFrame:Button1Rect];
    [Button1 setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [Button1 addTarget:self action:@selector(CancelAnimation) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button1];
    
    FavButtonRect=CGRectMake(140.0f, FormTop+5.0f, 34.0f, 29.0f);
    FavButton=[[UIButton alloc] initWithFrame:FavButtonRect];
    [FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    
    [FavButton addTarget:self action:@selector(PerformFav) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:FavButton];
    
    Button2Rect=CGRectMake(214.0f, FormTop, 72.0f, 36.0f);
    UIButton *Button2=[[UIButton alloc] initWithFrame:Button2Rect];
    [Button2 setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [Button2 addTarget:self action:@selector(sendNow) forControlEvents:UIControlEventTouchUpInside];
    [BottomBarView addSubview:Button2];
    
    [UIView animateWithDuration:0.6f delay:0.4f options:UIViewAnimationCurveEaseInOut animations:^{
        
        CGRect tempRect=[BottomBarView frame];
        tempRect.origin.y-=50.0f;
        [BottomBarView setFrame:tempRect];
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void)Click
{
    [self OpenImageUploadOptions];
}


-(void)PerformFav
{
    NSInvocationOperation *DoOrUndo=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(PerformFavOperation) object:nil];
    [OperationQueueForCards addOperation:DoOrUndo];
    
    if(IsFavourite)
    {
        IsFavourite=FALSE;
        //[FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    }
    else
    {
        IsFavourite=TRUE;
        //[FavButton setImage:[UIImage imageNamed:@"heart-red.png"] forState:UIControlStateNormal];
        [self ShowAnimation];
    }
    [self AdjustSizeWithFav:IsFavourite];
}


-(void)ShowAnimation
{
    UIImageView *FavImage=[[UIImageView alloc] initWithFrame:[FavButton frame]];
    [FavImage setImage:[UIImage imageNamed:@"heart-red.png"]];
    [BottomBarView addSubview:FavImage];
    
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


-(void)AdjustSizeWithFav:(BOOL)IsFav
{
    if(IsFav)
    {
        CGRect TempRect=CGRectMake(133.0f, 37.0f, 49.0f, 45.0f);
        [FavButton setFrame:TempRect];
        [FavButton setImage:[UIImage imageNamed:@"heart-fav.png"] forState:UIControlStateNormal];
    }
    else
    {
        CGRect TempRect=CGRectMake(140.0f, 44.0f, 34.0f, 29.0f);
        [FavButton setFrame:TempRect];
        [FavButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal]; 
    }
}


-(void)SwipeToOpen:(UIPanGestureRecognizer *)Recognizer
{
    CGPoint translation = [Recognizer translationInView:Recognizer.view];

    if(translation.x<0.00f)
    {
        if([Recognizer state]==UIGestureRecognizerStateBegan)
        {
            if(!IsCardBackOpen)
            {
                [self OpenCardBack];
            }
            else if(!IsCardFontOpen)
            {
                [self OpenCard];
            }
        }
    }
}


-(void)SwipeToCloseCard:(UIPanGestureRecognizer *)Recognizer
{
    CGPoint translation = [Recognizer translationInView:Recognizer.view];
    if(translation.x<0.00f)
    {
        if([Recognizer state]==UIGestureRecognizerStateBegan)
        {
            if(IsCardBackOpen)
            {
                [self CloseCardBack];
            }
        }
    }
    else if([Recognizer state]==UIGestureRecognizerStateBegan && !PerformNextStep)
    {
        [self ScrollToScreen1];
    }
}


-(void)SwipeToClose:(UIPanGestureRecognizer *)Recognizer
{
    CGPoint translation = [Recognizer translationInView:Recognizer.view];
    
    if(translation.x>0.00f)
    {
        if([Recognizer state]==UIGestureRecognizerStateBegan)
        {
            if(!IsCardBackOpen)
            {
                [self OpenCardBack];
            }
            else if(IsCardFontOpen)
            {
                [self CloseCard];
            }
        }
    }
    else if([Recognizer state]==UIGestureRecognizerStateBegan && !PerformNextStep)
    {
        [self ScrollToScreen2];
    }
}


-(void)ScrollToScreen2
{
    [UIView animateWithDuration:0.35f animations:^{
        
        CGRect frm=[AnimationMainBackView frame];
        frm.origin.x-=290.0f;
        [AnimationMainBackView setFrame:frm];
    }];
}

-(void)ScrollToScreen1
{
    [UIView animateWithDuration:0.35f animations:^{
        
        CGRect frm=[AnimationMainBackView frame];
        frm.origin.x+=290.0f;
        [AnimationMainBackView setFrame:frm];
    }];
}

-(void)OpenCard
{
    IsCardFontOpen=TRUE;
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    __block CATransform3D _3Dt = CATransform3DIdentity;
    _3Dt = CATransform3DMakeRotation(3.141f/2.0f,0.0f,-1.0f,0.0f);
    _3Dt.m34 = 0.001f;
    _3Dt.m14 = -0.0015f;
    CardLayer1.layer.transform =_3Dt;
    [CATransaction commit];
    
    CardLayer1.layer.anchorPoint=CGPointMake(0, .5);    
    if(CardLayer1.center.x!=286.0f)
    {
        CardLayer1.center = CGPointMake(CardLayer1.center.x - CardLayer1.bounds.size.width/2.0f, CardLayer1.center.y);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:0.1];
    CardLayer1.transform = CGAffineTransformMakeTranslation(0,0);
    _3Dt = CATransform3DMakeRotation(1.64f,0.0f,-1.0f,0.0f);
    _3Dt.m34 = 0.001f;
    _3Dt.m14 = -0.0015f;
    
    CardLayer1.layer.transform =_3Dt;
    
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:0.95];
    
    
    CGRect frm=[AnimationMainBackView frame];
    frm.origin.x+=290.0f;
    [AnimationMainBackView setFrame:frm];
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.95];
    
    [CardLayer2 setAlpha:1.0f];
    [CardLayer1 setAlpha:0.0f];
    
    [UIView commitAnimations];
    
    
    [AnimationView setShowsHorizontalScrollIndicator:NO];
    [AnimationView setShowsVerticalScrollIndicator:NO];
    [AnimationView setPagingEnabled:YES];
}



-(void)CloseCardBack
{
    InitailRect1=[AnimationView frame];
    
    IsCardBackOpen=FALSE;
    PerformNextStep=TRUE;
    
    [AnimationView bringSubviewToFront:CardLayer4];
    [[CardLayer4 layer] setZPosition:1.0f];
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    __block CATransform3D _3Dt = CATransform3DIdentity;
    _3Dt = CATransform3DMakeRotation(3.141f/2.0f,0.0f,-1.0f,0.0f);
    _3Dt.m34 = 0.001f;
    _3Dt.m14 = -0.0015f;
    CardLayer3.layer.transform =_3Dt;
    [CATransaction commit];
    
    CardLayer3.layer.anchorPoint=CGPointMake(0, .5);
    if(CardLayer3.center.x!=286.0f)
    {
        CardLayer3.center = CGPointMake(CardLayer3.center.x - CardLayer3.bounds.size.width/2.0f, CardLayer3.center.y);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:0.1];
    CardLayer3.transform = CGAffineTransformMakeTranslation(0,0);
    _3Dt = CATransform3DMakeRotation(1.64f,0.0f,-1.0f,0.0f);
    _3Dt.m34 = 0.001f;
    _3Dt.m14 = -0.0015f;
    
    CardLayer3.layer.transform =_3Dt;
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:0.95];
    
    
    CGRect frm=[AnimationMainBackView frame];
    frm.origin.x+=290.0f;
    [AnimationMainBackView setFrame:frm];
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.95];
    
    [CardLayer4 setAlpha:1.0f];
    [CardLayer3 setAlpha:0.0f];
    
    [UIView commitAnimations];
    
}

-(void)OpenCardBack
{
    IsCardBackOpen=TRUE;
    PerformNextStep=FALSE;
    
    [self ScrollToScreen2];
    
    [UIView animateWithDuration:0.1f delay:0.30f options:UIViewAnimationCurveEaseInOut animations:^{
        
        [CardLayer4 setAlpha:0.0f];
        [CardLayer3 setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0f delay:0.00f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CardLayer3.transform = CGAffineTransformIdentity;
            CardLayer3.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }];
}


-(void)CloseCard
{
    IsCardFontOpen=FALSE;
    [self ScrollToScreen2];
    
    [UIView animateWithDuration:0.1f delay:0.30f options:UIViewAnimationCurveEaseInOut animations:^{
        
        [CardLayer2 setAlpha:0.0f];
        [CardLayer1 setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0f delay:0.00f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CardLayer1.transform = CGAffineTransformIdentity;
            CardLayer1.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
           
            [AnimationMainBackView setFrame:InitialRect];
            CGSize ContentSize=CGSizeMake(320.0f, [AnimationView frame].size.height);
            [AnimationView setContentSize:ContentSize];
                        
        }];
        
    }];
}


-(void)OpenCustomMessageEditor
{
    float Hei=(IsIphone5)?568.0f:480.0f;
    CGRect BackViewRect=CGRectMake(0.0f, 0.0f, 320.0f, Hei);
    
    PopupBackView=[[UIView alloc] initWithFrame:BackViewRect];
    [PopupBackView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [AnimationView addSubview:PopupBackView];
    
    CGRect BackUpperViewRect=CGRectMake(9.0f, 30.0f, 302.0f, 205.0f);
    UIView *BackUpperView=[[UIView alloc] initWithFrame:BackUpperViewRect];
   // [BackUpperView setBackgroundColor:[UIColor whiteColor]];
    [BackUpperView setBackgroundColor:[UIColor whiteColor]];
    
    [PopupBackView addSubview:BackUpperView];
    
    CGRect TickRect=CGRectMake(285.0f, 15.0f, 32.0f, 37.0f);
    UIButton *TickButton=[[UIButton alloc] initWithFrame:TickRect];
    [TickButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    [TickButton addTarget:self action:@selector(CustomMessagesWritten) forControlEvents:UIControlEventTouchUpInside];
    [PopupBackView addSubview:TickButton];
    
    CGRect MessageViewRect=CGRectMake(11.0f, 20.0f, 280.0f, 165.0f);
    CustomMessageView=[[UITextView alloc] initWithFrame:MessageViewRect];
    [CustomMessageView setFont:[UIFont fontWithName:@"Segoe Script" size:18.0f]];
    [CustomMessageView setTextColor:UIColorFromRGB(0xB49E63)];
    [CustomMessageView setText:([[TVWriteMessage text] isEqualToString:@"Write Your Message"])?@"":[TVWriteMessage text]];
    [BackUpperView addSubview:CustomMessageView];
    [CustomMessageView becomeFirstResponder];
}


-(void)OpenMessageSelector
{
    
    float Hei=(IsIphone5)?568.0f:480.0f;
    CGRect BackViewRect=CGRectMake(0.0f, 20.0f, 320.0f, Hei);
    
    PopupBackView=[[UIView alloc] initWithFrame:BackViewRect];
    [PopupBackView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [AnimationView addSubview:PopupBackView];
    
    CGRect BackUpperViewRect=CGRectMake(9.0f, 10.0f, 302.0f, 450.0f);
    UIView *BackUpperView=[[UIView alloc] initWithFrame:BackUpperViewRect];
    [BackUpperView setBackgroundColor:[UIColor whiteColor]];
    
    [PopupBackView addSubview:BackUpperView];
    
    CGRect TickRect=CGRectMake(285.0f, 0.0f, 32.0f, 37.0f);
    UIButton *TickButton=[[UIButton alloc] initWithFrame:TickRect];
    [TickButton setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    [TickButton addTarget:self action:@selector(MessageHasbeenSelected) forControlEvents:UIControlEventTouchUpInside];
    [PopupBackView addSubview:TickButton];
    
    UILabel *HeaderText=[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 290.0f, 30.0f)];
    [HeaderText setFont:[UIFont fontWithName:@"papyrus" size:20.0f]];
    [HeaderText setText:@"Choose Your Message"];
    [HeaderText setBackgroundColor:[UIColor clearColor]];
    [HeaderText setTextColor:UIColorFromRGB(0xe8661c)];
    [HeaderText setTextAlignment:NSTextAlignmentCenter];
    [BackUpperView addSubview:HeaderText];
    
    [self AddMesssageSeperator:BackUpperView fromTop:40.0f];
    
    UIScrollView *TextBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 75.0f, 300.0f, 400.0f)];
    [TextBgScrollView setDelegate:self];
    [TextBgScrollView setUserInteractionEnabled:YES];
    [TextBgScrollView setScrollEnabled:YES];
    [TextBgScrollView setBackgroundColor:[UIColor clearColor]];
    [TextBgScrollView setShowsVerticalScrollIndicator:YES];
    [TextBgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [BackUpperView addSubview:TextBgScrollView];
    
//    [self AddMesssageSeperator:TextBgScrollView fromTop:105.0f];
//    [self AddMesssageSeperator:TextBgScrollView fromTop:295.0f];
//    [self AddMesssageSeperator:TextBgScrollView fromTop:325.0f];

    UIFont * GlobalFont     = [UIFont fontWithName:@"Vollkorn-Regular"size:16.0f];
    float  GlobalSaperater  = 20.0f;
    CGSize textviewSize1     = [StaticMessage1 sizeWithFont:GlobalFont constrainedToSize:CGSizeMake(290.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    NSLog(@"StaticMessage1 ---- %@",StaticMessage1);
    
    CGRect Message1Rect=CGRectMake(5.0f, 0.0f, 290.0f, textviewSize1.height+GlobalSaperater);
    UITextView *TextView1=[[UITextView alloc] initWithFrame:Message1Rect];
    [TextView1 setTextAlignment:NSTextAlignmentCenter];
    [TextView1 setText:StaticMessage1];
    [TextView1 setFont:GlobalFont];
    [TextView1 setEditable:NO];
    [TextView1 setScrollEnabled:NO];
    [TextView1 setUserInteractionEnabled:YES];
    [TextView1 setTextColor:UIColorFromRGB(0x776948)];
    [TextView1.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [TextBgScrollView addSubview:TextView1];
    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThisMessage:)];
    [TextView1 addGestureRecognizer:TapGesture];
    
    [self AddMesssageSeperator:TextBgScrollView fromTop:textviewSize1.height];
    
    CGSize textviewSize2     = [StaticMessage2 sizeWithFont:GlobalFont constrainedToSize:CGSizeMake(290.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect Message2Rect=CGRectMake(5.0f, textviewSize1.height+(GlobalSaperater*2), 290.0f, textviewSize2.height+GlobalSaperater);
    UITextView *TextView2=[[UITextView alloc] initWithFrame:Message2Rect];
    [TextView2 setTextAlignment:NSTextAlignmentCenter];
    [TextView2 setText:StaticMessage2];
    [TextView2 setFont:GlobalFont];
    [TextView2 setEditable:NO];
    [TextView2 setScrollEnabled:NO];
    [TextView2 setUserInteractionEnabled:YES];
    [TextView2 setTextColor:UIColorFromRGB(0x776948)];
    [TextView2.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [TextBgScrollView addSubview:TextView2];
    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThisMessage:)];
    [TextView2 addGestureRecognizer:TapGesture];
    
    [self AddMesssageSeperator:TextBgScrollView fromTop:(textviewSize1.height+textviewSize2.height+GlobalSaperater*2)];
    
    CGSize textviewSize3     = [StaticMessage3 sizeWithFont:GlobalFont constrainedToSize:CGSizeMake(290.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect Message3Rect=CGRectMake(5.0f, textviewSize1.height+textviewSize2.height+(GlobalSaperater*4), 290.0f, textviewSize3.height+GlobalSaperater);
    UITextView *TextView3=[[UITextView alloc] initWithFrame:Message3Rect];
    [TextView3 setTextAlignment:NSTextAlignmentCenter];
    [TextView3 setText:StaticMessage3];
    [TextView3 setFont:GlobalFont];
    [TextView3 setEditable:NO];
    [TextView3 setScrollEnabled:NO];
    [TextView3 setUserInteractionEnabled:YES];
    [TextView3 setTextColor:UIColorFromRGB(0x776948)];
    [TextView3.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [TextBgScrollView addSubview:TextView3];
    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThisMessage:)];
    [TextView3 addGestureRecognizer:TapGesture];
    
    [self AddMesssageSeperator:TextBgScrollView fromTop:(textviewSize1.height+textviewSize2.height+textviewSize3.height+GlobalSaperater*4)];

    CGRect NoneRect=CGRectMake(5.0f, (textviewSize1.height+textviewSize2.height+textviewSize3.height+GlobalSaperater*5), 280.0f, 80.0f);
    UILabel *nonelabel=[[UILabel alloc] initWithFrame:NoneRect];
    [nonelabel setText:@"(No Message, just a personalized note)"];
    [nonelabel setTextAlignment: NSTextAlignmentCenter];
    [nonelabel setLineBreakMode:NSLineBreakByWordWrapping];
    [nonelabel setBackgroundColor:[UIColor clearColor]];
    [nonelabel setFont:[UIFont fontWithName:@"Vollkorn-Regular" size:16.0f]];
    [nonelabel setUserInteractionEnabled:YES];
    [nonelabel setTextColor:UIColorFromRGB(0x776948)];
    [TextBgScrollView addSubview:nonelabel];
    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClearPreviousSelectedMessage)];
    [nonelabel addGestureRecognizer:TapGesture];
    
    [TextBgScrollView setContentSize:CGSizeMake(300.0f, (textviewSize1.height+textviewSize2.height+textviewSize3.height+GlobalSaperater*6+150))];
}




-(void)ClearPreviousSelectedMessage
{
    //[TVChooseMessage setBackgroundColor:[UIColor clearColor]];
    //[TVChooseMessage setText:@""];
    
    IsNoneSelected=TRUE;
    [TVChooseMessage removeFromSuperview];
    [PopupBackView removeFromSuperview];
    [TVWriteMessage setText:@""];
    CGRect TempRect=[TVWriteMessage frame];
    TempRect.origin.y-=120.0f;
    TempRect.size.height+=120.0f;
    [TVWriteMessage setFrame:TempRect];
    
    [self OpenCustomMessageEditor];
}

-(void)selectThisMessage :(UIGestureRecognizer *)Recognizer
{
    [TVChooseMessage setBackgroundColor:[UIColor clearColor]];
    
    UITextView *MessageView=(UITextView *)[[Recognizer self] view];
    [TVChooseMessage setText:[MessageView text]];
    [PopupBackView removeFromSuperview];
}

-(void)MessageHasbeenSelected
{
    [PopupBackView removeFromSuperview];
}

-(void)CustomMessagesWritten
{
    if([[CustomMessageView text] isEqualToString:@""])
    {
        [TVWriteMessage setText:@"Write Your Message"];
        [TVWriteMessage setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [TVWriteMessage setText:[CustomMessageView text]];
        [TVWriteMessage setBackgroundColor:[UIColor clearColor]];
    }
    [PopupBackView removeFromSuperview];
}


#pragma mark UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Cancel"])
    {
        NSLog(@"Canceled");
    }
    if ([buttonTitle isEqualToString:@"Use Camera"])
    {
        NSLog(@"Open Camera");
        [self OpenCamera];
    }
    if ([buttonTitle isEqualToString:@"User Camera Roll"])
    {
        NSLog(@"Open Camera Roll");
        [self OpenCameraRoll];
    }
}



-(void)OpenCamera
{
    @try
    {
        newMedia=TRUE;
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = hasCamera ? UIImagePickerControllerSourceTypeCamera :    UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    @catch (NSException *juju)
    {
        NSLog(@"%@", juju);
    }
}

-(void)OpenCameraRoll
{
    @try
    {
        newMedia=FALSE;
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType =    UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    @catch (NSException *juju)
    {
        NSLog(@"%@", juju);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (newMedia)
        
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
    
    
    [AttachedImageView setImage:image];
    [AttachedImageView setUserInteractionEnabled:YES];
    TapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OpenImageUploadOptions)];
    [AttachedImageView addGestureRecognizer:TapGesture];
    [BtnAttached setHidden:YES];
    [LblAttachAnImage setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle: @"Save failed"
                              
                              message: @"Failed to save image"
                              
                              delegate: nil
                              
                              cancelButtonTitle:@"OK"
                              
                              otherButtonTitles:nil];
        
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 190) {
        if (buttonIndex == 1) {
            IsCardFontOpen=FALSE;
            IsCardBackOpen=TRUE;
            newMedia=TRUE;
            PerformNextStep=FALSE;
            [AnimationBackView removeFromSuperview];
            
        }
    } else {
        if(buttonIndex==0)
        {
            if([alertView tag]==14)
            {
                [self PerformGoBackTo:@"CategoryView"];
            }
        }
    }
}

@end
