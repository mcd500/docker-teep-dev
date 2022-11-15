OUT_DIR=/home/out
ROOTFS_DIR=/home/main/image

IMAGE_BIN=rpi3_sdimage_tftpboot.bin
BOOTLOADER_BIN=boot.img
ROOTFS_BIN=rootfs.ext4
IMAGE_SIZE=net

ifeq ($(SUDO_USER),)
USERNAME=$(USER)
else
USERNAME=$(SUDO_USER)
endif
DOCKER_ORG=aistcpsec

UPLOADED_IMAGE_BIN=optee_${IMAGE_BIN}
IMAGE_COMPRESSED=$(IMAGE_BIN:.bin=.tar.xz)
UPLOADED_IMAGE_COMPRESSED=$(UPLOADED_IMAGE_BIN:.bin=.tar.xz)

TARGET = bundle
ifneq ($(DEV),)
TARGET += write
endif

.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
	$(RM) $(IMAGE_BIN) $(BOOTLOADER_BIN) $(ROOTFS_BIN)

.PHONY: pull
pull:
	sudo apt-get update && sudo apt-get install -y fdisk sshpass
	docker pull aistcpsec/tee-dev:optee-3.10.0_rpi3_netboot_bootloader

.PHONY: write
write: $(IMAGE_BIN)
	dd if=$^ of=$(DEV) bs=4096 conv=fsync

# see https://stackoverflow.com/a/20318913
.PHONY: upload
upload: $(IMAGE_BIN) $(BOOTLOADER_BIN)
	tar -Jcf $(IMAGE_COMPRESSED) $^ || test $$? -eq 1
	sshpass -f $(VC707_PASSWD) scp -o "StrictHostKeyChecking no" \
	  $(IMAGE_COMPRESSED) vc707@192.168.100.100:/var/www/files/$(UPLOADED_IMAGE_COMPRESSED)

.PHONY: bundle
bundle: $(BOOTLOADER_BIN) $(IMAGE_BIN)
	./loopdev-run.sh $(IMAGE_BIN) ./write-image.sh $(BOOTLOADER_BIN)
	chown $(USERNAME):$(USERNAME) $(IMAGE_BIN)

# rpi3 supports only MBR(Citation needed)
$(IMAGE_BIN):
	dd if=/dev/zero of=$@ iflag=fullblock bs=512 count=70000
	cat "sfdisk_settings_$(IMAGE_SIZE)G" | sfdisk $@

$(BOOTLOADER_BIN):
	docker run --rm -v $(CURDIR):$(OUT_DIR) aistcpsec/tee-dev:optee-3.10.0_rpi3_netboot_bootloader \
	  sudo cp boot.img $(OUT_DIR)
