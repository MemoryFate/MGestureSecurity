//
//  XNBBaseResponseModel.h
//  AFNetworking
//
//  Created by 江红胡 on 2017/11/8.
//

#import "XNBBaseItem.h"

@interface XNBResponseResultModel : XNBBaseItem

@property (nonatomic, copy) NSString *resultAppName;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, copy) NSString *code;

@end


@interface XNBBaseResponseModel : XNBBaseItem

@property (nonatomic, strong) XNBResponseResultModel *result;

@end
