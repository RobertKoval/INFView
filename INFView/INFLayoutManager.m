//
//  INFLayoutManager.m
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFLayoutManager.h"
#import "INFSimpleLayoutStrategy.h"

@interface INFLayoutManager()

@property (nonatomic) NSInteger numberOfViews;
@property (strong, nonatomic) NSArray<INFViewLayoutAttributes*>* layoutAttributes;
@property (nonatomic) NSInteger contentSpan;
@property (nonatomic) BOOL needsReArrange;

@end

@implementation INFLayoutManager

- (instancetype) initWithLayoutStrategyType:(INFLayoutStrategyType)layoutStrategyType {
    self = [super init];
    if (self != nil) {
        if (layoutStrategyType == INFLayoutStrategyTypeSimple) {
            self.layoutStrategy = [INFSimpleLayoutStrategy new];
        }
    }
    return self;
}

- (instancetype) init {
    return [self initWithLayoutStrategyType:INFLayoutStrategyTypeSimple];
}

- (void)arrangeViews {
    [self updateArrangedViewsForNewContentOffset:CGPointMake(0.0, 0.0)];
}

- (NSMutableArray<NSValue *> *)getArrangedViewSizes {
    NSInteger numberOfViews = [self.layoutDataSource numberOfArrangedViews];
    NSMutableArray<NSValue*>* viewSizes = [NSMutableArray new];
    for (NSInteger index = 0; index < numberOfViews; index++) {
        CGSize size = [self.layoutDataSource sizeForViewAtIndex:index];
        [viewSizes addObject:[NSValue valueWithCGSize:size]];
    }
    return viewSizes;
}

- (INFViewLayout *)calculateLayoutForContentOffset:(const CGPoint *)contentOffset {
    self.layoutStrategy.scrollViewSize = self.scrollViewSize;
    self.layoutStrategy.sizesOfArrangedViews = [self getArrangedViewSizes];
    self.layoutStrategy.contentOffset = *contentOffset;

    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViews];
    return layout;
}

- (void)updateArrangedViewsForNewContentOffset:(CGPoint)contentOffset {
    INFViewLayout * layout = [self calculateLayoutForContentOffset:&contentOffset];

    [self.layoutTarget updateContentSize:layout.contentSize];
    if (contentOffset.x != layout.contentOffset.x || contentOffset.y != layout.contentOffset.y) {
        [self.layoutTarget updateContentOffset:layout.contentOffset];
    }
    for (INFViewLayoutAttributes* attributes in layout.viewsAttributes) {
        [self.layoutTarget setArrangedViewAttributes:attributes];
    }
}

- (void)setOrientation:(INFOrientation)orientation {
    self.layoutStrategy.orientation = orientation;
}

- (INFOrientation)orientation {
    return self.layoutStrategy.orientation;
}

@end
