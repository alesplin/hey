//
//  ATEAppDelegate.m
//  yo
//
//  Created by Alex Esplin on 9/8/13.
//  Copyright (c) 2013 Alex Esplin. All rights reserved.
//

#import "ATEAppDelegate.h"
#import "ATETimeSpec.h"
#import <EventKit/EventKit.h>

@implementation ATEAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    NSString *timeString = [args objectAtIndex:1];
    NSString *msgString = [args objectAtIndex:2];
    
    myTimeSpec = [[ATETimeSpec alloc] initWithString:timeString];
    NSLog(@"Current Date:      %@", [NSDate date]);
    NSLog(@"Reminder On Date:  %@", [myTimeSpec notificationDate]);
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            fprintf(stdout, "No access to reminders...\n");
            if (error != Nil) {
                fprintf(stderr, "%s\n", [[error localizedDescription] UTF8String]);
            }
        }
        else {
            fprintf(stdout, "Access granted to reminders...\n");
        }
    }];
    
    [NSApp terminate:self];
}

@end
