// SPDX-License-Identifier : MIT

pragma solidity ^0.8.30;

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

	function	_delegate( bytes calldata doStuff_ ) external returns ( bytes memory )
	{
		address	mLogicAddress;
		bytes32	mTmp;

		assembly
		{
			mTmp := sload(IMPLEMENTATION_LOCATION)
		}

		mLogicAddress = address(uint160(uint256(mTmp)));

		(bool success, bytes memory returnvalue ) = mLogicAddress.delegatecall( doStuff_ );
		if ( success )
			return ( returnvalue );
		else {
			revert("Something goes Wrong") ;
		}
	}
}