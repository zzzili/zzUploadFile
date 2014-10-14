//
//  zzUploadFile.h
//  TestUpload
//
//  Created by zzzili——清雨小竹 on 14-10-14.
//  Copyright (c) 2014年 wings. All rights reserved.
//  联系QQ：825127671
//  关于服务器接收文件的代码我是用c#的ashx实现的
//
//  ************************************
//  filedic包含两个key
//     filepath:本地文件的绝对路径
//     serverfilename:要存到服务器上的文件的名字
//  ************************************



#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

//显示进度的代理
@protocol zzUploadProcessDelegate <NSObject>
-(void)zzUploadProcess:(float)process;
-(void)zzGetResponse:(NSString*)response;
@end


@interface zzUploadFile : NSObject<zzUploadProcessDelegate>
@property (strong,nonatomic) AFHTTPRequestOperation *fileUploadOp;
@property (strong,nonatomic) id delegate;

//上传文件：不需要显示进度
-(NSString*)uploadFile:(NSString*)urlStr filedic:(NSDictionary *)filedic;

//上传文件：需要显示进度（要实现zzUploadProcessDelegate）
-(NSString*)uploadFileWithProcess:(NSString*)urlStr filedic:(NSDictionary *)filedic delegate:(id)delegate;
@end
