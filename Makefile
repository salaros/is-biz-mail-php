DOMAINS_LIST	:= ./build/freemail_domains.txt
DOMAINS_START	:= free email providers start
DOMAINS_END		:= free email providers end

NODE_SRC		:= ./src/node/index.js
PHP_SRC			:= ./src/php/IsBizMail.php
JS_SRC 			:= ./src/javascript/is-biz-mail.js
JS_TEMP_SRC		:= ./build/freemail_domains.js
JS_CLOSURE 		:= (function(global){
JS_CLOSURE_END 	:= })((

.PHONY: all

all: php javascript

clean:
	@find ./build -mindepth 1 -delete

prepare:
	@mkdir -pv ./build

download: prepare
	@wget -q http://svn.apache.org/repos/asf/spamassassin/trunk/rules/20_freemail_domains.cf -O $(DOMAINS_LIST).tmp
	@grep -Ei 'freemail_domains (.*)$$' $(DOMAINS_LIST).tmp | grep -oP 'freemail_domains \K.*' > $(DOMAINS_LIST)
	@sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n/",\n"/g' -i $(DOMAINS_LIST)
	@sed -e 's/ /", "/g' -i $(DOMAINS_LIST)
	@echo "\"$$(cat $(DOMAINS_LIST))\"" > $(DOMAINS_LIST)

php: download
	@sed '/$(DOMAINS_START)/,/$(DOMAINS_END)/{//!d}' -i $(PHP_SRC)
	@sed '/$(DOMAINS_START)/ r $(DOMAINS_LIST)' -i $(PHP_SRC)
	@sed 's/^"/                "/' -i $(PHP_SRC)

node: download
	@sed '/$(DOMAINS_START)/,/$(DOMAINS_END)/{//!d}' -i $(NODE_SRC)
	@sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n//g' $(DOMAINS_LIST) > $(JS_TEMP_SRC)
	@echo "    $$(cat $(JS_TEMP_SRC))" > $(JS_TEMP_SRC)
	@sed '/$(DOMAINS_START)/ r $(JS_TEMP_SRC)' -i $(NODE_SRC)

javascript: node
	@sed '/$(JS_CLOSURE)/,/$(JS_CLOSURE_END)/{//!d}' -i $(JS_SRC)
	@sed 's/^/    /' $(NODE_SRC) > $(JS_TEMP_SRC)
	@sed 's/^    $$//' -i $(JS_TEMP_SRC)
	@sed '/$(JS_CLOSURE)/r $(JS_TEMP_SRC)' -i $(JS_SRC)
	@sed 's/module.exports/global.isBizMail/g' -i $(JS_SRC)
