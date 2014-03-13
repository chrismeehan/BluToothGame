//
//  SendFartsAppDelegate.h
//  SendFarts
//
//  Created by Vivian Aranha on 12/10/10.
//  Copyright 2010 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendFartsViewController;

@interface SendFartsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SendFartsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SendFartsViewController *viewController;

@end

