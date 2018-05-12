Business Email Checker
=========================

[![License](https://poser.pugx.org/salaros/is-biz-mail/license)](https://packagist.org/packages/salaros/is-biz-mail)
![GitHub tag](https://img.shields.io/github/tag/salaros/is-biz-mail.svg)
![GitHub language count](https://img.shields.io/github/languages/count/salaros/is-biz-mail.svg)
![GitHub issues](https://img.shields.io/github/issues/salaros/is-biz-mail.svg)

**isBizMail** tells you whether a given email address is free (gmail.com, yahoo.es, yandex.ru etc) or not.
The list of emails used by **isBizMail** is taken from [here](http://svn.apache.org/repos/asf/spamassassin/trunk/rules/20_freemail_domains.cf)¹.
Detects around 2500 domains and subdomains.

1) *All credits for the list itself go to [SpamAssasin](https://spamassassin.apache.org/) authors and contributors*

# PHP

![PHP version](https://img.shields.io/badge/PHP%20version-5.4.+%20|%207.0+-blue.svg)
[![Latest Stable Version](https://poser.pugx.org/salaros/is-biz-mail/version)](https://packagist.org/packages/salaros/is-biz-mail)
[![Total Downloads](https://poser.pugx.org/salaros/is-biz-mail/downloads)](https://packagist.org/packages/salaros/is-biz-mail)
[![composer.lock available](https://poser.pugx.org/salaros/is-biz-mail/composerlock)](https://packagist.org/packages/salaros/is-biz-mail)

[![Build Status](https://scrutinizer-ci.com/g/salaros/is-biz-mail/badges/build.png?b=master)](https://scrutinizer-ci.com/g/salaros/is-biz-mail/build-status/master)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/salaros/is-biz-mail/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/salaros/is-biz-mail/?branch=master)
[![Code Coverage](https://scrutinizer-ci.com/g/salaros/is-biz-mail/badges/coverage.png?b=master)](https://scrutinizer-ci.com/g/salaros/is-biz-mail/?branch=master)

You can install **isBizMail** via Composer:

```bash
composer require salaros/is-biz-mail
```

or by adding it directly to your composer.json file:

```json
{
    "require": {
        "salaros/is-biz-mail": "*"
    }
}
```

Then use it like this:

```php
<?php

require 'path/to/vendor/autoload.php';

use Salaros\Email\IsBizMail;

$mailChecker = new IsBizMail();
$mailChecker->isValid('foo@bar.com');       // true
$mailChecker->isValid('hello@gmail.com');   // false

// ...
```

# JavaScript

You can install **isBizMail** for JavaScript via your prefered dependency manager, e.g. Yarn

```bash
yarn add is-biz-mail
```

or via NPM

```bash
npm i is-biz-mail
```

## Vanilla

One of examples of vanilla JavaScript usage might be a simple HTML page:

```html
<script src="path/to/src/javascript/is-biz-mail.js"></script>
<script>
    var result = isBizMail.isValid(email);
    console.log([email, result]);   // (2) ["foo@acme.onmicrosoft.com", false]
</script>
```

## ES6 module, Node.js etc

```js
const isBizMail = require('is-biz-mail');

let result = isBizMail.isFreeMailAddress(email);
console.log([email, result]);   // (2) ["foo@acme.onmicrosoft.com", false]
// ...
```