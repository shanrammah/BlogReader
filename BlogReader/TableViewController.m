//
//  TableViewController.m
//  BlogReader
//
//  Created by Shan Rammah on 1/6/16.
//  Copyright © 2016 Shan Rammah. All rights reserved.
//

#import "TableViewController.h"
#import "BlogPost.h"
#import "WebViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *blogURL = [NSURL URLWithString:@"http://blog.teamtreehouse.com/api/get_recent_summary/"];
    
    /* //This is the old sync method
    NSData *jsonData = [NSData dataWithContentsOfURL:blogURL];
    
    NSError *error = nil;
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error]; //you have to pass the reference for an error
    // NSLog(@"%@", dataDictionary);
    
    self.blogPosts = [[NSMutableArray alloc] init];
    
    NSArray *blogPostsArray = [dataDictionary objectForKey:@"posts"];
    
    for (NSDictionary *bpDictionary in blogPostsArray) {
        BlogPost *blogPost = [BlogPost blogPostWithtTitle:[bpDictionary objectForKey:@"title"]];
        blogPost.author = [bpDictionary objectForKey:@"author"];
        blogPost.thumbnail = [bpDictionary objectForKey:@"thumbnail"];
        blogPost.date = [bpDictionary objectForKey:@"date"];
        blogPost.url = [NSURL URLWithString:[bpDictionary objectForKey:@"url"]];
        [self.blogPosts addObject:blogPost];
    }
    
    */
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:blogURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *jsonData = [[NSData alloc] initWithContentsOfURL:location];
        
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error]; //you have to pass the reference for an error
        // NSLog(@"%@", dataDictionary);
        
        self.blogPosts = [[NSMutableArray alloc] init];
        
        NSArray *blogPostsArray = [dataDictionary objectForKey:@"posts"];
        
        for (NSDictionary *bpDictionary in blogPostsArray) {
            BlogPost *blogPost = [BlogPost blogPostWithtTitle:[bpDictionary objectForKey:@"title"]];
            blogPost.author = [bpDictionary objectForKey:@"author"];
            blogPost.thumbnail = [bpDictionary objectForKey:@"thumbnail"];
            blogPost.date = [bpDictionary objectForKey:@"date"];
            blogPost.url = [NSURL URLWithString:[bpDictionary objectForKey:@"url"]];
            [self.blogPosts addObject:blogPost];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.tableView reloadData];
        });
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.blogPosts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"treehouse.png"];
    
    if( [blogPost.thumbnail isKindOfClass:[NSString class]]) {
    
        //    NSData *imageData = [NSData dataWithContentsOfURL:blogPost.thumbnailURL];
        //    UIImage *image = [UIImage imageWithData:imageData];
        //    cell.imageView.image = image;
        //    We now load data async
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:blogPost.thumbnailURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:location];
        
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^ {
            cell.imageView.image = image;
                    
        });
    }];
        [task resume];
        
    }

    cell.textLabel.text = blogPost.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", blogPost.author, [blogPost formattedDate]];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"preparing for seqgue: %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"showBlogPost"]) {
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setBlogPostURL:blogPost.url];
        
    }
}

@end
