//
//  MHViewController.h
//  Mariah
//
//  Created by Matthew Horton on 1/19/15.
//  Copyright (c) 2015 Matt Horton. All rights reserved.
//

@class AEAudioController;

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "AEAudioController.h"
#import "PPSSignatureView.h"

@interface MHViewController : GLKViewController

@property (nonatomic) AEAudioController *audioController;

- (void)yValueReturned:(float)y withXValue:(float)x;
- (IBAction)newValue:(id)sender;

@end
