//
//  ViewController.m
//  Sessions
//
//  Created by Ginny Fahs on 1/31/19.
//  Copyright © 2019 Ginny's Games. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // get data form an API via a data task
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"%@", json);
//    }];
//        [dataTask resume]
    
    // download a photo via a download task
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // passing nil here creates a delegate queue, so delegate methods happen on a background thread
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.tutsplus.com/mobile/uploads/2013/12/sample.jpg"]];
    [downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setHidden:YES];
        [self.imageView setImage:[UIImage imageWithData:data]];
    });
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress];
    });
}


@end
