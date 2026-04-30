// SPDX-License-Identifier : MIT

/**
 * @title Mapping Storage Exploration
 * @author Jbayonne
 * @notice Learning Project
 * 
 * This test file deploy a Mapping contract from src/Mapping.sol.
 * It shows how we can access to private value reading storage with two differents methodes.
 * 
 */


pragma solidity ^0.8.30;

import { Test, console } from "forge-std/Test.sol";
import { Mapping } from "src/Mapping.sol";
import { stdStorage, StdStorage } from "forge-std/Test.sol";

contract MappingTest is Test
{
	using stdStorage for StdStorage;
	Mapping public _contract;

	/**
	 * setUp() function innitialize the test contract adding multiple 
	 * users to Mapping storage through _contract variable
	 */
	function setUp() public
	{
		_contract = new Mapping();
		_contract.setAddress(0, address(0));
		_contract.setAddress(100, address(100));
		_contract.setAddress(30, address(30));
		_contract.setAddress(878, address(5));
	}

	/**
	 * Simple use of StdStorage library in order to read storage of _contract.
	 * 
	 * @notice In order to properly read the storage with StdStorage the mapping variable in _contract 
	 * must be public. Otherwise, the test revert.
	 */
	function test_readMappingStorageStdStorage() public
	{
		address			userAddress;

		userAddress = stdstore.target(address( _contract)).sig("_users0(uint256)").with_key(878).depth(0).read_address();	
		console.log( userAddress );
		assertEq( _contract.getAddress( 878 ), userAddress);
	}

	/**
	 * Simple use of vm.load() in order to read storage of _contract.
	 * 
	 * @notice this test runs perfectly with public and private variable.
	 */
	function test_readMappingStoragevm() public
	{
		bytes32			value;
		address			userAddress;

		// Mapping data are store in storage as key_slot = keccak256(abi.encode( key , mapping_variable_slot))
		value = vm.load(address( _contract ), keccak256(abi.encode(878, 0)));
		userAddress = address( uint160( uint256( value ) ) );	
		console.log( "userAdress : ", userAddress );
		console.log( uint256(value) );
		assertEq( _contract.getAddress( 878 ), userAddress);
	}
}