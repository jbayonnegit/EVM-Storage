// SPDX-License-Identifier : MIT

pragma solidity ^0.8.30;

contract Logic {

	uint256	randomNumber;

	function setNumber( uint256 number ) external 
	{
		randomNumber = number;
	}

	function getNumber() external view returns ( uint256 )
	{
		return ( randomNumber );
	}

}

contract MinimalProxy {

	bytes32 constant IMPLEMENTATION_LOCATION = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

	function setImplementation( address _new ) public
	{
		assembly
		{
			sstore( IMPLEMENTATION_LOCATION, _new )
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
}