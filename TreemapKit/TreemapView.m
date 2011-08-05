#import "TreemapView.h"

@implementation TreemapView

@synthesize dataSource;
@synthesize delegate;

- (void)calcNodePositions:(CGRect)rect nodes:(NSArray *)nodes width:(CGFloat)width height:(CGFloat)height depth:(NSInteger)depth withCreate:(BOOL)createNode {
    if (nodes.count <= 1) {
        NSInteger index = [[[nodes objectAtIndex:0] valueForKey:@"index"] integerValue];
        if (createNode) {
            TreemapViewCell *cell = [dataSource treemapView:self cellForIndex:index forRect:rect];
            cell.index = index;
            cell.delegate = self;
            [self addSubview:cell];
        }
        else {
            TreemapViewCell *cell = [self.subviews objectAtIndex:index];
            cell.frame = rect;
            if ([delegate respondsToSelector:@selector(treemapView:updateCell:forIndex:forRect:)])
                [delegate treemapView:self updateCell:cell forIndex:index forRect:rect];
            [cell layoutSubviews];
        }
        return;
    }

    CGFloat total = 0;
    for (NSDictionary *dic in nodes) {
        total += [[dic objectForKey:@"value"] floatValue];
    }
    CGFloat half = total / 2.0;

    NSInteger customSep = NSNotFound;
    if ([dataSource respondsToSelector:@selector(treemapView:separationPositionForDepth:)])
        customSep = [dataSource treemapView:self separationPositionForDepth:depth];

    NSInteger m;
    if (customSep != NSNotFound) {
        m = customSep;
    }
    else {
        m = nodes.count - 1;
        total = 0.0;
        for (NSInteger i = 0; i < nodes.count; i++) {
            if (total > half) {
                m = i;
                break;
            }
            total += [[[nodes objectAtIndex:i] objectForKey:@"value"] floatValue];
        }
        if (m < 1) m = 1;
    }

    NSArray *aArray = [nodes subarrayWithRange:NSMakeRange(0, m)];
    NSArray *bArray = [nodes subarrayWithRange:NSMakeRange(m, nodes.count - m)];

    CGFloat aTotal = 0.0;
    for (NSDictionary *dic in aArray) {
        aTotal += [[dic objectForKey:@"value"] floatValue];
    }
    CGFloat bTotal = 0.0;
    for (NSDictionary *dic in bArray) {
        bTotal += [[dic objectForKey:@"value"] floatValue];
    }

    CGFloat aRatio;
    if (aTotal + bTotal > 0.0)
        aRatio = aTotal / (aTotal + bTotal);
    else
        aRatio = 0.5;

    CGRect aRect, bRect;
    CGFloat aWidth, aHeight, bWidth, bHeight;

    BOOL horizontal = (width > height);

    CGFloat sep = 0.0;
    if ([dataSource respondsToSelector:@selector(treemapView:separatorWidthForDepth:)])
        sep = [dataSource treemapView:self separatorWidthForDepth:depth];

    if (horizontal) {
        aWidth = ceil((width - sep) * aRatio);
        bWidth = width - sep - aWidth;
        aHeight = bHeight = height;
        aRect = CGRectMake(rect.origin.x, rect.origin.y, aWidth, aHeight);
        bRect = CGRectMake(rect.origin.x + aWidth + sep, rect.origin.y, bWidth, bHeight);
    }
    else { // vertical layout
        if (total == 0.0) {
            aWidth = aHeight = bWidth = bHeight = 0.0;
            aRect = CGRectMake(rect.origin.x, rect.origin.y, 0.0, 0.0);
            bRect = CGRectMake(rect.origin.x, rect.origin.y + sep, 0.0, 0.0);
        }
        else {
            aWidth = bWidth = width;
            aHeight = ceil((height - sep) * aRatio);
            bHeight = height - sep - aHeight;
            aRect = CGRectMake(rect.origin.x, rect.origin.y, aWidth, aHeight);
            bRect = CGRectMake(rect.origin.x, rect.origin.y + aHeight + sep, bWidth, bHeight);
        }
    }

    [self calcNodePositions:aRect nodes:aArray width:aWidth height:aHeight depth:depth + 1 withCreate:createNode];
    [self calcNodePositions:bRect nodes:bArray width:bWidth height:bHeight depth:depth + 1 withCreate:createNode];
}

- (NSArray *)getData {
    NSArray *values = [dataSource valuesForTreemapView:self];
    NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:values.count];
    for (NSInteger i = 0; i < values.count; i++) {
        NSNumber *value = [values objectAtIndex:i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [dic setValue:[NSNumber numberWithInt:i] forKey:@"index"];
        [dic setValue:value forKey:@"value"];
        [nodes addObject:dic];
    }
    return nodes;
}

- (void)createNodes {
    NSArray *nodes = [self getData];
    if (nodes && nodes.count > 0) {
        [self calcNodePositions:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                          nodes:nodes
                          width:ceil(self.frame.size.width)
                         height:ceil(self.frame.size.height)
                          depth:0
                     withCreate:YES];
    }
}

- (void)resizeNodes {
    NSArray *nodes = [self getData];
    if (nodes && nodes.count > 0) {
        [self calcNodePositions:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                          nodes:nodes
                          width:ceil(self.frame.size.width)
                         height:ceil(self.frame.size.height)
                          depth:0
                     withCreate:NO];
    }
}

- (void)removeNodes {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark Public methods

- (void)reloadData {
    [self resizeNodes];
}

#pragma mark -
#pragma mark TreemapViewCell delegate

- (void)treemapViewCell:(TreemapViewCell *)treemapViewCell
           touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesBegan:withEvent:)]) {
        [delegate treemapView:self touchesBegan:touches withEvent:event];
    }
}

- (void)treemapViewCell:(TreemapViewCell *)treemapViewCell
       touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesCancelled:withEvent:)]) {
        [delegate treemapView:self touchesCancelled:touches withEvent:event];
    }
}

- (void)treemapViewCell:(TreemapViewCell *)treemapViewCell
           touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesEnded:withEvent:)]) {
        [delegate treemapView:self touchesEnded:touches withEvent:event];
    }
}

- (void)treemapViewCell:(TreemapViewCell *)treemapViewCell
           touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesMoved:withEvent:)]) {
        [delegate treemapView:self touchesMoved:touches withEvent:event];
    }
}

- (void)treemapViewCell:(TreemapViewCell *)treemapViewCell tapped:(NSInteger)index {
    if ([delegate respondsToSelector:@selector(treemapView:tapped:)]) {
        [delegate treemapView:self tapped:index];
    }
}

#pragma mark -
#pragma mark UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesBegan:withEvent:)]) {
        [delegate treemapView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesCancelled:withEvent:)]) {
        [delegate treemapView:self touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesEnded:withEvent:)]) {
        [delegate treemapView:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (delegate && [delegate respondsToSelector:@selector(treemapView:touchesMoved:withEvent:)]) {
        [delegate treemapView:self touchesMoved:touches withEvent:event];
    }
}

#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        initialized = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!initialized) {
        [self createNodes];
        initialized = YES;
    }
}

- (void)dealloc {
    [dataSource release];
    [delegate release];

    [super dealloc];
}

@end
