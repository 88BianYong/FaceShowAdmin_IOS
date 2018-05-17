// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: TopicMsg.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class TopicMsg_ContentDataProto;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - TopicMsgRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface TopicMsgRoot : GPBRootObject
@end

#pragma mark - TopicMsg

typedef GPB_ENUM(TopicMsg_FieldNumber) {
  TopicMsg_FieldNumber_Id_p = 1,
  TopicMsg_FieldNumber_BizSource = 2,
  TopicMsg_FieldNumber_TopicId = 3,
  TopicMsg_FieldNumber_SenderId = 4,
  TopicMsg_FieldNumber_SenderName = 5,
  TopicMsg_FieldNumber_ReqId = 6,
  TopicMsg_FieldNumber_ContentType = 7,
  TopicMsg_FieldNumber_ContentData = 8,
  TopicMsg_FieldNumber_SendTime = 9,
};

@interface TopicMsg : GPBMessage

@property(nonatomic, readwrite) int64_t id_p;

@property(nonatomic, readwrite) int32_t bizSource;

@property(nonatomic, readwrite) int64_t topicId;

@property(nonatomic, readwrite) int64_t senderId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *senderName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *reqId;

@property(nonatomic, readwrite) int32_t contentType;

@property(nonatomic, readwrite, strong, null_resettable) TopicMsg_ContentDataProto *contentData;
/** Test to see if @c contentData has been set. */
@property(nonatomic, readwrite) BOOL hasContentData;

@property(nonatomic, readwrite) int64_t sendTime;

@end

#pragma mark - TopicMsg_ContentDataProto

typedef GPB_ENUM(TopicMsg_ContentDataProto_FieldNumber) {
  TopicMsg_ContentDataProto_FieldNumber_Msg = 1,
  TopicMsg_ContentDataProto_FieldNumber_Rid = 2,
  TopicMsg_ContentDataProto_FieldNumber_Thumbnail = 3,
  TopicMsg_ContentDataProto_FieldNumber_ViewURL = 4,
  TopicMsg_ContentDataProto_FieldNumber_Width = 5,
  TopicMsg_ContentDataProto_FieldNumber_Height = 6,
};

@interface TopicMsg_ContentDataProto : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *msg;

@property(nonatomic, readwrite, copy, null_resettable) NSString *rid;

@property(nonatomic, readwrite, copy, null_resettable) NSString *thumbnail;

@property(nonatomic, readwrite, copy, null_resettable) NSString *viewURL;

@property(nonatomic, readwrite) int32_t width;

@property(nonatomic, readwrite) int32_t height;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)