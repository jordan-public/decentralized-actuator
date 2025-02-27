// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

contract DoRacle {
    struct Action {
        string description;
        uint256 reward;
        uint256 guarantee;
        uint256 executeDeadline;
        uint256 voteDeadline; // Relative to executedTimestamp
        uint256 voteCount;
        uint256 votesExecuted;
        address requester;
        address executor;
        address disputer;
        uint256 executedTimestamp;
    }

    address public owner;
    address public tokenAddress;
    Action[] public actions;
    mapping(uint256 => mapping(address => bool)) public votes;

    event ActionRequested(uint256 actionId, string description);
    event Voted(uint256 actionId, address voter);
    event ActionExecuted(uint256 actionId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function requestAction(string memory _description, uint256 _reward, uint256 _guarantee, uint256 _executeDeadline, uint256 _voteDeadline) public {
        require(_reward > 0, "Reward must be greater than 0");
        require(_guarantee > 0, "Guarantee must be greater than 0");
        require(_executeDeadline > 0, "Execute deadline must be greater than 0");
        require(_voteDeadline > 0, "Vote deadline must be greater than 0");

        actions.push(Action({
            description: _description,
            reward: _reward,
            guarantee: _guarantee,
            executeDeadline: _executeDeadline,
            voteDeadline: _voteDeadline,
            voteCount: 0,
            votesExecuted: 0,
            requester: msg.sender,
            executor: address(0),
            disputer: address(0),
            executedTimestamp: 0
        }));
        emit ActionRequested(actions.length - 1, _description);
    }

    function vote(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(block.timestamp < actions[_actionId].voteDeadline, "Vote deadline passed");
        require(!votes[_actionId][msg.sender], "Already voted");

        votes[_actionId][msg.sender] = true;
        actions[_actionId].voteCount += 1;

        emit Voted(_actionId, msg.sender);
    }

    function executeAction(uint256 _actionId) public onlyOwner {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].executedTimestamp == 0, "Action already executed");
        require(block.timestamp < actions[_actionId].executeDeadline, "Execute deadline passed");
        // !!! Make guarantee payment to this contract


        actions[_actionId].executedTimestamp = block.timestamp;

        // Here you would add the logic to execute the action
        // For example, calling another contract or transferring funds

        emit ActionExecuted(_actionId);
    }

    function getAction(uint256 _actionId) public view returns (string memory description, uint256 voteCount, uint256 executedTimestamp) {
        require(_actionId < actions.length, "Action does not exist");

        Action memory action = actions[_actionId];
        return (action.description, action.voteCount, action.executedTimestamp);
    }

    function getActionsCount() public view returns (uint256) {
        return actions.length;
    }
}