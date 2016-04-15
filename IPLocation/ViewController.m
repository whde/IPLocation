//
//  ViewController.m
//  IPLocation
//
//  Created by whde on 16/4/14.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "ViewController.h"
#import <WhdeIPLocation/IPLocation.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IPLocation ipLoactionCompletionHandler:^(NSString *ip, CLLocationCoordinate2D location, NSDictionary *info) {
        _label.text = [NSString stringWithFormat:@"IP:%@\n经度:%f\n纬度:%f", ip, location.longitude, location.latitude];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
