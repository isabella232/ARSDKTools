LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := json
LOCAL_DESCRIPTION := JSON-C
LOCAL_CATEGORY_PATH := libs

LOCAL_AUTOTOOLS_VERSION := 0.9
LOCAL_AUTOTOOLS_ARCHIVE := json-c-$(LOCAL_AUTOTOOLS_VERSION).tar.gz
LOCAL_AUTOTOOLS_SUBDIR := json-c-$(LOCAL_AUTOTOOLS_VERSION)

LOCAL_EXPORT_LDLIBS := -ljson

ifdef ARSDK_BUILD_FOR_APP

LOCAL_AUTOTOOLS_PATCHES := \
	avoid-version.patch

LOCAL_AUTOTOOLS_CONFIGURE_ARGS := \
	--disable-static \
	--enable-shared \
	INSTALL="/usr/bin/install -C"

ifeq ("$(TARGET_OS_FLAVOUR)","android")

LOCAL_AUTOTOOLS_CONFIGURE_ARGS += \
	LIBS=" -llog -lz"

ifeq ($(ARSDK_BUILD_ANDROID_ARCH), armeabi)
LOCAL_AUTOTOOLS_CONFIGURE_ARGS += \
	--host=arm-linux-androideabi \
	CFLAGS=" -march=armv5te"

else ifeq ($(ARSDK_BUILD_ANDROID_ARCH), armeabi-v7a)
LOCAL_AUTOTOOLS_CONFIGURE_ARGS += \
	--host=arm-linux-androideabi \
	CFLAGS=" -march=armv7-a"

else ifeq ($(ARSDK_BUILD_ANDROID_ARCH), mips)
LOCAL_AUTOTOOLS_CONFIGURE_ARGS += \
	--host=mipsel-linux-androideabi

else ifeq ($(ARSDK_BUILD_ANDROID_ARCH), x86)
LOCAL_AUTOTOOLS_CONFIGURE_ARGS += \
	--host=i686-linux-android

else
$(error unknown ARSDK_BUILD_ANDROID_ARCH $(ARSDK_BUILD_ANDROID_ARCH))
endif

endif

# User define command to be launch before configure step.
# Generates files used by configure
define LOCAL_AUTOTOOLS_CMD_POST_UNPACK
	$(Q) cd $(PRIVATE_SRC_DIR) && autoreconf -fiv
endef

endif

# Don't redefine alloc functions
LOCAL_AUTOTOOLS_CONFIGURE_ENV := \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes \

include $(BUILD_AUTOTOOLS)
