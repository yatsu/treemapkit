#import <UIKit/UIKit.h>

@protocol TreemapViewCellDelegate;

@interface TreemapViewCell : UIControl {
    UILabel *valueLabel;
    UILabel *textLabel;

    NSInteger index;

    id <TreemapViewCellDelegate> delegate;
}

@property (nonatomic, retain) UILabel *valueLabel;
@property (nonatomic, retain) UILabel *textLabel;

@property NSInteger index;

@property (nonatomic, retain) id <TreemapViewCellDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end

@protocol TreemapViewCellDelegate <NSObject>

@optional

- (void)treemapViewCell:(TreemapViewCell *)treemapViewCell tapped:(NSInteger)index;

@end
