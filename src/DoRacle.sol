// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

contract DoRacle {
    struct Action {
        string description;
        uint256 voteCount;
        bool executed;
    }

    address public owner;
    Action[] public actions;
    mapping(uint256 => mapping(address => bool)) public votes;

    event ActionProposed(uint256 actionId, string description);
    event Voted(uint256 actionId, address voter);
    event ActionExecuted(uint256 actionId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function proposeAction(string memory _description) public {
        actions.push(Action({
            description: _description,
            voteCount: 0,
            executed: false
        }));
        emit ActionProposed(actions.length - 1, _description);
    }

    function vote(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(!votes[_actionId][msg.sender], "Already voted");

        votes[_actionId][msg.sender] = true;
        actions[_actionId].voteCount += 1;

        emit Voted(_actionId, msg.sender);
    }

    function executeAction(uint256 _actionId) public onlyOwner {
        require(_actionId < actions.length, "Action does not exist");
        require(!actions[_actionId].executed, "Action already executed");

        actions[_actionId].executed = true;

        // Here you would add the logic to execute the action
        // For example, calling another contract or transferring funds

        emit ActionExecuted(_actionId);
    }

    function getAction(uint256 _actionId) public view returns (string memory description, uint256 voteCount, bool executed) {
        require(_actionId < actions.length, "Action does not exist");

        Action memory action = actions[_actionId];
        return (action.description, action.voteCount, action.executed);
    }

    function getActionsCount() public view returns (uint256) {
        return actions.length;
    }
}