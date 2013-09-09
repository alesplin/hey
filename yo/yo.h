//
//  yo.h
//  yo
//
//  Created by Alex Esplin on 9/6/12.
//  Copyright (c) 2012 Alex Esplin. All rights reserved.
//

#ifndef yo_yo_h
#define yo_yo_h

#define FAILURE 1
#define SUCCESS 0

#define SECONDS_PER_MINUTE 60
#define SECONDS_PER_HOUR 60*60
#define SECONDS_PER_DAY 60*60*24
#define SECONDS_PER_WEEK 60*60*24*7

typedef enum {
    TimeSpecRelative = 0,
    TimeSpecAbsolute,
    TimeSpecRecurring,
    TimeSpecLAST
} TimeSpecType;

#endif
