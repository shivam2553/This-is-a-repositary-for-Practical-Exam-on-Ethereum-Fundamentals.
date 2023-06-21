ques- Write a Lottery Smart Contract made by using Solidity and Remix IDE.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;
    
    constructor() {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum entry fee is 0.01 ether");
        players.push(msg.sender);
    }
    
    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length)));
    }
    
    function pickWinner() public restricted {
        require(players.length > 0, "No players participated yet");
        
        uint256 index = random() % players.length;
        address payable winner = payable(players[index]);
        
        winner.transfer(address(this).balance);
        players = new address[](0);
    }
    
    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }
    
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
