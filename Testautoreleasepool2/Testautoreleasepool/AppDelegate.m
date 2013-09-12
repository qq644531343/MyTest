//
//  AppDelegate.m
//  Testautoreleasepool
//
//  Created by mac on 13-7-2.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[self redirectNSLogToDocumentFolder];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 200, 80, 40);
    [btn addTarget:self action:@selector(changebg) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:btn];

    //init motionManager
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 1.0f;
        
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)changebg
{
    int i = arc4random()%255+1;
    int j = arc4random()%255+1;
    int k = arc4random()%255+1;
    [self.window setBackgroundColor:[UIColor colorWithRed:i/255.0f green:j/255.0f blue:k/255.0f alpha:1.0f]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    NSLog(@"enter background");
     [self update];

    self.backgroundTaskIdentifier =
    [application beginBackgroundTaskWithExpirationHandler:^(void) {
       
        NSLog(@"begin in background after 10 minutes");
        [motionManager stopAccelerometerUpdates];
        motionManager.accelerometerUpdateInterval = 1.0f;
//        [self update2];
        [self endBackgroundTask];
       
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        // Do the work associated with the task.
        [self update2];
        [self endBackgroundTask];
    });

}

-(void)update
{
    NSLog(@"update");
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMAccelerometerData *accelerometerData,NSError *error)
     {
         CMAcceleration acceleration=accelerometerData.acceleration;
         NSLog(@"update: x:%f y:%f z:%f timeremian:%f",acceleration.x,acceleration.y,acceleration.z,[UIApplication sharedApplication].backgroundTimeRemaining);
         
     }];
    
}

-(void)update2
{
        int i=0;
        NSLog(@"begin back acc");
        while (1) {
             @autoreleasepool {
            //app enter foreground
            if ([[UIApplication sharedApplication] backgroundTimeRemaining] > 600.0f) {
                break;
            }
            CMAcceleration acceleration = motionManager.accelerometerData.acceleration;
            NSLog(@"update2: x:%f y:%f z:%f %d",acceleration.x,acceleration.y,acceleration.z,i++);
             }
            sleep(1.0);
       }
    NSLog(@"%s stoped acc",__func__);
    [motionManager stopAccelerometerUpdates];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"enter foreground");
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid){
        [self endBackgroundTask];
    }
}

- (BOOL) isMultitaskingSupported{
    
    BOOL result = NO;
    if ([[UIDevice currentDevice]
         respondsToSelector:@selector(isMultitaskingSupported)]){
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return result;
    
}

- (void) endBackgroundTask{
    
    NSLog(@"end task");
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    AppDelegate
    *weakSelf = self;
    
    dispatch_async(mainQueue, ^(void) {
        
        AppDelegate
        *strongSelf = weakSelf;
        
        if (strongSelf != nil){
            [[UIApplication sharedApplication]
             endBackgroundTask:self.backgroundTaskIdentifier];
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            [motionManager stopAccelerometerUpdates];
        }
    });
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is abou/255.0t to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
