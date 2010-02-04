//
//  Robot_Finds_KittenAppDelegate.m
//  Robot Finds Kitten
//
//  Created by Geoffrey Gallaway on 10/1/09.
//

#import "Robot_Finds_KittenAppDelegate.h"
#import "Robot_Finds_KittenViewController.h"
#import "InformationWindowViewController.h"

@implementation Robot_Finds_KittenAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize informationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    // Override point for customization after app launch 
    [window addSubview:viewController.view];
	[window addSubview:informationController.view];
    //[window bringSubviewToFront:informationController.view];
}


- (void)dealloc {
    [viewController release];
	[informationController release];
    [window release];
    [super dealloc];
}


@end
