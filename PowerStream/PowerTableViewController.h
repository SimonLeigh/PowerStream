//
//  TableViewController.h
//  PowerStream
//
//  Created by Simon on 03/11/2014.
//  Copyright (c) 2014 SJL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerTableViewController : UITableViewController <NSStreamDelegate>
- (IBAction)fetchButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property NSMutableArray* powerMeasures;

@end
