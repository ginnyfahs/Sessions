//
//  ViewController.h
//  Sessions
//
//  Created by Ginny Fahs on 1/31/19.
//  Copyright © 2019 Ginny's Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

-(IBAction)cancel:(id)sender;
-(IBAction)resume:(id)sender;

@end

