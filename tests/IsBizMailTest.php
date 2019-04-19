<?php
/**
 * Test case for IsBizMail class
 *
 * @category PHPUnit
 * @package  IsBizMail
 * @author   Zhmayev Yaroslav <salaros@salaros.com>
 * @license  MIT https://opensource.org/licenses/MIT
 * @link     https://github.com/salaros/free-mailchecker
 */

namespace Salaros\Email;

use Salaros\Email\IsBizMail;
use PHPUnit\Framework\TestCase;

/**
 * Test case for IsBizMail class
 * @coversDefaultClass \Salaros\Email\IsBizMail
 */
final class IsBizMailTest extends TestCase
{
    private static $emailSamples;

    /**
     * Check if any free domain is defined
     * @covers      ::getFreeDomains
     * @test
     *
     * @return void
     */
    public function hasFreeDomainsListPopulated()
    {
        $this->assertNotEmpty((new IsBizMail())->getFreeDomains());
    }

    /**
     * Check if any domain pattern is defined
     * @covers      ::getFreeDomainPatterns
     * @test
     *
     * @return void
     */
    public function hasFreeDomainsPatternsPopulated()
    {
        $this->assertNotEmpty((new IsBizMail())->getFreeDomainPatterns());
    }

    /**
     * Tests IsBizMail->isFreeMailAddress() against some free emails
     *
     * @param string $freeEmail A free email address
     *
     * @dataProvider getFreeMailDomainSamples
     * @covers      ::isFreeMailAddress
     * @test
     *
     * @return void
     */
    public function emailAddressIsOnFreeDomain($freeEmail)
    {
        $this->assertTrue((new IsBizMail())->isFreeMailAddress($freeEmail));
    }

    /**
     * Tests IsBizMail->isFreeMailAddress() against some business emails
     *
     * @param string $businessEmail A business email address
     *
     * @dataProvider getBusinessMailDomainSamples
     * @covers      ::isFreeMailAddress
     * @test
     *
     * @return void
     */
    public function emailAddressIsOnBusinessDomain($businessEmail)
    {
        $this->assertFalse((new IsBizMail())->isFreeMailAddress($businessEmail));
    }

    /**
     * Tests IsBizMail->isFreeMailAddress() against some domain patterns
     *
     * @param string $freeEmail A free email address
     *
     * @dataProvider getDomainPatternSamples
     * @covers      ::isFreeMailAddress
     * @test
     *
     * @return void
     */
    public function emailMatchesDomainPattern($freeEmail)
    {
        $this->assertTrue((new IsBizMail())->isFreeMailAddress($freeEmail));
    }

    /**
     * Tests IsBizMail->isValid() against some business emails
     *
     * @param string $businessEmail A business email address
     *
     * @depends      emailAddressIsOnBusinessDomain
     * @dataProvider getBusinessMailDomainSamples
     * @covers      ::isValid
     * @test
     *
     * @return void
     */
    public function emailAddressIsValid($businessEmail)
    {
        $this->assertTrue((new IsBizMail())->isValid($businessEmail));
    }

    /**
     * Tests IsBizMail->isValid() against some invalid emails
     *
     * @param string $invalidEmail An invalid email address
     *
     * @dataProvider          getInvalidEmailSamples
     * @covers                ::isValid
     * @test
     *
     * @return void
     */
    public function emailAddressIsInvalid($invalidEmail)
    {
        $this->assertFalse((new IsBizMail())->isValid($invalidEmail));
    }

    /**
     * Tests IsBizMail->isFreeMailAddress() with email containing a wildcard
     *
     * @covers                ::isFreeMailAddress
     * @expectedException     InvalidArgumentException
     * @expectedExceptionCode 200
     * @test
     *
     * @return void
     */
    public function testisFreeMailAddressException200()
    {
        (new IsBizMail())->isFreeMailAddress('invalid@wildcard.*');
    }

    /**
     * Tests IsBizMail->isFreeMailAddress() against an invalid email
     *
     * @covers                ::isFreeMailAddress
     * @expectedException     InvalidArgumentException
     * @expectedExceptionCode 100
     * @test
     *
     * @return void
     */
    public function testisFreeMailAddressException100()
    {
        (new IsBizMail())->isFreeMailAddress('notAnEmail');
    }

    /**
     * Provides a list of free email addresses
     * @doesNotPerformAssertions
     * @coversNothing
     *
     * @return array
     */
    public function getFreeMailDomainSamples()
    {
        return array_map(function ($freeEmail) {
            return array($freeEmail);
        }, self::getEmailSamples()->free);
    }

    /**
     * Provides a list of business email addresses
     * @doesNotPerformAssertions
     * @coversNothing
     *
     * @return array
     */
    public function getBusinessMailDomainSamples()
    {
        return array_map(function ($businessEmail) {
            return array($businessEmail);
        }, self::getEmailSamples()->business);
    }

    /**
     * Provides a list of business email addresses
     * @doesNotPerformAssertions
     * @coversNothing
     *
     * @return array
     */
    public function getDomainPatternSamples()
    {
        return array_map(function ($patternDomains) {
            return array($patternDomains);
        }, self::getEmailSamples()->pattern);
    }

    /**
     * Provides a list of invalid email addresses
     * @doesNotPerformAssertions
     * @coversNothing
     *
     * @return array
     */
    public function getInvalidEmailSamples()
    {
        return array_map(function ($invalidEmails) {
            return array($invalidEmails);
        }, self::getEmailSamples()->invalid);
    }

    /**
     * Provides an object containing lists of sample free, business etc domains
     * @doesNotPerformAssertions
     * @coversNothing
     *
     * @return object
     */
    public static function getEmailSamples()
    {
        if (is_null(self::$emailSamples)) {
            self::$emailSamples = json_decode(
                file_get_contents(sprintf("%s/assets/email-test-samples.json", dirname(__DIR__))),
                false
            );
        }
        return self::$emailSamples;
    }
}
