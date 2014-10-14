//
//  ViewController.h
//  TestUpload
//
//  Created by hutianyi100019 on 14-10-14.
//  Copyright (c) 2014年 wings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zzUploadFile.h"

@interface ViewController : UIViewController<zzUploadProcessDelegate>
{
}
@property (strong, nonatomic) IBOutlet UILabel *mypros;
- (IBAction)touch:(id)sender;
@end
