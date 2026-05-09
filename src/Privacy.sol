// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
	bool public locked = true; // 1 byte - slot 0
	uint256 public ID = block.timestamp; // 32 bytes - slot 1
	uint8 private flattening = 10; // 1 byte - slot 2
	uint8 private denomination = 255; // 1 byte - slot 2
	uint16 private awkwardness = uint16(block.timestamp); // 2 byte - slot 2
	bytes32[3] private data; // 96 bytes - ( slot 3 - slot 4 - slot 5 ) : static array are store contiguously 

	constructor(bytes32[3] memory _data) {
		data = _data;
	}

	function unlock(bytes16 _key) public {
		require(_key == bytes16(data[2]));
		locked = false;
	}

	/*
	A bunch of super advanced solidity algorithms...

	  ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
	  .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
	  *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
	  `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
	  ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
	*/
}