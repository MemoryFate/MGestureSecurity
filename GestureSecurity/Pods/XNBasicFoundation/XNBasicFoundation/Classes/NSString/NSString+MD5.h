//
//  NSString+MD5.h
//  XNBasicFoundation
//
//  Created by 江红胡 on 2017/10/23.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/**
 *   数据加密
 *   @param string 加密前
 *   @return 加密后
 */
- (NSString *)xnb_md5:(NSString *)string;

@end
