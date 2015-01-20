//
//  MHViewController.m
//  Mariah
//
//  Created by Matthew Horton on 1/19/15.
//  Copyright (c) 2015 Matt Horton. All rights reserved.
//

#import "MHViewController.h"
#import "MHCore.h"
#import <OpenGLES/ES2/glext.h>
#import "mo-fun.h"

#define divisions 15.0

@interface MHViewController()

@property (strong, nonatomic) MHCore *core;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation MHViewController {
    float viewHeight;
    float divHeight;
    int keyOffset;
    float lastY;
    BOOL firstTouchYet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewHeight = [[UIScreen mainScreen] bounds].size.height;
//    NSLog(@"%f - viewHeight",viewHeight);
    divHeight = viewHeight / divisions;
//    NSLog(@"%f - divHeight",divHeight);
    lastY = 0.0;
    firstTouchYet = NO;
    
    self.core = [[MHCore alloc] initWithViewController:self];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
//    GLKView *view = (GLKView *)self.view;
//    view.context = self.context;
//    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
//    CGRect mainScreen = [[UIScreen mainScreen] bounds];
//    PPSSignatureView *view = [[PPSSignatureView alloc] initWithFrame:CGRectMake(mainScreen.size.width / 2, mainScreen.size.height / 2, 50, 50) context:self.context];
    
    [self setupGL];
    
    // initialize
    [self.core coreInit];
}

- (void)viewDidLayoutSubviews
{
    [self.core coreSetDimsWithWidth:self.view.bounds.size.width andHeight: self.view.bounds.size.height ];
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    // glEnable( GL_DEPTH_TEST );
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
}

- (void)yValueReturned:(float)y{
    if(!firstTouchYet) {
        firstTouchYet = YES;
        [self.core unmute];
    }
    
//    Major Scale: R, W, W, H, W, W, W, H
//    Natural Minor Scale: R, W, H, W, W, H, W, W
    int midi = 48+keyOffset;
    if (y > (viewHeight-divHeight)) {
        midi += 0;
    } else if (y > (viewHeight - divHeight*2)) {
        midi += 2;
    } else if (y > (viewHeight - divHeight*3)) {
        midi += 3;
    } else if (y > (viewHeight - divHeight*4)) {
        midi += 5;
    } else if (y > (viewHeight - divHeight*5)) {
        midi += 7;
    } else if (y > (viewHeight - divHeight*6)) {
        midi += 8;
    } else if (y > (viewHeight - divHeight*7)) {
        midi += 10;
    } else if (y > (viewHeight - divHeight*8)) {
        midi += 12;
    } else if (y > (viewHeight - divHeight*9)) {
        midi += 14;
    } else if (y > (viewHeight - divHeight*10)) {
        midi += 15;
    } else if (y > (viewHeight - divHeight*11)) {
        midi += 17;
    } else if (y > (viewHeight - divHeight*12)) {
        midi += 19;
    } else if (y > (viewHeight - divHeight*13)) {
        midi += 20;
    } else if (y > (viewHeight - divHeight*14)) {
        midi += 22;
    } else if (y > (viewHeight - divHeight*15)) {
        midi += 24;
    }

    self.core.mandolin->setFrequency(MoFun::midi2freq(midi));
    self.core.mandolin->pluck(1);
    
    lastY = y;
}

- (IBAction)newValue:(id)sender {
    UIStepper *stepper = (UIStepper *)sender;
    keyOffset = (int)stepper.value;
}

@end
