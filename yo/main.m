//
//  main.m
//  yo
//
//  Created by Alex Esplin on 9/8/13.
//  Copyright (c) 2013 Alex Esplin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "yo.h"

void usage()
{
    fprintf(stdout, "Usage:\n");
    
    fprintf(stdout, "yo <time-spec> <message>\n");
    fprintf(stdout, "\n");
    
    fprintf(stdout, "Where:\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "    <time-spec> is one of the following types:\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "        +[<count>[w|d|h|m|s]]\n");
    fprintf(stdout, "            (reminder date/time relative to now)\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "        @<[yyyy/mm/dd_]hh:mm[:ss]\n");
    fprintf(stdout, "            (reminder at given time)\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "    <message> is a quoted string to use as the reminder text.\n");
    
    fprintf(stdout, "\n");
    fprintf(stdout, "Examples:\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "    yo +45m \"some message\"\n");
    fprintf(stdout, "        reminder 45 minutes from now\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "    yo @2013/04/2_12:45 \"some message\"\n");
    fprintf(stdout, "        reminder on April 2, 2013, at 12:45\n");
    fprintf(stdout, "\n");
}

int main(int argc, const char * argv[])
{
    
    /* we need some arguments */
    if (argc < 3) {
        usage();
        exit(1);
    }
    return NSApplicationMain(argc, argv);
}
