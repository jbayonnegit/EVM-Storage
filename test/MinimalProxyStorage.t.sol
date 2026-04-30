/**
 * @title Storage throught proxies
 * @author Jbayonne
 * @notice Learning Project - No AI use to code
 * 
 * Exploring storage in proxy contract with FuzzTest and StdInvariant.
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
    address         owner = address(42);
    /**
     * Deploy the MinimalProxy contract
     */
    function setUp() public
    {
        Logic   _logicContract = new Logic();
        _minimalProxy = new MinimalProxy( owner );
        vm.prank( owner );
        _minimalProxy.setImplementation( address(_logicContract) );
        bytes memory data = abi.encodeWithSignature("setInvariantNumber()");
        _minimalProxy._delegate(data);
        excludeSenders();
    }

    /**
     * 
     * @param implementation -- foundry field this parameter 
     * 
     * *Test the get and the logic of the the contract thanks to simple fuzztesting. 
     */
    function test_fuzz_implementaion( Logic implementation ) public
    {
        vm.prank( owner );
        _minimalProxy.setImplementation( address(implementation) );
        address _imp = address(uint160(uint256(_minimalProxy.getImplementation())));
        assertEq( _imp, address(implementation));
    }

    /** 
     * 
     * @param nb -- fuzzing test_fuzz_implementaion
     * 
     * * This function test a my MinimalProxy contract by setting and reading slot 0 of storage layout.
     * @notice forge test test/MinimalProxyStorageTest.sol --fuzz-runs <n_iteration> : in order 
     * to run n_iteration tests.
    */
    function test_setNumber( uint256 nb ) public
    {
        // Deploying Logic Contract
        Logic mImplementation = new Logic();

        vm.prank( owner );
        _minimalProxy.setImplementation( address( mImplementation) );

        // Encoding data to send it has a single parameter
        bytes memory dataSet = abi.encodeWithSignature("setNumber(uint256)", nb);
        _minimalProxy._delegate(dataSet);

        bytes memory dataGet = abi.encodeWithSignature("getNumber()");
        bytes32 slot = 0x0000000000000000000000000000000000000000000000000000000000000001;

        // reading directlty the stroage tanks to vm.load(targer_contract, slot)
        uint256 nb_read_from_storage = uint256 ( vm.load( address( _minimalProxy ), slot) ); 

        // decoding raw bytes data return by abi.decode
        uint256 _number = abi.decode(
            _minimalProxy._delegate(dataGet),
            (uint256)
        );

        assertEq( nb_read_from_storage, nb);
        assertEq( _number, nb_read_from_storage);
    }

    /**
     * 
     * 
     * 
     * By changing the logic contract, the storage layout of the proxi should never
     * change. 
     * 
     * * StdInvariant allowed us to checked if a value / a condition is verified in every situation.
     * @notice if its not : we can identify the bug through test Trace
     * 
     */
    function invariant_test_shouldBeAlwaysBe42() public
    {

        bytes memory dataGet = abi.encodeWithSignature("getInvariantNumber()");
        uint256 _number = abi.decode(
            _minimalProxy._delegate(dataGet),
            (uint256)
        );
        assertEq(_number, 42);
    }
}