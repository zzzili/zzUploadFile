//
//  zzUploadFile.m
//  TestUpload
//
//  Created by hutianyi100019 on 14-10-14.
//  Copyright (c) 2014年 wings. All rights reserved.
//

#import "zzUploadFile.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

@implementation zzUploadFile

-(NSString*)uploadFile:(NSString*)urlStr filedic:(NSDictionary *)filedic
{
    return [self upload:urlStr filedic:filedic withProcess:NO];
}
-(NSString*)uploadFileWithProcess:(NSString*)urlStr filedic:(NSDictionary *)filedic delegate:(id)delegate
{
    self.delegate = delegate;
    return [self upload:urlStr filedic:filedic withProcess:YES];
}

/////////////////////////////////////
-(NSString*)upload:(NSString*)urlStr filedic:(NSDictionary *)filedic withProcess:(BOOL)_withProcess
{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSString* URL = urlStr;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:0];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的文件
    NSData *data = [NSData dataWithContentsOfFile:[filedic objectForKey:@"filepath"]];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明文件字段，文件名
    [body appendFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@\"\r\n",[filedic objectForKey:@"serverfilename"]];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: %@\r\n\r\n",[self GetContentType:[filedic objectForKey:@"serverfilename"]]];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将file的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    ///开始上传
    if(_withProcess)
    {
        self.fileUploadOp = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        __block zzUploadFile *blockSelf = self;
        [self.fileUploadOp setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            CGFloat progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite;
            NSLog(@"is uploading %f",progress);
            dispatch_async(dispatch_get_main_queue(), ^{
               [blockSelf.delegate zzUploadProcess:progress];
            });
        }];
        
        [self.fileUploadOp setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf.delegate zzGetResponse:blockSelf.fileUploadOp.responseString];
            });
        }];
        
        [self.fileUploadOp start];
        return @"开始上传";
    }
    else
    {
        [NSURLConnection connectionWithRequest:request delegate:self];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        return [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    }
}
-(NSString*)GetContentType:(NSString*)filename{
    if ([filename hasSuffix:@".avi"]) {
        return @"video/avi";
    }
    else if([filename hasSuffix:@".bmp"])
    {
        return @"application/x-bmp";
    }
    else if([filename hasSuffix:@"jpeg"])
    {
        return @"image/jpeg";
    }
    else if([filename hasSuffix:@"jpg"])
    {
        return @"image/jpeg";
    }
    else if([filename hasSuffix:@"png"])
    {
        return @"image/x-png";
    }
    else if([filename hasSuffix:@"mp3"])
    {
        return @"audio/mp3";
    }
    else if([filename hasSuffix:@"mp4"])
    {
        return @"video/mpeg4";
    }
    else if([filename hasSuffix:@"rmvb"])
    {
        return @"application/vnd.rn-realmedia-vbr";
    }
    else if([filename hasSuffix:@"txt"])
    {
        return @"text/plain";
    }
    else if([filename hasSuffix:@"xsl"])
    {
        return @"application/x-xls";
    }
    else if([filename hasSuffix:@"xslx"])
    {
        return @"application/x-xls";
    }
    else if([filename hasSuffix:@"xwd"])
    {
        return @"application/x-xwd";
    }
    else if([filename hasSuffix:@"doc"])
    {
        return @"application/msword";
    }
    else if([filename hasSuffix:@"docx"])
    {
        return @"application/msword";
    }
    else if([filename hasSuffix:@"ppt"])
    {
        return @"application/x-ppt";
    }
    else if([filename hasSuffix:@"pdf"])
    {
        return @"application/pdf";
    }
    return nil;
}
@end
