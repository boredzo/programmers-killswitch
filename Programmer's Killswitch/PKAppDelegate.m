//
//  PKAppDelegate.m
//  Programmer's Killswitch
//
//  Created by Peter Hosey on 2011-10-17.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

#import "PKAppDelegate.h"

#import "PKProcessKiller.h"

@implementation PKAppDelegate
{
	PKProcessKiller *killer;
}

- (void) applicationWillFinishLaunching:(NSNotification *)notification {
	killer = [PKProcessKiller new];
}
- (void) applicationWillTerminate:(NSNotification *)notification {
	killer = nil;
}

@end
