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

declare(strict_types=1);

namespace Salaros\Email;

use Salaros\Email\IsBizMail;
use PHPUnit\Framework\TestCase;

/**
 * Test case for IsBizMail class
 * @coversDefaultClass \Salaros\Email\IsBizMail
 */
final class IsBizMailTest extends TestCase
{
    /**
     * Check if any free domain is defined
     * @covers      ::getFreeDomains
     * @test
     *
     * @return void
     */
    public function hasFreeDomainsListPopulated()
    {
        $obj = new IsBizMail();
        $this->assertNotEmpty($obj->getFreeDomains());
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
        $obj = new IsBizMail();
        $this->assertSame(true, $obj->isFreeMailAddress($freeEmail));
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
        $obj = new IsBizMail();
        $this->assertSame(false, $obj->isFreeMailAddress($businessEmail));
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
        $obj = new IsBizMail();
        $this->assertSame(true, $obj->isValid($businessEmail));
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
        $emailSamples = file_get_contents(sprintf("%s/emailSamples.json", dirname(__DIR__)));
        $emailSamples = json_decode($emailSamples, false);
        return array_map(function ($freeEmail) {
            return array($freeEmail);
        }, $emailSamples->free);
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
        $emailSamples = file_get_contents(sprintf("%s/emailSamples.json", dirname(__DIR__)));
        $emailSamples = json_decode($emailSamples, false);
        return array_map(function ($businessEmail) {
            return array($businessEmail);
        }, $emailSamples->business);
    }
}
