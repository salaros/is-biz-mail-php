require('../../src/javascript/FreeMailChecker.js');

var should = require('should'),
    assert = require('assert');

var businessEmails = [
        'biz_@microsoft.com',
        'biz_@apple.com',
        'biz_@mysql.org',
    ],
    freeEmails = [
        'free_@gmail.com',
        'free_@yahoo.it',
        'free_@yandex.ru',
        'free_@live.com',
        'free_@acme.onmicrosoft.com',
    ];

describe('FreeMailChecker.isFreeMailAddress', function () {
    it('FreeMailChecker.isFreeMailAddress - is defined', function () {
        ('isFreeMailAddress' in FreeMailChecker).should.equal(true);
    });

    businessEmails.forEach(function(email) {
        it(email + ' - not free (business)', function () {
            FreeMailChecker.isFreeMailAddress(email).should.equal(false);
        });
    });

    freeEmails.forEach(function(email) {
        it(email + ' - is free', function () {
            FreeMailChecker.isFreeMailAddress(email).should.equal(true);
        });
    });
});

describe('FreeMailChecker.getFreeDomains', function () {
    it('FreeMailChecker.getFreeDomains - is defined', function () {
        ('getFreeDomains' in FreeMailChecker).should.equal(true);
    });

    var freeDomains = FreeMailChecker.getFreeDomains();
    it(freeDomains.length + ' free mail definitions found', function () {
        freeDomains.length.should.be.above(0);
    });
});

describe('FreeMailChecker.isValid', function () {
    it('FreeMailChecker.isValid - is defined', function () {
        ('isValid' in FreeMailChecker).should.equal(true);
    });

    businessEmails.forEach(function(email) {
        it(email + ' - is valid and not free (business)', function () {
            FreeMailChecker.isValid(email).should.equal(true);
        });
    });

    freeEmails.forEach(function(email) {
        it(email + ' - is valid and free', function () {
            FreeMailChecker.isValid(email).should.equal(false);
        });
    });
});