//
//  MHCore.h
//  Mariah
//
//  Created by Matthew Horton on 1/16/15.
//  Copyright (c) 2015 Matt Horton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHViewController.h"
#import "AERecorder.h"

#ifndef __GLoiler__renderer__
#define __GLoiler__renderer__

// initialize the engine (audio, grx, interaction)
void GLoilerInit();
// TODO: cleanup
// set graphics dimensions
void GLoilerSetDims( float width, float height );


#endif /* defined(__GLoiler__renderer__) */

@interface MHCore : NSObject

@property (nonatomic) MHViewController* vc;
@property (nonatomic) BOOL fromFile;
@property (nonatomic) float pitShiftFactor;
@property (nonatomic) AERecorder * recorder;
@property (nonatomic) BOOL hasPlayedOnce;

-(instancetype)initWithViewController:(MHViewController *)vc;

-(void) coreInit;
-(void) coreRender;
-(void) coreSetDimsWithWidth:(CGFloat)w andHeight:(CGFloat)h;
-(void) unmute;
-(void) mute;
-(void) beginRecording;
-(void) endRecording;
-(void) playback;

@end
