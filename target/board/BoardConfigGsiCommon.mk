# BoardConfigGsiCommon.mk
#
# Common compile-time definitions for GSI
# Builds upon the mainline config.
#

include build/make/target/board/BoardConfigMainlineCommon.mk

# This flag is set by mainline but isn't desired for GSI.
BOARD_USES_SYSTEM_OTHER_ODEX :=

# GSIs are historically released in sparse format.
# Some vendors' bootloaders don't work properly with raw format images. So
# we explicit specify this need below (even though it's the current default).
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

# Enable dynamic system image size and reserved 64MB in it.
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 67108864

# Android Verified Boot (AVB):
#   Set AVB_VBMETA_IMAGE_FLAGS_VERIFICATION_DISABLED (--flag 2) in
#   vbmeta.img to disable AVB verification.
#
# To disable AVB for GSI, use the vbmeta.img and the GSI together.
# To enable AVB for GSI, include the GSI public key into the device-specific
# vbmeta.img.
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 2

# Enable chain partition for system.
BOARD_AVB_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
# GSI is always userdebug and needs a couple of properties taking precedence
# over those set by the vendor.
TARGET_SYSTEM_PROP := build/make/target/board/gsi_system.prop
endif

# Android generic system image always create metadata partition
BOARD_USES_METADATA_PARTITION := true

# Set this to create /cache mount point for non-A/B devices that mounts /cache.
# The partition size doesn't matter, just to make build pass.
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 16777216
