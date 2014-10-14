//
//  ViewController.m
//  TestUpload
//
//  Created by hutianyi100019 on 14-10-14.
//  Copyright (c) 2014年 wings. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touch:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"111" ofType:@"jpg"];
    NSLog(@"要上传的文件路径:%@",filePath);
    NSString *urlStr = @"http://app.xtox.net:8889/Controllers/upload.ashx";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:filePath,@"filepath",@"sss.jpg",@"serverfilename", nil];
    
    
    zzUploadFile *upload = [[zzUploadFile alloc]init];
    [upload uploadFileWithProcess:urlStr filedic:dic delegate:self];
//    self.mypros.text = [upload uploadFile:urlStr filedic:dic];
}

-(void)zzUploadProcess:(float)process
{
    self.mypros.text = [NSString stringWithFormat:@"%d%%",(int)(process*100)];
}
-(void)zzGetResponse:(NSString*)response
{
    NSLog(@"上传完成:%@",response);
    self.mypros.text = response;
}
@end
