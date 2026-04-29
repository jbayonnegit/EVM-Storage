// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

/**
 * @title  Simple Mapping Contract
 * @author Jbayonne
 * This simple contract is used in ../test/Mapping.t.sol to better
 * understand the mapping storage layout. It shows the obvious vulnerability
 * of private variable in solidy.
 *  
 */

contract Mapping{

    // Simple private mapping use to store address.
    // Mapping at Slot 0 and data are stored as keccak(abi.encode(key, mappingSlot))
    mapping(uint256 => address)  private _users0;

    /**
    * 
    * @param slot : index in mapping
    * @param users : address in the mapping
    * 
    * This function store a new user in _user0 mapping.  
    */
    function setAddress( uint256 slot, address users ) external
    {
        _users0[ slot ] = users;
    }

    /**
     * 
     * @param slot : index in mapping
     * 
     * This function return the address at the index "slot" in _users0 mapping.
     */
    function getAddress( uint256 slot ) view external returns( address )
    {
        return ( _users0[ slot ] );
    }
}