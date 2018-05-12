ARRAY_START_COMMENT := free email providers start
ARRAY_END_COMMENT := free email providers end

.PHONY: all

all: php

clean:
	@find ./build -mindepth 1 -delete

prepare:
	@mkdir -pv ./build

download: prepare
	@wget -q http://svn.apache.org/repos/asf/spamassassin/trunk/rules/20_freemail_domains.cf -O ./build/freemail_domains.cf
	@grep -Ei 'freemail_domains (.*)$$' ./build/freemail_domains.cf | grep -oP 'freemail_domains \K.*' > ./build/freemail_domains.txt
	@sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n/",\n"/g' -i ./build/freemail_domains.txt
	@sed -e 's/ /", "/g' -i ./build/freemail_domains.txt
	@echo "\"$$(cat ./build/freemail_domains.txt)\"" > ./build/freemail_domains.txt

php: download
	@sed '/$(ARRAY_START_COMMENT)/,/$(ARRAY_END_COMMENT)/{//!d}' -i ./src/php/FreeMailChecker.php
	@sed '/$(ARRAY_START_COMMENT)/ r ./build/freemail_domains.txt' -i ./src/php/FreeMailChecker.php
	@sed 's/^"/                "/' -i ./src/php/FreeMailChecker.php

node: download
	@sed '/$(ARRAY_START_COMMENT)/,/$(ARRAY_END_COMMENT)/{//!d}' -i ./src/node/index.js
	@sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n//g' ./build/freemail_domains.txt > ./build/freemail_domains.js
	@echo "    $$(cat ./build/freemail_domains.js)" > ./build/freemail_domains.js
	@sed '/$(ARRAY_START_COMMENT)/ r ./build/freemail_domains.js' -i ./src/node/index.js

javascript: node
	@sed '/(function(global){/,/})((/{//!d}' -i ./src/javascript/FreeMailChecker.js
	@sed 's/^/    /' ./src/node/index.js > ./build/FreeMailChecker.js
	@sed 's/^    $$//' -i ./build/FreeMailChecker.js
	@sed '/(function(global){/r ./build/FreeMailChecker.js' -i ./src/javascript/FreeMailChecker.js
	@sed 's/module.exports/global.FreeMailChecker/g' -i ./src/javascript/FreeMailChecker.js
