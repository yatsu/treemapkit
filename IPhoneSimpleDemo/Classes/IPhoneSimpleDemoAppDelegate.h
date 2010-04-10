#import <UIKit/UIKit.h>

@class IPhoneSimpleDemoViewController;

@interface IPhoneSimpleDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IPhoneSimpleDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet IPhoneSimpleDemoViewController *viewController;

@end

