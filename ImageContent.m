//
//  ImageContent.m
//  Fotohello
//
//  Created by Santanu Das Adhikary on 16/10/13.
//
//

#import "ImageContent.h"

@implementation ImageContent
@synthesize ImageContentArray,TrendingImageDetail,ForProfileImage,UserProfileImages;
static ImageContent *instance =nil;

+(ImageContent *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [ImageContent new];
        }
    }
    return instance;
}

@end
