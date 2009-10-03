//
//  Robot_Finds_KittenAppDelegate.h
//  Robot Finds Kitten
//
//  Created by Geoffrey Gallaway on 10/1/09.
//

#import <UIKit/UIKit.h>
#import "InformationWindowViewController.h"

@class Robot_Finds_KittenViewController;

@interface Robot_Finds_KittenAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	InformationWindowViewController *informationController;

    Robot_Finds_KittenViewController *viewController;
	
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Robot_Finds_KittenViewController *viewController;
@property (nonatomic, retain) IBOutlet InformationWindowViewController *informationController;
@end

