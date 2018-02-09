//
//  INFLayoutManager.m
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFLayoutManager.h"

@interface INFLayoutManager()

@property (nonatomic) NSInteger numberOfViews;
@property (strong, nonatomic) NSArray<INFViewLayoutAttributes*>* layoutAttributes;
@property (nonatomic) NSInteger contentSpan;
@property (nonatomic) BOOL needsReArrange;

@end

@implementation INFLayoutManager

- (void)arrangeViews {
    
    self.contentSpan = 0;
    self.numberOfViews = [self.layoutTarget numberOfArrangedViews];
    
    NSMutableArray<INFViewLayoutAttributes*>* layoutAttributes = [NSMutableArray new];
    for (NSInteger i = 0; i < self.numberOfViews; i++) {
        INFViewLayoutAttributes* attributes = [INFViewLayoutAttributes new];
        attributes.index = i;
        attributes.containerSize = self.viewSize;
        
        CGFloat subViewPosition = self.contentSpan;
        attributes.center = CGPointMake(subViewPosition + attributes.containerSize.width / 2.0, attributes.containerSize.height / 2.0);
        [layoutAttributes addObject:attributes];
        
        self.contentSpan = subViewPosition + attributes.containerSize.width;
    }
    self.layoutAttributes = layoutAttributes;
    
    CGSize contentSize = CGSizeMake(self.contentSpan, self.viewSize.height);
    
    if (self.contentSpan > self.viewSize.width) {
        contentSize = CGSizeMake(self.contentSpan + self.viewSize.width * 2.0, self.viewSize.height);
        for (INFViewLayoutAttributes* attributes in self.layoutAttributes) {
            attributes.center = CGPointMake(attributes.center.x + self.viewSize.width, attributes.center.y);
        }
    }
    
    for (INFViewLayoutAttributes* attributes in self.layoutAttributes) {
        [self.layoutTarget setArrangedViewAttributes:attributes];
    }
    
    [self.layoutTarget updateContentSize:contentSize];
}

- (void)reArrangeIfNeeded {
    if (self.needsReArrange) {
        [self arrangeViews];
    }
}

- (void)calculateLayoutChangesForNewOffset {
    if (self.contentSpan > self.viewSize.width) {

        if (self.contentOffset.x < self.viewSize.width / 2.0) {
            _contentOffset = CGPointMake(self.viewSize.width + self.contentSpan - self.contentOffset.x, self.contentOffset.y);
            [self.layoutTarget updateContentOffset:self.contentOffset];
            
        } else if (self.contentOffset.x > 1 + self.contentSpan + self.viewSize.width / 2.0) {
            _contentOffset = CGPointMake(self.contentOffset.x - self.contentSpan, self.contentOffset.y);
            [self.layoutTarget updateContentOffset:self.contentOffset];
        }
        
        INFViewLayoutAttributes* firstItemAttributes = self.layoutAttributes.firstObject;
        INFViewLayoutAttributes* lastItemAttributes = self.layoutAttributes.lastObject;
        
        if (self.contentOffset.x > self.contentSpan - self.viewSize.width) {
            lastItemAttributes.center = CGPointMake(self.viewSize.width + self.contentSpan - lastItemAttributes.containerSize.width / 2.0, lastItemAttributes.center.y);
            firstItemAttributes.center = CGPointMake(self.viewSize.width + self.contentSpan + firstItemAttributes.containerSize.width / 2.0, firstItemAttributes.center.y);
            
            [self.layoutTarget setArrangedViewAttributes:firstItemAttributes];
            [self.layoutTarget setArrangedViewAttributes:lastItemAttributes];
            
        } else if (self.contentOffset.x < self.viewSize.width * 2.0) {
            lastItemAttributes.center = CGPointMake(self.viewSize.width - lastItemAttributes.containerSize.width / 2.0, lastItemAttributes.center.y);
            firstItemAttributes.center = CGPointMake(self.viewSize.width + firstItemAttributes.containerSize.width / 2.0, firstItemAttributes.center.y);
            
            [self.layoutTarget setArrangedViewAttributes:firstItemAttributes];
            [self.layoutTarget setArrangedViewAttributes:lastItemAttributes];
        }
    }
}

- (void)setContentOffset:(CGPoint)contentOffset {
    _contentOffset = contentOffset;
    [self calculateLayoutChangesForNewOffset];
}

- (void)setViewSize:(CGSize)viewSize {
    _viewSize = viewSize;
    self.needsReArrange = YES;
}

@end
