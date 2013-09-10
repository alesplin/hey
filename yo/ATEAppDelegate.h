//
//  ATEAppDelegate.h
//  yo
//
//  Created by Alex Esplin on 9/8/13.
//  Copyright (c) 2013 Alex Esplin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ATETimeSpec;

@interface ATEAppDelegate : NSObject <NSApplicationDelegate> {
    ATETimeSpec *myTimeSpec;
}

@property (assign) IBOutlet NSWindow *window;

@end
