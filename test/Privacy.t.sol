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
     */
    function test_find_password_fuzz ( bytes16 _key ) public {

        _target.unlock( _key );
        console.logBytes16( _key );
        require( _target.locked() == false );
    }

    /**
        @notice Static array are store in contiguous slot : the size is known at 
        compile time.

        In order to properly read private variable in storage we must use vm.load( _targert, slot ) 
        
        @notice casting bytes takes shrink the original types and return the stronger bytes
     */
    function test_find_password() public
    {
        bytes32 data;

        data = vm.load( address( _target ), bytes32( uint256(0) ) );
        // Bit shift the return data : I put the weakest at the strongest
        data <<= 128;
        console.logBytes16( bytes16(data) ); // This is not working for now because of the specific layout of Privacy Contract : variable sharing slots
        console.logBytes32( data );
         _target.unlock( bytes16(data) );
  
        require( _target.locked() == true );
    }
}

