//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Steve Proell on 3/19/15.
//  Copyright (c) 2015 Steve Proell. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(fromFilePathUrl fileUrl: NSURL, withTitle fileTitle: String) {
        filePathUrl = fileUrl
        title = fileTitle
    }
}