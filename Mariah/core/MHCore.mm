//
//  MHCore.m
//  Mariah
//
//  Created by Matthew Horton on 1/16/15.
//  Copyright (c) 2015 Matt Horton. All rights reserved.
//

#import "MHCore.h"
#import "AEBlockAudioReceiver.h"
#import "AEAudioFilePlayer.h"
#import "mo-gfx.h"
#import "mo-touch.h"
#import "mo-fft.h"

#define SRATE 24000
#define FRAMESIZE 512
#define NUM_CHANNELS 2


// global variables
GLfloat g_waveformWidth = 300;
GLfloat g_waveformHeight = 420;
GLfloat g_gfxWidth = 320;
GLfloat g_gfxHeight = 568;
GLint g_numBigBars = 20;

// buffer
float * g_vertices = NULL;
UInt32 g_numFrames;
float * g_buffer = NULL;
float * g_freq_buffer = NULL;
complex * g_cbuff = NULL;
// window
float * g_window = NULL;
float * g_spectrum = NULL;
float * g_bars = NULL;
float * g_big_bars = NULL;
GLshort * g_specIndeces = NULL;
GLshort * g_bigIndeces = NULL;
float * g_big_bar_heights = NULL;


@implementation MHCore {
    long framesize;
    AEBlockAudioReceiver *audioRec;
    AEBlockAudioReceiver *audioOut;
    AEAudioFilePlayer *player;
    AEBlockChannel *mandolinChannel;
}

-(instancetype)initWithViewController:(MHViewController *) viewController {
    self.vc = viewController;
    self.fromFile = NO;
    return self;
}

-(instancetype)init {
    return [[MHCore alloc] initWithViewController:nil];
}

-(void) coreInit {
    stk::Stk::setRawwavePath([[[NSBundle mainBundle] pathForResource:@"rawwaves" ofType:@"bundle"] UTF8String]);

    GLoilerInit();
    
    self.vc.audioController = [[AEAudioController alloc]
                            initWithAudioDescription:[AEAudioController nonInterleavedFloatStereoAudioDescription]
                            inputEnabled:YES];
    
    NSError *errorAudioSetup = NULL;
    BOOL result = [[self.vc audioController] start:&errorAudioSetup];
    if ( !result ) {
        NSLog(@"Error starting audio engine: %@", errorAudioSetup.localizedDescription);
    }
    
    NSTimeInterval dur = self.vc.audioController.currentBufferDuration;
    
    framesize = AEConvertSecondsToFrames(self.vc.audioController, dur);
    
    g_vertices = new float[framesize*2]; //2d
    
    NSURL *file = [[NSBundle mainBundle] URLForResource:@"Loop" withExtension:@"m4a"];
    player = [AEAudioFilePlayer audioFilePlayerWithURL:file
                                          audioController:self.vc.audioController
                                                    error:NULL];
    [player setLoop:YES];
    [player setCurrentTime:0];
    [player setVolume:0];
    
    self.mandolin = new stk::Mandolin(400);
    
    mandolinChannel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                           UInt32 frames,
                                                           AudioBufferList *audio) {
        for ( int i=0; i<frames; i++ ) {
            
            ((float*)audio->mBuffers[0].mData)[i] =
            ((float*)audio->mBuffers[1].mData)[i] = self.mandolin->tick();
            
        }
    }];
    
    [self.vc.audioController addChannels:@[mandolinChannel]];
    
//    audioRec = [AEBlockAudioReceiver audioReceiverWithBlock:^(void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {}];
//    
//    audioOut = [AEBlockAudioReceiver audioReceiverWithBlock:^(void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {}];
//    
//    [self.vc.audioController addInputReceiver:audioRec];
//    [self.vc.audioController addOutputReceiver:audioOut];
    [self.vc.audioController addChannels: @[player]];
    
}

-(void) coreRender {
    // NSLog( @"render..." );
    
    // projection
    glMatrixMode( GL_PROJECTION );
    // reset
    glLoadIdentity();
    // alternate
    // GLfloat ratio = g_gfxHeight / g_gfxWidth;
    // glOrthof( -1, 1, -ratio, ratio, -1, 1 );
    // orthographic
    glOrthof( -g_gfxWidth/2, g_gfxWidth/2, -g_gfxHeight/2, g_gfxHeight/2, -1.0f, 1.0f );
    // modelview
    glMatrixMode( GL_MODELVIEW );
    // reset
    // glLoadIdentity();
    
    glClearColor( 0, 0, 0, 1 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // push
    glPushMatrix();
    
    //Draw things
    
    // pop
    glPopMatrix();
}

-(void) coreSetDimsWithWidth:(CGFloat)w andHeight:(CGFloat)h {
    GLoilerSetDims(w, h);
}

@end








//  From file:
//  renderer.mm
//  GLoiler
//
//  Created by Ge Wang on 1/15/15.
//  Copyright (c) 2014 Ge Wang. All rights reserved.
//


//-----------------------------------------------------------------------------
// name: touch_callback()
// desc: the touch call back
//-----------------------------------------------------------------------------
void touch_callback( NSSet * touches, UIView * view,
                    std::vector<MoTouchTrack> & tracks,
                    void * data)
{
    // points
    CGPoint pt;
    CGPoint prev;
    
    // number of touches in set
    NSUInteger n = [touches count];
    NSLog( @"total number of touches: %d", (int)n );
    
    // iterate over all touch events
    for( UITouch * touch in touches )
    {
        // get the location (in window)
        pt = [touch locationInView:view];
        prev = [touch previousLocationInView:view];
        
        // check the touch phase
        switch( touch.phase )
        {
                // begin
            case UITouchPhaseBegan:
            {
                NSLog( @"touch began... %f %f", pt.x, pt.y );
                break;
            }
            case UITouchPhaseStationary:
            {
                NSLog( @"touch stationary... %f %f", pt.x, pt.y );
                break;
            }
            case UITouchPhaseMoved:
            {
                NSLog( @"touch moved... %f %f", pt.x, pt.y );
                break;
            }
                // ended or cancelled
            case UITouchPhaseEnded:
            {
                NSLog( @"touch ended... %f %f", pt.x, pt.y );
                break;
            }
            case UITouchPhaseCancelled:
            {
                NSLog( @"touch cancelled... %f %f", pt.x, pt.y );
                break;
            }
                // should not get here
            default:
                break;
        }
    }
}


// initialize the engine (audio, grx, interaction)
void GLoilerInit()
{
    NSLog( @"init..." );
    
    // set touch callback
    MoTouch::addCallback( touch_callback, NULL );
}


// set graphics dimensions
void GLoilerSetDims( float width, float height )
{
    NSLog( @"set dims: %f %f", width, height );
}