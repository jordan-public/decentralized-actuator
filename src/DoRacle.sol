// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";

contract DoRacle {
    struct Action {
        string description;
        uint256 reward;
        uint256 guarantee;
        uint256 executeDeadline;
        uint256 disputeDeadline;
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
    event ActionTaken(uint256 actionId);
    event ActionExecuted(uint256 actionId);
    event ActionDisputed(uint256 actionId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function requestAction(string memory _description, uint256 _reward, uint256 _guarantee, uint256 _executeDeadline, uint256 _disputeDeadline, uint256 _voteDeadline) public {
        require(_reward > 0, "Reward must be greater than 0");
        require(_guarantee > 0, "Guarantee must be greater than 0");
        require(_executeDeadline > 0, "Execute deadline must be greater than 0");
        require(_voteDeadline > 0, "Vote deadline must be greater than 0");

        actions.push(Action({
            description: _description,
            reward: _reward,
            guarantee: _guarantee,
            executeDeadline: _executeDeadline,
            disputeDeadline: _disputeDeadline,
            voteDeadline: _voteDeadline,
            voteCount: 0,
            votesExecuted: 0,
            requester: msg.sender,
            executor: address(0),
            disputer: address(0),
            executedTimestamp: 0
        }));

        // Make reward payment to this contract
        (IERC20Metadata(tokenAddress)).transferFrom(msg.sender, address(this), _reward);

        emit ActionRequested(actions.length - 1, _description);
    }

    function vote(uint256 _actionId, bool executed) public {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].disputer != address(0), "Action not disputed");
        require(block.timestamp < actions[_actionId].voteDeadline, "Vote deadline passed");
        require(!votes[_actionId][msg.sender], "Already voted");

        votes[_actionId][msg.sender] = true;
        actions[_actionId].voteCount += 1;
        if (executed) {
            actions[_actionId].votesExecuted += 1;
        }

        emit Voted(_actionId, msg.sender);
    }

    function voteResult(uint256 _actionId) public view returns (bool executed) {
        require(_actionId < actions.length, "Action does not exist");
        require(block.timestamp >= actions[_actionId].voteDeadline, "Vote deadline not passed");

        return actions[_actionId].votesExecuted > actions[_actionId].voteCount / 2;
    }

    function takeAction(uint256 _actionId) public onlyOwner {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].executor == address(0), "Action already taken");
        // require(actions[_actionId].executedTimestamp == 0, "Action already executed");
        require(block.timestamp < actions[_actionId].executeDeadline, "Execute deadline passed");

        // Make guarantee payment to this contract
        (IERC20Metadata(tokenAddress)).transferFrom(msg.sender, address(this), actions[_actionId].guarantee);

        emit ActionTaken(_actionId);
    }

    function executeAction(uint256 _actionId) public onlyOwner {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].executor == msg.sender, "Action not taken by executor");
        require(actions[_actionId].executedTimestamp == 0, "Action already executed");
        require(block.timestamp < actions[_actionId].executeDeadline, "Execute deadline passed");

        actions[_actionId].executedTimestamp = block.timestamp;

        emit ActionTaken(_actionId);
    }

    function disputeAction(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(block.timestamp < actions[_actionId].disputeDeadline, "Dispute deadline passed");
        require(actions[_actionId].disputer == address(0), "Action already disputed");

        actions[_actionId].disputer = msg.sender;

        // Make dispute payment to this contract (same as guarantee)
        (IERC20Metadata(tokenAddress)).transferFrom(msg.sender, address(this), actions[_actionId].guarantee);

        emit ActionDisputed(_actionId);
    }

    function settleAction(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(block.timestamp >= actions[_actionId].disputeDeadline, "Dispute deadline not passed");

        if (actions[_actionId].disputer != address(0)) {
            if (voteResult(_actionId)) {
                // Make reward payment to executor and return guarantee
                (IERC20Metadata(tokenAddress)).transfer(actions[_actionId].executor, actions[_actionId].reward + actions[_actionId].guarantee);
            } else {
                // Make reward payment to disputer and return guarantee
                (IERC20Metadata(tokenAddress)).transfer(actions[_actionId].disputer, actions[_actionId].reward + actions[_actionId].guarantee);
            }
        } else {
            // Make reward payment to executor and return guarantee
            (IERC20Metadata(tokenAddress)).transfer(actions[_actionId].executor, actions[_actionId].reward + actions[_actionId].guarantee);
        }

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