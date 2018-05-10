<?php
/**
 * Test case for FreeMailChecker class
 *
 * @category PHPUnit
 * @package  FreeMailChecker
 * @author   Zhmayev Yaroslav <salaros@salaros.com>
 * @license  MIT https://opensource.org/licenses/MIT
 * @link     https://github.com/salaros/free-mailchecker
 */

declare(strict_types=1);

namespace Salaros\Email;

use Salaros\Email\FreeMailChecker;
use PHPUnit\Framework\TestCase;

/**
 * Test case for FreeMailChecker class
 * @coversDefaultClass \Salaros\Email\FreeMailChecker
 */
final class FreeMailCheckerTest extends TestCase
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
        $obj = new FreeMailChecker();
        $this->assertNotEmpty($obj->getFreeDomains());
    }

    /**
     * Tests FreeMailChecker->isFreeMailAddress() against some free emails
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
        $obj = new FreeMailChecker();
        $this->assertSame(true, $obj->isFreeMailAddress($freeEmail));
    }

    /**
     * Tests FreeMailChecker->isFreeMailAddress() against some business emails
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
        $obj = new FreeMailChecker();
        $this->assertSame(false, $obj->isFreeMailAddress($businessEmail));
    }

    /**
     * Tests FreeMailChecker->isValid() against some business emails
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
        $obj = new FreeMailChecker();
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
        return [
            array('free_@gmail.com'),
            array('free_@yahoo.it'),
            array('free_@yandex.ru'),
            array('free_@live.com'),
            array('free_@acme.onmicrosoft.com'),
        ];
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
        return array(
            array('biz_@microsoft.com'),
            array('biz_@apple.com'),
            array('biz_@mysql.org'),
        );
    }
}
