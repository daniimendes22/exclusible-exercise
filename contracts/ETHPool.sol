// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ETHPool is AccessControl {
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    bytes32 public constant TEAM_MEMBER_ROLE = keccak256("TEAM_MEMBER_ROLE");

    uint256 public total;
    address[] public users;

    struct DepositValue {
        uint256 value;
        bool hasValue;
    }

    mapping(address => DepositValue) public balances;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(TEAM_MEMBER_ROLE, msg.sender);
    }



    receive() external payable {

        if(!balances[msg.sender].hasValue)
        users.push(msg.sender);
        balances[msg.sender].value += msg.value;
        total += msg.value;

        emit Deposit(msg.sender, msg.value);

    }

    function depositRewards() public payable onlyRole(TEAM_MEMBER_ROLE) {
        require(total > 0);
        for(uint i = 0; i < users.length; i++) {
            address user = users[i];
            uint rewards = ((balances[user].value * msg.value) / total);
            balances[user].value += rewards;
        }
    }
    
    function withdraw() public {
        uint256 amount = balances[msg.sender].value;

        require(amount > 0);
        
        balances[msg.sender].value = 0;
        
        (bool sucess, ) = msg.sender.call{value:amount}("");
        require(sucess, "Failed to send funds to user");
        emit Withdraw(msg.sender, amount);

    }


    function addTeamMember(address _member) public {
        grantRole(TEAM_MEMBER_ROLE, _member);
    }
    
    function removeTeamMember(address _member) public {
        revokeRole(TEAM_MEMBER_ROLE, _member);
    }
}
