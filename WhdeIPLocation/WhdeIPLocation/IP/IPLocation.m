//
//  IPLocation.m
//  eCarry
//
//  Created by whde on 16/4/13.
//  Copyright © 2016年 Joybon. All rights reserved.
//

#import "IPLocation.h"

@interface IPLocation () {
    
}

@end
@implementation IPLocation
+ (void)ipLoactionCompletionHandler:(CompletionHandlerBlock )handler {
    // 抓取这个链接返回的IP信息
    NSURL *ipURL = [NSURL URLWithString:@"http://1212.ip138.com/ic.asp"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:ipURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        /*NSLog(@"%@", responseString);*/
        if (responseString) {
            NSError *error;
            NSString *regTags=@"[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            // 执行匹配IP的过程
            NSArray *matches = [regex matchesInString:responseString
                                              options:0
                                                range:NSMakeRange(0, [responseString length])];
            for (NSTextCheckingResult *match in matches) {
                NSString *ip = [responseString substringWithRange:[match rangeAtIndex:0]];
                
                // 根据IP去获取地理位置 广东 深圳 南山
                NSString *httpUrl = @"http://apis.baidu.com/apistore/iplookupservice/iplookup";
                NSString *httpArg = [NSString stringWithFormat:@"ip=%@&v=1.1", ip];
                NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
                NSURL *url = [NSURL URLWithString: urlStr];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
                [request setHTTPMethod: @"GET"];
                [request addValue: @"3549f9a7f0646649321e87c14394c349" forHTTPHeaderField: @"apikey"];
                NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (!error) {
                        if (!data) {
                            return;
                        }
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        if (dic) {
                            /*NSLog(@"%@", dic);*/
                            if ([dic[@"errNum"] integerValue]==0) {
                                NSDictionary *location = dic[@"retData"];
                                if ([location isKindOfClass:[NSDictionary class]]) {
                                    // 存储地理位置信息
                                    CLGeocoder *coder = [[CLGeocoder alloc] init];
                                    [coder geocodeAddressString:@"广东深圳南山" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                                        for (CLPlacemark *placemark in placemarks) {
                                            if (handler) {
                                                handler(ip, placemark.location.coordinate, location);
                                            }
                                            break;
                                        }
                                    }];
                                }
                            }
                        }
                    }
                }];
                [dataTask resume];
                break;
            }
        }
    }];
    [task resume];
}
@end
