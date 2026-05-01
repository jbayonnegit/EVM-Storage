// SPDX-License-Identifier : MIT

pragma solidity ^0.8.30;


/**
 * @title Logic
 * @author Jbayonne
 * @notice Very simple get - set contract
 * 
 * This contract is used to perfome change in MinimalProxy contract storage. Test can be find
 * in test/MinimalProxy.t.sol
 */
contract Logic {

	uint256	sInvariant;
	uint256	srandomNumber;

	function setNumber( uint256 number ) external 
	{
		srandomNumber = number;
	}

	function setInvariantNumber() external 
	{
		sInvariant = 42;
	}

	function getNumber() external view returns ( uint256 )
	{
		return ( srandomNumber );
	}

	function getInvariantNumber() external view returns ( uint256 )
	{
		return ( sInvariant );
	}

	fallback() external payable
	{

	}

	receive() external payable
	{
		
	}
}


/**
 * @title Minimal Proxu
 * @author Jbayonne 
 * @notice Implementation of a MinimalProxy contract to understand the use of delegatecall
 * and explore storage layout in contract.
 * 
 * The storage of this contract is directly change by the Logic contract above.
 */
contract MinimalProxy {

	address	immutable s_owner;
	bytes32 constant IMPLEMENTATION_LOCATION = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

	constructor( address owner )
	{
		s_owner = owner;
	}
	
	function setImplementation( address new_ ) public
	{
		if ( msg.sender != s_owner )
			revert("42");
		assembly
		{
			sstore( IMPLEMENTATION_LOCATION, new_ )
		}
	}

	function getImplementation() public view returns ( bytes32 )
	{
		bytes32 logic;

		assembly
		{
			logic := sload(IMPLEMENTATION_LOCATION)
		}
		return ( logic );
	}

	/**
	 * 
	 * @param doStuff_ -- Raw byte from abi.encodeWithSignature()
	 * 
	 * This function is the entrypoint of the contract, delegatecall is in charge of 
	 * calling the logic contract to perform operation.
	 * 
	 */
	function	_delegate( bytes calldata doStuff_ ) external returns ( bytes memory )
	{
		address	mLogicAddress;
		bytes32	mTmp;

		assembly
		{
			mTmp := sload(IMPLEMENTATION_LOCATION)
		}

		mLogicAddress = address(uint160(uint256(mTmp)));

		// Low-level function ( risk of storage overlap )
		(bool success, bytes memory returnvalue ) = mLogicAddress.delegatecall( doStuff_ );
		if ( success )
			return ( returnvalue );
		else {
			revert("Something goes Wrong") ;
		}
	}
}