Business Email Checker
[![Build Status](https://travis-ci.org/salaros/is-biz-mail-php.svg?branch=master)](https://travis-ci.org/salaros/is-biz-mail-php)
[![Coverage Status](https://coveralls.io/repos/github/salaros/is-biz-mail-php/badge.svg?branch=master)](https://coveralls.io/github/salaros/is-biz-mail-php?branch=master)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/salaros/is-biz-mail-php/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/salaros/is-biz-mail-php/?branch=master)
=======================
[![License](https://poser.pugx.org/salaros/is-biz-mail/license)](https://packagist.org/packages/salaros/is-biz-mail)
![PHP version](https://img.shields.io/badge/PHP%20version-5.4.+%20|%207.0+-blue.svg)
[![Latest Stable Version](https://poser.pugx.org/salaros/is-biz-mail/version)](https://packagist.org/packages/salaros/is-biz-mail)
[![Total Downloads](https://poser.pugx.org/salaros/is-biz-mail/downloads)](https://packagist.org/packages/salaros/is-biz-mail)
[![composer.lock available](https://poser.pugx.org/salaros/is-biz-mail/composerlock)](https://packagist.org/packages/salaros/is-biz-mail)

[![Donate Patreon](https://img.shields.io/badge/donate-Patreon-f96854.svg)](https://www.patreon.com/salaros/)
[![Donate Paypal](https://img.shields.io/badge/donate-PayPal-009cde.svg)](https://paypal.me/salarosIT)
[![Donate Liberapay](https://img.shields.io/badge/donate-Liberapay-ffc600.svg)](https://liberapay.com/salaros/)

**isBizMail** tells you whether a given email address is free (gmail.com, yahoo.es, yandex.ru etc) or not.
The list of emails used by **isBizMail** is taken from [here](http://svn.apache.org/repos/asf/spamassassin/trunk/rules/20_freemail_domains.cf)¹.
Detects around 2500 domains and subdomains.

1) *All credits for the list itself go to [SpamAssasin](https://spamassassin.apache.org/) authors and contributors*

## Looking for JavaScript, .NET etc?

* [JavaScript implementation](https://github.com/salaros/is-biz-mail-js) (Vanilla / CommomJS module)
* [.NET implementation](https://github.com/salaros/is-biz-mail-dotnet) (.NET Standard 2.0+)

## Installation

You can install **isBizMail** via Composer:

```bash
composer require salaros/is-biz-mail
```

or by adding it directly to your `composer.json` file:

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

(new IsBizMail())->isValid('foo@bar.com');      // true

// You can use static access as well
IsBizMail::isValid('hello@gmail.com');          // false
// ...
```

You can easily drop it into your [Yii2 model](https://www.yiiframework.com/doc/guide/2.0/en/input-validation#declaring-rules)'s rules:

```php
public function rules() {
  return [
    // ...
    [['email'], 'isBusinessEmail'],
    // ...
  ];
}

public function isBusinessEmail($attributeName, $params) {
  $isBussiness = (new IsBizMail())->isValid($this->email);
  if (!isBussiness)
    $this->addError($attributeName, 'Mail boxes such as @gmail.com, @yahoo.com etc are not allowed!');
  return $isBussiness;
}
```

## Testing: [PHPUnit](https://phpunit.de/)

```bash
composer install
composer test   # or ./vendor/bin/phpunit
```
