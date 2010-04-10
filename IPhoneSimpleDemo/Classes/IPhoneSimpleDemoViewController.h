#import <UIKit/UIKit.h>
#import "TreemapView.h"

@interface IPhoneSimpleDemoViewController : UIViewController <TreemapViewDelegate, TreemapViewDataSource> {
	NSMutableArray *fruits;
}

@property (nonatomic, retain) NSMutableArray *fruits;

@end

