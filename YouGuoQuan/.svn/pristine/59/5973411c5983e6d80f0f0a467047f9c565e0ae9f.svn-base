//
//  FaceSourceManager.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceSourceManager.h"
#import "ChatToolBarItem.h"

@implementation FaceSourceManager

//从持久化存储里面加载表情源
+ (NSArray *)loadFaceSource {
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = @[@"Resourse.bundle/emoji"];
    //, @"emotion",@"face",@"emotion",@"emotion",@"face",@"face",@"emotion",@"face", @"emotion",@"face", @"emotion"];
    
    for (int i = 0; i < sources.count; ++i) {
        NSString *plistName = sources[i];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:plistPath];
        
        FaceSubjectModel *subjectM = [[FaceSubjectModel alloc] init];
        if ([plistName isEqualToString:@"Resourse.bundle/emoji"]) {
            subjectM.faceSize = SubjectFaceSizeKindSmall;
            
            //            subjectM.subjectTitle = [NSString stringWithFormat:@"f%d", i];
            //            subjectM.subjectIcon = @"section0_emotion0";
        } else {
            subjectM.faceSize = SubjectFaceSizeKindMiddle;
            //            subjectM.subjectTitle = [NSString stringWithFormat:@"e%d", i];
            //            subjectM.subjectIcon = @"f_static_000";
        }
        
        NSMutableArray *modelsArr = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            FaceModel *fm = [[FaceModel alloc] init];
            [fm setValuesForKeysWithDictionary:dic];
            [modelsArr addObject:fm];
        }
        subjectM.faceModels = modelsArr;
        [subjectArray addObject:subjectM];
    }
    return subjectArray;
}

+ (NSArray<ChatToolBarItem *> *)loadToolBarItems {
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

@end
