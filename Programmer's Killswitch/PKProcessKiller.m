//
//  PKProcessKiller.m
//  Programmer's Killswitch
//
//  Created by Peter Hosey on 2011-10-17.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

#import "PKProcessKiller.h"

@interface PKProcessKiller ()
- (BOOL) isRunningApplicationWeCareAbout:(NSRunningApplication *)app;
@end

@implementation PKProcessKiller
{
	NSArray *developerToolProcessNames;
	NSMutableArray *runningApplications;
}

- (id)init {
    if ((self = [super init])) {
        developerToolProcessNames = [NSArray arrayWithObjects:
			@"Xcode",
			@"Instruments",
			@"gdb",
			@"lldb",
			nil];

		runningApplications = [NSMutableArray new];
		NSNotificationCenter *workspaceCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
		[workspaceCenter addObserverForName:NSWorkspaceDidLaunchApplicationNotification
									 object:nil
									  queue:nil
								 usingBlock:^(NSNotification *notification)
			{
				NSRunningApplication *app = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
				if ([self isRunningApplicationWeCareAbout:app]) {
					NSString *name = [app.executableURL lastPathComponent];
					NSLog(@"Launch detected: %@", name);
					[runningApplications addObject:app];
				}
			}
		];
		[workspaceCenter addObserverForName:NSWorkspaceDidTerminateApplicationNotification
									 object:nil
									  queue:nil
								 usingBlock:^(NSNotification *notification)
			{
				NSRunningApplication *app = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
				if ([self isRunningApplicationWeCareAbout:app]) {
					NSString *name = [app.executableURL lastPathComponent];
					NSLog(@"Termination detected: %@", name);
					[runningApplications removeObjectIdenticalTo:app];
				}
			}
		];
		for (NSRunningApplication *app in [[NSWorkspace sharedWorkspace] runningApplications]) {
			if ([self isRunningApplicationWeCareAbout:app])
				[runningApplications addObject:app];
		}
    }
    return self;
}

- (BOOL) isRunningApplicationWeCareAbout:(NSRunningApplication *)app {
	NSString *name = [app.executableURL lastPathComponent];
	return [developerToolProcessNames containsObject:name];
}

- (void) killAllTheDeveloperTools {
	for (NSRunningApplication *app in runningApplications) {
		kill(app.processIdentifier, SIGKILL);
	}
}

@end
