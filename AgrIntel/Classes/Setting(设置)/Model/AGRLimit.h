//
//  AGRLimit.h
//  AgrIntel
//
//  Created by 实验室 on 2017/8/22.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGRLimit : NSObject

@property (nonatomic, copy) NSString *maxtem;
@property (nonatomic, copy) NSString *mintem;
@property (nonatomic, copy) NSString *maxhum;
@property (nonatomic, copy) NSString *minhum;
@property (nonatomic, copy) NSString *maxlight;
@property (nonatomic, copy) NSString *minlight;

@end
