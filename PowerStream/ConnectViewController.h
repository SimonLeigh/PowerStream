//
//  ViewController.h
//  PowerStream
//
//  Created by Simon on 30/10/2014.
//  Copyright (c) 2014 SJL. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInputStream *inputStream;
NSOutputStream *outputStream;

@interface ConnectViewController : UIViewController <NSStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputServerField;
@property (strong, nonatomic) IBOutlet UIView *connectView;
- (IBAction)joinServer:(id)sender;



@end

