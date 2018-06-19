let should = require('should'),
    assert = require('assert'),
    isBizMail = require('../../src/commonjs/'),
    emailSamples = require('../emailSamples.json');

describe('isBizMail.isFreeMailAddress', function () {
    it('isBizMail.isFreeMailAddress - is defined', function () {
        ('isFreeMailAddress' in isBizMail).should.equal(true);
    });

    emailSamples.business.forEach(function(email) {
        it(email + ' - not free (business)', function () {
            isBizMail.isFreeMailAddress(email).should.equal(false);
        });
    });

    emailSamples.free.forEach(function(email) {
        it(email + ' - is free', function () {
            isBizMail.isFreeMailAddress(email).should.equal(true);
        });
    });
});

describe('isBizMail.getFreeDomains', function () {
    it('isBizMail.getFreeDomains - is defined', function () {
        ('getFreeDomains' in isBizMail).should.equal(true);
    });

    var freeDomains = isBizMail.getFreeDomains();
    it(freeDomains.length + ' free mail definitions found', function () {
        freeDomains.length.should.be.above(0);
    });
});

describe('isBizMail.isValid', function () {
    it('isBizMail.isValid - is defined', function () {
        ('isValid' in isBizMail).should.equal(true);
    });

    emailSamples.business.forEach(function(email) {
        it(email + ' - is valid and not free (business)', function () {
            isBizMail.isValid(email).should.equal(true);
        });
    });

    emailSamples.free.forEach(function(email) {
        it(email + ' - is valid and free', function () {
            isBizMail.isValid(email).should.equal(false);
        });
    });
});
