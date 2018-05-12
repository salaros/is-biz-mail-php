ARRAY_START_COMMENT := free email providers start
ARRAY_END_COMMENT := free email providers end

.PHONY: all

all: php

prepare:
	@mkdir -pv ./build
	@composer install

download: prepare
	@wget -q http://svn.apache.org/repos/asf/spamassassin/trunk/rules/20_freemail_domains.cf -O ./build/freemail_domains.cf
	@grep -Ei 'freemail_domains (.*)$$' ./build/freemail_domains.cf | grep -oP 'freemail_domains \K.*' > ./build/freemail_domains.txt
	sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n/",\n"/g' -i ./build/freemail_domains.txt
	sed -e 's/ /", "/g' -i ./build/freemail_domains.txt
	echo "\"$$(cat ./build/freemail_domains.txt)\"" > ./build/freemail_domains.txt

php: download
	@sed '/$(ARRAY_START_COMMENT)/,/$(ARRAY_END_COMMENT)/{//!d}' -i ./src/php/FreeMailChecker.php
	@sed '/free email providers start/ r ./build/freemail_domains.txt' -i ./src/php/FreeMailChecker.php
	@sed 's/^"/                "/' -i ./src/php/FreeMailChecker.php
