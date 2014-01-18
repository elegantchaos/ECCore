//
//  NSOutlineView+ECCore.h
//  ECCore
//
//  Created by Sam Deane on 18/01/2014.
//  Copyright (c) 2014 Elegant Chaos. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSOutlineView (ECCore)

/**
 Return a simple expanded state.
 This consists of a list of the rows that are expanded, so it's not resilient if the order of the items has changed.
 
 @return A list of rows that were expaneded.
 */

- (id)simpleExpandedState;

/**
 Restore simple expanded state.
 We go through a list of rows expanding them.
 
 @param state A list of rows that were expaneded.
 */

- (void)setSimpleExpandedState:(id)state;

/**
 Save the simple expaneded state to the user defaults.
 We use the autosave key of the view, with something appended to it, as the key to save under.
*/

- (void)saveSimpleExpandedState;

/**
 Restore the simple expaneded state from the user defaults.
 We use the autosave key of the view, with something appended to it, as the key to save under.
 */

- (void)restoreSimpleExpandedState;

@end
