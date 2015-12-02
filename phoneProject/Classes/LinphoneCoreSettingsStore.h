/* LinphoneCoreSettingsStore.h
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or   
 *  (at your option) any later version.                                 
 *                                                                      
 *  This program is distributed in the hope that it will be useful,     
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of      
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       
 *  GNU General Public License for more details.                
 *                                                                      
 *  You should have received a copy of the GNU General Public License   
 *  along with this program; if not, write to the Free Software         
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */  

#import <Foundation/Foundation.h>
#import "IASKSettingsStore.h"

#import "LinphoneManager.h"

@interface LinphoneCoreSettingsStore : IASKAbstractSettingsStore {
	@private
	NSDictionary *dict;
	NSDictionary *changedDict;
}

- (void)synchronizeAccount;
- (void)transformLinphoneCoreToKeys;


- (NSString*)stringForKey:(NSString*)key;       // 为了便于在外部通过这个值来获取用户名和id值。特意打开，实际上可能有更简单的方式

@end
