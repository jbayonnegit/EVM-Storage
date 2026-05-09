# EVM-Storage


## What is this repository ?

Here you can find test, questions and experiments dealing with storage layout using foundry test.
Each test explore a notion, find explenation about what the test are doing directly in test/*.sol files.

### Layout

Storage in contract is divide in **32 bytes** slots. The storage variable are store contiguously in storage
execpte for dynamics array and mapping type.

### Run the test

`forge test path -option`

Some of them should fail