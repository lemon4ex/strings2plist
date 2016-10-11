//
//  main.m
//  string2plist
//
//  Created by lemon4ex on 16/7/7.
//  Copyright © 2016年 lemon4ex. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSString *exePath = [NSString stringWithUTF8String:argv[0]];
        
        if (argc < 3) {
            NSLog(@"Usage:%@ input_file output_file",exePath.lastPathComponent);
            return 0;
        }
        
        NSString *inputPath = [NSString stringWithUTF8String:argv[1]];
        if (![[NSFileManager defaultManager]fileExistsAtPath:inputPath]) {
            NSLog(@"输入文件 %@ 不存在",inputPath);
            return 0;
        }
        NSString *outputPath = [NSString stringWithUTF8String:argv[2]];
        
        if (!outputPath) {
             NSLog(@"Usage:%@ input_file output_file",exePath.lastPathComponent);
            return 0;
        }
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:outputPath]) {
            [[NSFileManager defaultManager]removeItemAtPath:outputPath error:nil];
        }
        
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:inputPath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"读取文件 %@ 失败 %@",inputPath,error);
            return 0;
        }
        
        NSLog(@"开始转换...");
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s*\"(.*?)\"\\s*=\\s*\"(.*?)\"\\s*;" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionAnchorsMatchLines error:nil];
        NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
        NSMutableDictionary *plist = [NSMutableDictionary dictionary];
        for (NSTextCheckingResult *check in matches) {
//            NSLog(@"%@=%@",[content substringWithRange:[check rangeAtIndex:1]],[content substringWithRange:[check rangeAtIndex:2]]);
            [plist setObject:[content substringWithRange:[check rangeAtIndex:2]] forKey:[content substringWithRange:[check rangeAtIndex:1]]];
        }
        [plist writeToFile:outputPath atomically:YES];
        
        NSLog(@"转换完成，%@",outputPath);
    }
    
    return 0;
}
