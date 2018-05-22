DOMAINS_LIST		:= ./build/freemail_domains.txt
DOMAINS_LIST_PLUS	:= ./src/not-found-in-spamassassin-list.txt
DOMAINS_START		:= free email providers start
DOMAINS_END			:= free email providers end

NODE_SRC		:= ./src/node/index.js
PHP_SRC			:= ./src/php/IsBizMail.php
DOTNET_SRC		:= ./src/dotnet/IsBizMail.cs
JS_SRC 			:= ./src/javascript/is-biz-mail.js
JS_TEMP_SRC		:= ./build/freemail_domains.js
JS_CLOSURE 		:= (function(global){
JS_CLOSURE_END 	:= })((

GIT_TAG			:= $(shell git describe --tags `git rev-list --tags --max-count=1`)

.PHONY: all

all: php javascript dotnet

clean:
	@find ./build -mindepth 1 -delete

prepare:
	@mkdir -pv ./build

download: prepare
	@wget -q http://svn.apache.org/repos/asf/spamassassin/trunk/rules/20_freemail_domains.cf -O $(DOMAINS_LIST).tmp
	@grep -Ei 'freemail_domains (.*)$$' $(DOMAINS_LIST).tmp | grep -oP 'freemail_domains \K.*' > $(DOMAINS_LIST)
	@sed '$$!{:a;N;s/\n/ /;ta}' $(DOMAINS_LIST_PLUS) > $(DOMAINS_LIST).plus # replace all new lines with a signle whitespace
	@sed 's/ /\n/6;P;D' -i $(DOMAINS_LIST).plus # Split a single line in multiple rows each containing maximum 6 domains
	@cat $(DOMAINS_LIST).plus >> $(DOMAINS_LIST) # Append the list of domains not found in SpamAssassin to the rest
	@sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n/",\n"/g' -i $(DOMAINS_LIST)
	@sed -e 's/ /", "/g' -i $(DOMAINS_LIST)
	@echo "\"$$(cat $(DOMAINS_LIST))\"," > $(DOMAINS_LIST)

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

dotnet: download
	@sed '/$(DOMAINS_START)/,/$(DOMAINS_END)/{//!d}' -i $(DOTNET_SRC)
	@sed '/$(DOMAINS_START)/ r $(DOMAINS_LIST)' -i $(DOTNET_SRC)
	@sed 's/^"/                "/g' -i $(DOTNET_SRC)

bump_version:
	@sed 's/version\": .*$$/version": "$(GIT_TAG)",/g' -i ./package.json
	@sed 's/Version>.*</Version>$(GIT_TAG)</g' -i ./src/dotnet/IsBizMail.csproj
