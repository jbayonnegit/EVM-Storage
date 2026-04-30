/**
 * @title Storage throught proxies
 * @author Jbayonne
 * @notice Learning Project
 * 
 * Exploring storage in proxy contract with fuzzTest and StdInvariant.
 */

// SPDX-License-Identifier : MIT

pragma solidity ^0.8.30;

import { Test, console } from "forge-std/Test.sol";
import { stdStorage, StdStorage } from "forge-std/StdStorage.sol";
import { MinimalProxy, Logic } from "src/MinimalProxyStorage.sol";
import { StdInvariant } from "forge-std/StdInvariant.sol";


contract MinimalProxyStorageTest is Test
{
    using stdStorage for StdStorage;
    
    MinimalProxy    _minimalProxy;

    /**
     * Deploy the MinimalProxy contract
     */
    function setUp() public
    {
        _minimalProxy = new MinimalProxy();
    }

    /**
     * 
     * @param implementation -- foundry field this parameter 
     * 
     * Test the get and the logic of the the contract thanks to simple fuzztesting. 
     */
    function test_fuzz_implementaion( Logic implementation ) public
    {
        _minimalProxy.setImplementation( address(implementation) );
        address _imp = address(uint160(uint256(_minimalProxy.getImplementation())));
        assertEq( _imp, address(implementation));
    }

}