#import "TreemapView.h"
#import "TreemapViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TreemapViewCell

@synthesize valueLabel;
@synthesize textLabel;
@synthesize index;
@synthesize delegate;

#pragma mark -

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.layer.borderWidth = 1.0;
		self.layer.borderColor = [[UIColor whiteColor] CGColor];

		self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width - 4, 14)];
		valueLabel.font = [UIFont boldSystemFontOfSize:16];
		valueLabel.textAlignment = UITextAlignmentRight;
		valueLabel.textColor = [UIColor whiteColor];
		valueLabel.backgroundColor = [UIColor clearColor];
		valueLabel.lineBreakMode = UILineBreakModeCharacterWrap;
		valueLabel.adjustsFontSizeToFitWidth = frame.size.width - 4;
		[self addSubview:valueLabel];

		self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 17, frame.size.width - 4, 14)];
		textLabel.font = [UIFont boldSystemFontOfSize:16];
		textLabel.textAlignment = UITextAlignmentRight;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
		textLabel.adjustsFontSizeToFitWidth = frame.size.width - 4;
		[self addSubview:textLabel];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	valueLabel.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width - 4, 14);
	textLabel.frame = CGRectMake(0, self.frame.size.height - 17, self.frame.size.width - 4, 14);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([delegate respondsToSelector:@selector(treemapViewCell:tapped:)])
		[delegate treemapViewCell:self tapped:index];
}

- (void)dealloc {
	[valueLabel release];
	[textLabel release];
	[delegate release];

	[super dealloc];
}

@end
