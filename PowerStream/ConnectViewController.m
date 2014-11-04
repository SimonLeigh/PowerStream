//
//  ViewController.m
//  PowerStream
//
//  Created by Simon on 30/10/2014.
//  Copyright (c) 2014 SJL. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self initNetworkCommunication];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNetworkCommunication:(NSString*) host :(int) port {
//- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef) host, port, &readStream, &writeStream);
    inputStream = (__bridge_transfer NSInputStream *)readStream;
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream open];
    [outputStream open];
}

- (IBAction)joinServer:(id)sender {
    NSString *serverDetails = self.inputServerField.text;
    NSMutableArray *connDetails = (NSMutableArray*)[serverDetails componentsSeparatedByString: @":"];
    
    int port = [connDetails[1] intValue];
    NSString* server = connDetails[0];
    
    // Connect to server
    [self initNetworkCommunication:server :port];
    
    NSString *response  = [NSString stringWithFormat:@"iam:%@", @"simon"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}


@end