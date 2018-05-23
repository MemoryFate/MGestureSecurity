//
//  UIImage+Rotate.h
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/10/12.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

/** 纠正图片的方向 */
- (UIImage *)xnb_fixOrientation:(UIImage *)aImage;

/** 按给定的方向旋转图片 */
- (UIImage *)xnb_rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

@end
