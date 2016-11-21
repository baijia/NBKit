//
//  NBButton.h
//  NBKit
//
//  Created by MingLQ on 2015-10-21.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <UIKit/UIKit.h>

/** set gap between image and title, 0 by default */
@interface NBButton : UIButton

@property (nonatomic) CGFloat gapBetweenImageAndTitle;

@end

/** image on the top, title on the bottom */
@interface NBVerticalButton : NBButton

@end

/** title only */
@interface NBTitleButton : NBButton

@end
DEPRECATED_MSG_ATTRIBUTE("Use NBTitleButton instead.")
@interface NBTextButton : NBTitleButton

@end

/** image only */
@interface NBImageButton : NBButton

@end

/** move left, for the leftBarButtonItem only */
@interface NBLeftBarButton : NBButton

@end

/** move right, for the rightBarButtonItem only */
@interface NBRightBarButton : NBButton

@end
