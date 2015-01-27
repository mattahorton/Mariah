//
//  MHTexture.mm
//  Mariah
//
//  Created by Matthew Horton on 1/25/15.
//  Copyright (c) 2015 Matt Horton. All rights reserved.
//

#import "MHTexture.h"
#import <OpenGLES/ES2/glext.h>
#import "mo-gfx.h"

#define NUM_ENTITIES 256

GLuint g_texture[1];

GLfloat rand2f( float a, float b )
{
    GLfloat diff = b - a;
    return a + ((GLfloat)rand() / RAND_MAX)*diff;
}

class Entity
{
public:
    Entity() { bounce = 0.0f; }
    
public:
    Vector3D loc;
    Vector3D ori;
    Vector3D sca;
    Vector3D vel;
    Vector3D col;
    
    GLfloat bounce;
    GLfloat bounce_rate;
};

Entity g_entities[NUM_ENTITIES];


@implementation MHTexture

+(void) loadNewTexture{
    // enable texture mapping
//    glEnable( GL_TEXTURE_2D );
    // enable blending
    glEnable( GL_BLEND );
    // blend function
    glBlendFunc( GL_ONE, GL_ONE );

    // generate texture name
    glGenTextures( 1, &g_texture[0] );
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, g_texture[0] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"sun1", @"png" );
    
    // init entities
    for( int i = 0; i < NUM_ENTITIES; i++ )
    {
        g_entities[i].loc.x = rand2f( -1, 1 );
        g_entities[i].loc.y = rand2f( -1.5, 1.5 );
        g_entities[i].loc.z = rand2f( -4, 4 );
        
        g_entities[i].ori.z = rand2f( 0, 180 );
        
        g_entities[i].col.x = rand2f( 0, 1 );
        g_entities[i].col.y = rand2f( 0, 1 );
        g_entities[i].col.z = rand2f( 0, 1 );
        
        g_entities[i].sca.x = rand2f( .5, 1 );
        g_entities[i].sca.y = rand2f( 1, 1 );
        g_entities[i].sca.z = rand2f( .5, 1 );
        
        g_entities[i].bounce_rate = rand2f( .25, .5 );
    }

}

+(void)drawTextures{
    static const GLfloat squareVertices[] = {
        -0.5f,  -0.5f,
        0.5f,  -0.5f,
        -0.5f,   0.5f,
        0.5f,   0.5f,
    };
    
    static const GLfloat normals[] = {
        0, 0, 1,
        0, 0, 1,
        0, 0, 1,
        0, 0, 1
    };
    
    static const GLfloat texCoords[] = {
        0, 1,
        1, 1,
        0, 0,
        1, 0
    };
    
    // for each entity
    for( int i = 0; i < NUM_ENTITIES; i++ )
    {
        glPushMatrix();
        
        // translate
        glTranslatef( g_entities[i].loc.x, g_entities[i].loc.y, g_entities[i].loc.z );
        g_entities[i].loc.z += .12f;
        GLfloat val = 1 - fabs(g_entities[i].loc.z)/4.1;
        if( g_entities[i].loc.z > 4 )
        {
            g_entities[i].loc.x = rand2f( -1.5, 1.5);
            g_entities[i].loc.y = rand2f( -2.5, 2.5);
            g_entities[i].loc.z = rand2f( -4, -3.5);
        }
        
        // rotate
        glRotatef( g_entities[i].ori.z, 0, 0, 1 );
        g_entities[i].ori.z += 1.5f;
        
        // scale
        glScalef( g_entities[i].sca.x, g_entities[i].sca.y, g_entities[i].sca.z );
        g_entities[i].sca.y = .8 + .2*::sin(g_entities[i].bounce);
        g_entities[i].bounce += g_entities[i].bounce_rate;
        
        // vertex
        glVertexPointer( 2, GL_FLOAT, 0, squareVertices );
        glEnableClientState(GL_VERTEX_ARRAY );

        // color
        float v = val;
        glColor4f( g_entities[i].col.x*v, g_entities[i].col.y*v,
                  g_entities[i].col.z*v, val );
        
        // normal
        glNormalPointer( GL_FLOAT, 0, normals );
        glEnableClientState( GL_NORMAL_ARRAY );

        // texture coordinate
        glTexCoordPointer( 2, GL_FLOAT, 0, texCoords );
        glEnableClientState( GL_TEXTURE_COORD_ARRAY );
        
        // triangle strip
        glDrawArrays( GL_TRIANGLE_STRIP, 0, 4 );
        
        glPopMatrix();
    }

}

@end
