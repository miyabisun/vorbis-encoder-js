LIBOGG_VER := 1.3.2
LIBVORBIS_VER := 1.3.5
LIBOGG := libogg-$(LIBOGG_VER)
LIBVORBIS := libvorbis-$(LIBVORBIS_VER)
BASE_URL := http://downloads.xiph.org/releases
LIBOGG_URL := $(BASE_URL)/ogg/$(LIBOGG).tar.gz
LIBVORBIS_URL := $(BASE_URL)/vorbis/$(LIBVORBIS).tar.gz
TMP_LIBOGG_DIR := tmp/$(LIBOGG)
TMP_LIBVORBIS_DIR := tmp/$(LIBVORBIS)
LIBVORBIS_OUTPUT_DIR = tmp/compiled/$(LIBVORBIS)
LIBOGG_OUTPUT_DIR := tmp/compiled/$(LIBOGG)
SRC_OUTPUT_DIR := tmp/compiled/src

INCLUDES :=\
 -I include\
 -I $(TMP_LIBOGG_DIR)/include\
 -I $(TMP_LIBVORBIS_DIR)/include\
 -I $(TMP_LIBVORBIS_DIR)/lib
EMCC_COMPILE_OPTIONS :=\
 -O3\
 -ffast-math\
 $(INCLUDES)
EMCC_LINK_OPTIONS :=\
 -s ALLOW_MEMORY_GROWTH=0\
 -s ASM_JS=1\
 -s EXPORTED_FUNCTIONS=@src/exports.json\
 --pre-js src/pre.js\
 --post-js src/post.js

LIBOGG_FILES :=\
 bitwise.c\
 framing.c
LIBVORBIS_FILES :=\
 analysis.c\
 bitrate.c\
 block.c\
 codebook.c\
 envelope.c\
 floor1.c\
 info.c\
 lpc.c\
 mapping0.c\
 mdct.c\
 psy.c\
 registry.c\
 res0.c\
 sharedbook.c\
 smallft.c\
 vorbisenc.c\
 window.c
SRC_FILES := encoder.c
TARGET_SOURCES := $(strip \
 $(foreach file,$(LIBOGG_FILES),$(LIBOGG_OUTPUT_DIR)/$(basename $(file)).o)\
 $(foreach file,$(LIBVORBIS_FILES),$(LIBVORBIS_OUTPUT_DIR)/$(basename $(file)).o)\
 $(foreach file,$(SRC_FILES),$(SRC_OUTPUT_DIR)/$(basename $(file)).o)\
)
DEST := dist/libvorbis.js

all: $(DEST)
	@echo

$(DEST): $(TARGET_SOURCES)
	@mkdir -p dist
	emcc -01 $(EMCC_LINK_OPTIONS) -o $(DEST) $(TARGET_SOURCES)

$(LIBOGG_OUTPUT_DIR)/%.o: $(TMP_LIBOGG_DIR)/src
	@mkdir -p $(LIBOGG_OUTPUT_DIR)
	emcc $(EMCC_COMPILE_OPTIONS) -o $@ $(TMP_LIBOGG_DIR)/src/$(basename $(notdir $@)).c

$(LIBVORBIS_OUTPUT_DIR)/%.o: $(TMP_LIBVORBIS_DIR)/lib
	@mkdir -p $(LIBVORBIS_OUTPUT_DIR)
	emcc $(EMCC_COMPILE_OPTIONS) -o $@ $(TMP_LIBVORBIS_DIR)/lib/$(basename $(notdir $@)).c

$(SRC_OUTPUT_DIR)/%.o:
	@mkdir -p $(SRC_OUTPUT_DIR)
	emcc $(EMCC_COMPILE_OPTIONS) -o $@ src/$(basename $(notdir $@)).c

$(TMP_LIBOGG_DIR)/src: $(TMP_LIBOGG_DIR)

$(TMP_LIBOGG_DIR):
	@mkdir -p tmp
	curl $(LIBOGG_URL) -o $(TMP_LIBOGG_DIR).tar.gz
	tar zxf $(TMP_LIBOGG_DIR).tar.gz -C tmp

$(TMP_LIBVORBIS_DIR)/lib: $(TMP_LIBVORBIS_DIR)

$(TMP_LIBVORBIS_DIR):
	@mkdir -p tmp
	curl $(LIBVORBIS_URL) -o $(TMP_LIBVORBIS_DIR).tar.gz
	tar zxf $(TMP_LIBVORBIS_DIR).tar.gz -C tmp

clean:
	rm -rf tmp
	rm -f $(DEST)

