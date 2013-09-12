//
//  AppDelegate.h
//  Testautoreleasepool
//
//  Created by mac on 13-7-2.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
     CMMotionManager *motionManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, unsafe_unretained)
UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end
