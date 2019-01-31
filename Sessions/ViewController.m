//
//  ViewController.m
//  Sessions
//
//  Created by Ginny Fahs on 1/31/19.
//  Copyright © 2019 Ginny's Games. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>


@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *resumeData;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // EXAMPLE 1: get data form an API via a data task
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"%@", json);
//    }];
//        [dataTask resume]
    
    // EXAMPLE 2: download a photo via a download task
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // passing nil here creates a delegate queue
    // i.e. delegate methods will happen on a background thread
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
//    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.tutsplus.com/mobile/uploads/2013/12/sample.jpg"]];
//    [downloadTask resume];
    
    // EXAMPLE 3: refactor to cancel and resume using new methods
    
    // Add Observer
    [self addObserver:self forKeyPath:@"resumeData" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"downloadTask" options:NSKeyValueObservingOptionNew context:NULL];
    
    // Setup User Interface
    [self.cancelButton setHidden:YES];
    [self.resumeButton setHidden:YES];
    
    // Create download task
    self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.tutsplus.com/mobile/uploads/2014/01/5a3f1-sample.jpg"]];
    
    // Resume download task
    
    [self.downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setHidden:YES];
        [self.imageView setImage:[UIImage imageWithData:data]];
        [self.imageView setImage:[UIImage imageWithData:data]];
    });
    
    // Invalidate Session
    [session finishTasksAndInvalidate];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress];
    });
}

-(NSURLSession *)session {
    if (!_session) {
        // Create session configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Create session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}

-(IBAction)cancel:(id)sender {
    if (!self.downloadTask) return;
    
    // Hide Cancel Button
    [self.cancelButton setHidden:YES];
    
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (!resumeData) return;
        [self setResumeData:resumeData];
        [self setDownloadTask:nil];
    }];
}

-(IBAction)resume:(id)sender {
    if (!self.resumeData) return;
    
    // Hide Resume Button
    [self.resumeButton setHidden:YES];
    
    // Create Download Task
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    
    //Resume Download Task
    [self.downloadTask resume];
    
    // Clean up
    [self setResumeData:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"resumeData"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resumeButton setHidden:(self.resumeData == nil)];
        });
    } else if ([keyPath isEqualToString:@"downloadTask"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cancelButton setHidden:(self.downloadTask == nil)];
        });
    }
}

@end
