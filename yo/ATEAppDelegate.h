//
//  ATEAppDelegate.h
//  yo
//
//  Created by Alex Esplin on 9/8/13.
//  Copyright (c) 2013 Alex Esplin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ATETimeSpec;
@class EKCalendar;
@class EKEventStore;

@interface ATEAppDelegate : NSObject <NSApplicationDelegate> {
    EKCalendar *reminder_cal;
    EKEventStore *event_store;
    ATETimeSpec *myTimeSpec;
}

@property (assign) IBOutlet NSWindow *window;

- (EKCalendar *) getRemindersCalendarFromEventStore:(EKEventStore *)store;
- (int) createReminderWithMessageText:(NSString *)msg;

@end
