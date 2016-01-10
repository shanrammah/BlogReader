//
//  BlogPost.m
//  BlogReader
//
//  Created by Shan Rammah on 1/7/16.
//  Copyright © 2016 Shan Rammah. All rights reserved.
//

#import "BlogPost.h"

@implementation BlogPost

- (id) initWithTitle:(NSString *)title
{
    self = [super init];
    
    if (self) {
        
        _title = title; 
        
    }
    
    return self;
}

+ (id)blogPostWithtTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title]; 
}

- (NSURL *)thumbnailURL
{
    return [NSURL URLWithString:self.thumbnail];
}

- (NSString *) formattedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tempDate = [dateFormatter dateFromString:self.date];
    
    [dateFormatter setDateFormat:@"EE MMM,dd"];
    return [dateFormatter stringFromDate:tempDate];
    
}

@end
