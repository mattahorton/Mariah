//
//  MHViewController.m
//  Mariah
//
//  Created by Matthew Horton on 1/19/15.
//  Copyright (c) 2015 Matt Horton. All rights reserved.
//

#import "MHViewController.h"
#import "MHCore.h"
#import "PPSSignatureView.h"
#import <OpenGLES/ES2/glext.h>

@interface MHViewController()

@property (strong, nonatomic) MHCore *core;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation MHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.core = [[MHCore alloc] initWithViewController:self];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
//    GLKView *view = (GLKView *)self.view;
//    view.context = self.context;
//    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    PPSSignatureView *view = [[PPSSignatureView alloc] initWithFrame:CGRectMake(mainScreen.size.width / 2, mainScreen.size.height / 2, 50, 50) context:self.context];
    
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

@end
