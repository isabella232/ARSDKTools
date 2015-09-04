ifdef ARSDK_BUILD_FOR_APP

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := curl
LOCAL_DESCRIPTION := cURL
LOCAL_CATEGORY_PATH := libs

LOCAL_AUTOTOOLS_VERSION := 7.36.0
LOCAL_AUTOTOOLS_ARCHIVE := curl-$(LOCAL_AUTOTOOLS_VERSION).tar.bz2
LOCAL_AUTOTOOLS_SUBDIR := curl-$(LOCAL_AUTOTOOLS_VERSION)
LOCAL_AUTOTOOLS_PATCHES := \
	0001-ARSDK-Allow-mixed-32-64bits-builds.patch \
	0002-ARSDK-Allow-iOS-x86_64-builds-for-simulators.patch \
	avoid-version.patch

LOCAL_EXPORT_LDLIBS := -lcurl
LOCAL_LIBRARIES := libressl

LOCAL_AUTOTOOLS_CONFIGURE_ARGS := \
	--disable-static \
	--enable-shared \
	--disable-ares \
	--disable-file \
	--disable-ldap \
	--disable-ldaps \
	--disable-rtsp \
	--disable-proxy \
	--disable-dict \
	--disable-telnet \
	--disable-tftp \
	--disable-pop3 \
	--disable-imap \
	--disable-smtp \
	--disable-gopher \
	--disable-manual \
	--disable-verbose \
	--disable-sspi \
	--disable-ntlm-wb \
	--disable-tls-srp \
	--without-winssl \
	--without-gnutls \
	--without-polarssl \
	--without-cyassl \
	--without-nss \
	--without-axtls \
	--without-ca-bundle \
	--without-libmetalink \
	--without-libssh2 \
	--without-librtmp \
	--without-winidn \
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
	$(Q) cd $(PRIVATE_SRC_DIR) && rm src/tool_hugehelp.c && autoreconf -fiv
endef

# Don't redefine alloc functions
LOCAL_AUTOTOOLS_CONFIGURE_ENV := \
	ac_cv_func_malloc_0_nonnull=yes \
	ac_cv_func_realloc_0_nonnull=yes \

include $(BUILD_AUTOTOOLS)

endif
