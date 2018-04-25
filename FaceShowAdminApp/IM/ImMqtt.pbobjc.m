// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ImMqtt.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "ImMqtt.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - ImMqttRoot

@implementation ImMqttRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - ImMqttRoot_FileDescriptor

static GPBFileDescriptor *ImMqttRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - ImMqtt

@implementation ImMqtt

@dynamic imEvent;
@dynamic reqId;
@dynamic bodyArray, bodyArray_Count;

typedef struct ImMqtt__storage_ {
  uint32_t _has_storage_[1];
  int32_t imEvent;
  NSString *reqId;
  NSMutableArray *bodyArray;
} ImMqtt__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "imEvent",
        .dataTypeSpecific.className = NULL,
        .number = ImMqtt_FieldNumber_ImEvent,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ImMqtt__storage_, imEvent),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "reqId",
        .dataTypeSpecific.className = NULL,
        .number = ImMqtt_FieldNumber_ReqId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ImMqtt__storage_, reqId),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "bodyArray",
        .dataTypeSpecific.className = NULL,
        .number = ImMqtt_FieldNumber_BodyArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(ImMqtt__storage_, bodyArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ImMqtt class]
                                     rootClass:[ImMqttRoot class]
                                          file:ImMqttRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ImMqtt__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001\007\000\002\005\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
