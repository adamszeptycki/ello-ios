//
//  S3UploadingService.swift
//  Ello
//
//  Created by Colin Gray on 3/3/2015.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Moya


class S3UploadingService: NSObject {
    typealias S3UploadSuccessCompletion = (url : String) -> ()

    var uploader : ElloS3?

    func upload(image : UIImage, filename: String, success: S3UploadSuccessCompletion, failure: ElloFailureCompletion?) {
        let data = UIImagePNGRepresentation(image)
        upload(data, filename: filename, contentType: "image/png", success: success, failure: failure)
    }

    func upload(data : NSData, filename: String, contentType: String, success: S3UploadSuccessCompletion, failure: ElloFailureCompletion?) {
        let endpoint = ElloAPI.AmazonCredentials
        ElloProvider.sharedProvider.elloRequest(endpoint,
            method: .GET,
            parameters: endpoint.defaultParameters,
            mappingType: .AmazonCredentialsType,
            success: { credentialsData, responseConfig in
                if let credentials = credentialsData as? AmazonCredentials {
                    self.uploader = ElloS3(credentials: credentials, filename: filename, data: data, contentType: contentType)
                        .onSuccess({ (data : NSData) in
                            let endpoint : String = credentials.endpoint
                            let prefix : String = credentials.prefix
                            success(url: "\(endpoint)/\(prefix)/\(filename)")
                        })
                        .onFailure({ (error : NSError) in
                            if let handler = failure {
                                handler(error: error, statusCode: nil)
                            }
                        })
                        .start()
                }
                else {
                    ElloProvider.unCastableJSONAble(failure)
                }
            },
            failure: failure
        )
    }
}