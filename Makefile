DOMAINS_LIST		:= ./build/freemail_domains.txt
DOMAINS_LIST_PLUS	:= ./assets/not-found-in-spamassassin-list.txt
DOMAINS_START		:= free email providers start
DOMAINS_END			:= free email providers end
PHP_SRC				:= ./src/IsBizMail.php

.PHONY: all download tests prepare clean

all: php

clean:
	@mkdir -pv ./build
	@find ./build -mindepth 1 -delete

prepare:
	@mkdir -pv ./build

download: prepare
	@wget -q https://raw.githubusercontent.com/apache/spamassassin/trunk/rules/20_freemail_domains.cf -O $(DOMAINS_LIST).tmp
	@wget -q https://raw.githubusercontent.com/apache/spamassassin/trunk/rules/20_freemail_mailcom_domains.cf -O ->> $(DOMAINS_LIST).tmp
	@sed 's/\r$$//' -i $(DOMAINS_LIST).tmp # Replace \r\n endings with \n
	@grep -Ei 'freemail_domains (.*)$$' $(DOMAINS_LIST).tmp | grep -oP 'freemail_domains \K.*' > $(DOMAINS_LIST)
	@cat $(DOMAINS_LIST_PLUS) >> $(DOMAINS_LIST) # Append the list of domains not found in SpamAssassin to the rest	
	@sed '$$!{:a;N;s/\n/ /;ta}' -i $(DOMAINS_LIST) # replace all new lines with a single whitespace
	@sed 's/ /\n/6;P;D' -i $(DOMAINS_LIST) # Split a single line in multiple rows each containing maximum 6 domains
	@sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n/",\n"/g' -i $(DOMAINS_LIST)
	@sed -e 's/ /", "/g' -i $(DOMAINS_LIST)
	@echo "\"$$(cat $(DOMAINS_LIST))\"," > $(DOMAINS_LIST)

php: download
	@sed '/$(DOMAINS_START)/,/$(DOMAINS_END)/{//!d}' -i $(PHP_SRC)
	@sed '/$(DOMAINS_START)/ r $(DOMAINS_LIST)' -i $(PHP_SRC)
	@sed 's/^"/            "/' -i $(PHP_SRC)

tests:
	@composer test
