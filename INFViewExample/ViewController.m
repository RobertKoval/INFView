//
//  ViewController.m
//  INFViewExample
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "ViewController.h"
#import <INFView/INFView.h>

@interface ViewController () <INFViewDataSource>

@property (weak, nonatomic) IBOutlet INFScrollView *infView;

@property (strong, nonatomic) NSArray<UIView*>* arrangedViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrangedViews = @[
        [self createViewWithColor:UIColor.redColor],
        [self createViewWithColor:UIColor.greenColor],
        [self createViewWithColor:UIColor.blueColor],
        [self createViewWithColor:UIColor.yellowColor],
        [self createViewWithColor:UIColor.orangeColor]
        ];

    self.infView.dataSource = self;
}
- (UIView*)createViewWithColor:(UIColor*)color {
    CGRect frame = CGRectMake(0, 0, 100, 100);
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

#pragma mark - INFViewDataSource

- (NSInteger)numberOfSubViewsInINFView:(INFScrollView *)infView {
    return self.arrangedViews.count;
}

- (UIView*)infView:(INFScrollView *)infView subViewAtIndex:(NSInteger)index {
    return self.arrangedViews[index];
}

@end
