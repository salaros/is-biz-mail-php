require('../../src/javascript/FreeMailChecker.js');

var should = require('should'),
    assert = require('assert'),
    emailSamples = require('../emailSamples.json');

describe('FreeMailChecker.isFreeMailAddress', function () {
    it('FreeMailChecker.isFreeMailAddress - is defined', function () {
        ('isFreeMailAddress' in FreeMailChecker).should.equal(true);
    });

    emailSamples.business.forEach(function(email) {
        it(email + ' - not free (business)', function () {
            FreeMailChecker.isFreeMailAddress(email).should.equal(false);
        });
    });

    emailSamples.free.forEach(function(email) {
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

    emailSamples.business.forEach(function(email) {
        it(email + ' - is valid and not free (business)', function () {
            FreeMailChecker.isValid(email).should.equal(true);
        });
    });

    emailSamples.free.forEach(function(email) {
        it(email + ' - is valid and free', function () {
            FreeMailChecker.isValid(email).should.equal(false);
        });
    });
});