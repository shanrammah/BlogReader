//
//  BlogPost.h
//  BlogReader
//
//  Created by Shan Rammah on 1/7/16.
//  Copyright © 2016 Shan Rammah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogPost : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSURL *url; 

// Designated Initializer 
- (id) initWithTitle:(NSString *)title; //after the ":" means the argument
+ (id) blogPostWithtTitle:(NSString *)title;

- (NSURL *) thumbnailURL;
- (NSString *) formattedDate;

@end
