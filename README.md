Business Email Checker
[![License](https://poser.pugx.org/salaros/is-biz-mail/license)](https://packagist.org/packages/salaros/is-biz-mail)
![GitHub tag](https://img.shields.io/github/tag/salaros/is-biz-mail.svg)
![GitHub language count](https://img.shields.io/github/languages/count/salaros/is-biz-mail.svg)
![GitHub issues](https://img.shields.io/github/issues/salaros/is-biz-mail.svg)
================================================================================================

**isBizMail** tells you whether a given email address is free (gmail.com, yahoo.es, yandex.ru etc) or not.
The list of emails used by **isBizMail** is taken from [here](http://svn.apache.org/repos/asf/spamassassin/trunk/rules/20_freemail_domains.cf)¹.
Detects around 2500 domains and subdomains.

1) *All credits for the list itself go to [SpamAssasin](https://spamassassin.apache.org/) authors and contributors*

PHP
![PHP version](https://img.shields.io/badge/PHP%20version-5.4.+%20|%207.0+-blue.svg)
[![Latest Stable Version](https://poser.pugx.org/salaros/is-biz-mail/version)](https://packagist.org/packages/salaros/is-biz-mail)
[![Total Downloads](https://poser.pugx.org/salaros/is-biz-mail/downloads)](https://packagist.org/packages/salaros/is-biz-mail)
[![composer.lock available](https://poser.pugx.org/salaros/is-biz-mail/composerlock)](https://packagist.org/packages/salaros/is-biz-mail)
================================================================================================
[![Travis CI build Status](https://travis-ci.org/salaros/is-biz-mail.svg?branch=master)](https://travis-ci.org/salaros/is-biz-mail)
[![Code Coverage](https://scrutinizer-ci.com/g/salaros/is-biz-mail/badges/coverage.png?b=master)](https://scrutinizer-ci.com/g/salaros/is-biz-mail/?branch=master)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/salaros/is-biz-mail/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/salaros/is-biz-mail/?branch=master)

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

JavaScript
![js type](https://img.shields.io/badge/type-Vanilla%20|%20CommonJS-589594.svg)
[![npm](https://img.shields.io/npm/v/is-biz-mail.svg)](https://www.npmjs.com/package/is-biz-mail)
![npm](https://img.shields.io/npm/dt/is-biz-mail.svg)
![npm](https://img.shields.io/npm/dw/is-biz-mail.svg)
![npm bundle size (minified + gzip)](https://img.shields.io/bundlephobia/minzip/is-biz-mail.svg)
================================================================================================
[![Travis CI build Status](https://travis-ci.org/salaros/is-biz-mail.svg?branch=master)](https://travis-ci.org/salaros/is-biz-mail)

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
    console.log([email, result]);   // (2) ["foo@nodejs.onmicrosoft.com", false]
</script>
```

## [CommonJS](http://requirejs.org/docs/commonjs.html) / ES5 / ES6 module, Node.js etc

```js
const isBizMail = require('is-biz-mail');

let result = isBizMail.isFreeMailAddress(email);
console.log([email, result]);   // (2) ["es6@live.com", true]
// ...
```

## Testing: [Mocha](https://mochajs.org/) + [Should.js](https://shouldjs.github.io/)

```bash
yarn
yarn test
```

or via NPM

```bash
npm install
npm test    # or ./node_modules/.bin/mocha
```

dotnet (.NET)
[![NuGet](https://img.shields.io/nuget/v/Salaros.Email.IsBizMail.svg?label=NuGet&colorA=404680&colorB=98976B)](https://www.nuget.org/packages/Salaros.Email.IsBizMail)
[![NuGet](https://img.shields.io/nuget/dt/Salaros.Email.IsBizMail.svg)](https://www.nuget.org/packages/Salaros.Email.IsBizMail)
[![.NET Standard](https://img.shields.io/badge/.NET%20Standard-2.0+-784877.svg)](https://docs.microsoft.com/en-us/dotnet/standard/net-standard#net-implementation-support)
================================================================================================

You can install IsBizMail for **.NET Core 2.0+ / Framework 4.6.1+, Mono 5.4+** etc via [NuGet](https://www.nuget.org/packages/Salaros.Email.IsBizMail/).

You could build it from sources via:

```bash
dotnet build
```

IsBizMail in .NET is a static class, so can use it like this:

```cs
using Salaros.Email;

//..
{
    Console.WriteLine(IsBizMail.IsValid("foo@bar.com"));        // true
    Console.WriteLine(IsBizMail.IsValid("hello@gmail.com"));    // false
//..

```

## Testing: xUnit.net

```bash
dotnet test test/dotnet
```