//
//  DYFMessage.h
//  微信
//
//  Created by 邓云方 on 15/10/13.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYFMessage : NSObject
@property(strong ,nonatomic) NSString * username;
@property(strong ,nonatomic) NSString * date;
@property(strong ,nonatomic) NSString * time;
@property(strong ,nonatomic) NSString * body;
@property(strong ,nonatomic) NSString * me;
@property(assign ,nonatomic) int flag;
@end
