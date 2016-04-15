//
//  IPLocation.h
//  eCarry
//
//  Created by whde on 16/4/13.
//  Copyright © 2016年 Joybon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface IPLocation : NSObject
typedef void (^CompletionHandlerBlock)(NSString *ip, CLLocationCoordinate2D location, NSDictionary *info);

/**
 *  IP定位，数据不精准，只提供到市
 *  有定位信息后，将不会再执行IP定位
 */
+ (void)ipLoactionCompletionHandler:(CompletionHandlerBlock )handler;
@end
