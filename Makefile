DOMAINS_LIST		:= ./build/freemail_domains.txt
DOMAINS_LIST_PLUS	:= ./assets/emails-not-in-spamassassin.txt
DOMAINS_COMMENT		:= free email providers
DOMAINSW_COMMENT	:= free email patterns
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
	@grep -Ei 'freemail_domains (.*)$$' $(DOMAINS_LIST).tmp | grep -oP 'freemail_domains \K.*' > $(DOMAINS_LIST) && rm $(DOMAINS_LIST).tmp
	@cat $(DOMAINS_LIST_PLUS) >> $(DOMAINS_LIST) # Append the list of domains not found in SpamAssassin to the rest	
	@sed -E -e 's/[[:blank:]]+/\n/g' -i $(DOMAINS_LIST) # Replace all spaces with new lines
	@wget -q https://raw.githubusercontent.com/MattKetmo/EmailChecker/master/res/throwaway_domains.txt -O ->> $(DOMAINS_LIST)
	@grep "*" $(DOMAINS_LIST) > $(DOMAINS_LIST).wildcard # Move all wildcard patterns to a separate file
	@sed "/*/d" $(DOMAINS_LIST) > $(DOMAINS_LIST).tmp # Remove wildcard patterns from the list of domains
	@awk '!seen[$$0]++' $(DOMAINS_LIST).tmp | sort > $(DOMAINS_LIST)
	@sed '$$!{:a;N;s/\n/ /;ta}' -i $(DOMAINS_LIST)* # replace all new lines with a single whitespace
	@sed 's/ /\n/6;P;D' -i $(DOMAINS_LIST)* # Split a single line in multiple rows each containing maximum 6 domains
	@sed -e ':a' -e 'N' -e '$$!ba' -e 's/\n/",\n"/g' -i $(DOMAINS_LIST)*
	@sed -e 's/ /", "/g' -i $(DOMAINS_LIST)*
	@find ./build -type f | xargs -I{} sh -c 'echo "\"$$(cat $$1)\"," > $$1' -- {}

php: download
	@sed '/$(DOMAINS_COMMENT) start/,/$(DOMAINS_COMMENT) end/{//!d}' -i $(PHP_SRC)
	@sed '/$(DOMAINSW_COMMENT) start/,/$(DOMAINSW_COMMENT) end/{//!d}' -i $(PHP_SRC)
	@sed '/$(DOMAINS_COMMENT) start/ r $(DOMAINS_LIST)' -i $(PHP_SRC)
	@sed '/$(DOMAINSW_COMMENT) start/ r $(DOMAINS_LIST).wildcard' -i $(PHP_SRC)
	@sed 's/^"/            "/' -i $(PHP_SRC)

tests:
	@composer test

validate-extra: download
	@# Make sure that email in the additional list have no duplicates in SpamAssasin lists
	@while read p; do if [ ! -z "$$(grep -in " $${p}" $(DOMAINS_LIST).tmp)" ]; then echo $$p; fi; done <$(DOMAINS_LIST_PLUS)
