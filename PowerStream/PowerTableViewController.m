//
//  TableViewController.m
//  PowerStream
//
//  Created by Simon on 03/11/2014.
//  Copyright (c) 2014 SJL. All rights reserved.
//

#import "PowerTableViewController.h"
#import "ConnectViewController.h"
#import "PowerData.h"

@interface PowerTableViewController ()

@end

@implementation PowerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.powerMeasures = [[NSMutableArray alloc] init];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.powerMeasures count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *s = [[self.powerMeasures objectAtIndex:(9-indexPath.row)] asString];
    cell.textLabel.text = s;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"I'm in the segue");
    [outputStream close];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


// Handler for grabbing data and storing it
- (IBAction)fetchButton:(id)sender {
    NSString *response  = [NSString stringWithFormat:@"give:%@", @"10"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"pushed fetch button, writing to stream now");
    [outputStream write:[data bytes] maxLength:[data length]];
    
}
// Handler for networking events from the TCP stream
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"New bytes available!!");
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            NSMutableArray* tempA = (NSMutableArray*)[output componentsSeparatedByString: @"\n"];
                            NSLog(@"tempA is: %@", tempA);
                            [self populatePowerMeasures:tempA];
                            [self.tableView reloadData];
                            //NSLog(@"first entry is: %@", [[self.powerMeasures objectAtIndex:0] asString]);
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}

// Method to take an NSMutableArray of the rows, and split on spaces into our desired data structure
- (void) populatePowerMeasures: (NSMutableArray*)theRows {
    
    int i = 0;
    for( id row in theRows){
        NSLog(@"row is: %@", row);
        NSMutableArray* tempA = (NSMutableArray*)[row componentsSeparatedByString: @", "];
        
        // Test if the row has content
        if ( [tempA count] == 4){
            double tempDate = [[tempA objectAtIndex:0] doubleValue];
            double tempV = [[tempA objectAtIndex:3] doubleValue];
            double tempP = [[tempA objectAtIndex:1] doubleValue];
            double tempRP = [[tempA objectAtIndex:2] doubleValue];
        
            PowerData* tempPD = [[PowerData alloc] init];
            tempPD.voltage = [NSNumber numberWithDouble:tempV];
            tempPD.activePower = [NSNumber numberWithDouble:tempP];
            tempPD.reactivePower = [NSNumber numberWithDouble:tempRP];
            tempPD.datetime = [NSNumber numberWithDouble:tempDate];
        
            NSLog(@"tempPd is: %@", [tempPD asString]);
            if ([self.powerMeasures count] == 10){
                [self.powerMeasures replaceObjectAtIndex:i withObject:tempPD];
            }
            else {
                [self.powerMeasures addObject:tempPD];
            }
        }
        ++i;
        
    }
}


@end
