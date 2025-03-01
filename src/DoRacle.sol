// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./interfaces/IDoRacleToken.sol";
import "./types/TAction.sol";
import "./interfaces/IDoRacle.sol";
import "forge-std/Console.sol";

contract DoRacle is IDoRacle{
    address public owner;
    address public tokenAddress;
    TAction[] public actions;
    mapping(uint256 => mapping(address => uint8)) public votes; // actionId => voter => executed

    uint256 public constant VOTE_REWARD = 1 ether;

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

        actions.push(TAction({
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
        require((IDoRacleToken(tokenAddress)).transferFrom(msg.sender, address(this), _reward), "Transfer failed");

        emit ActionRequested(actions.length - 1, _description);
    }

    function vote(uint256 _actionId, bool executed) public {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].disputer != address(0), "Action not disputed");
        require(block.timestamp < actions[_actionId].voteDeadline, "Vote deadline passed");
        require((IDoRacleToken(tokenAddress)).balanceOf(msg.sender) > 0, "No balance to vote");
        require(votes[_actionId][msg.sender] == 0, "Already voted");

        // Deposit to vote
        require((IDoRacleToken(tokenAddress)).transferFrom(msg.sender, address(this), VOTE_REWARD), "Transfer failed");

        votes[_actionId][msg.sender] = executed ? 1 : 2;
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

    function claimVoterReward(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(votes[_actionId][msg.sender] != 0, "Voter did not vote");

        if (voteResult(_actionId) && votes[_actionId][msg.sender] == 2 || !voteResult(_actionId) && votes[_actionId][msg.sender] == 1) {
            // Make reward payment to voter
            (IDoRacleToken(tokenAddress)).mint(VOTE_REWARD); // Via inflation
            require((IDoRacleToken(tokenAddress)).transfer(msg.sender, VOTE_REWARD * 2), "Transfer failed");
        } // Otherise no reward and no voting depsit returned
        votes[_actionId][msg.sender] = 0; // Reset vote
    }

    function takeAction(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].executor == address(0), "Action already taken");
        // require(actions[_actionId].executedTimestamp == 0, "Action already executed");
        require(block.timestamp < actions[_actionId].executeDeadline, "Execute deadline passed");

        // Make guarantee payment to this contract
        require((IDoRacleToken(tokenAddress)).transferFrom(msg.sender, address(this), actions[_actionId].guarantee), "Transfer failed");

        actions[_actionId].executor = msg.sender;

        emit ActionTaken(_actionId);
    }

    function executeAction(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].executor == msg.sender, "Action not taken by executor");
        require(actions[_actionId].executedTimestamp == 0, "Action already executed");
        require(block.timestamp < actions[_actionId].executeDeadline, "Execute deadline passed");

        actions[_actionId].executedTimestamp = block.timestamp;

        emit ActionExecuted(_actionId);
    }

    function disputeAction(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(actions[_actionId].executor != address(0), "Action not taken");
        require(block.timestamp < actions[_actionId].disputeDeadline, "Dispute deadline passed");
        require(actions[_actionId].disputer == address(0), "Action already disputed");

        actions[_actionId].disputer = msg.sender;

        // Make dispute payment to this contract (same as guarantee)
        require((IDoRacleToken(tokenAddress)).transferFrom(msg.sender, address(this), actions[_actionId].guarantee), "Transfer failed");

        emit ActionDisputed(_actionId);
    }

    function settleAction(uint256 _actionId) public {
        require(_actionId < actions.length, "Action does not exist");
        require(block.timestamp >= actions[_actionId].disputeDeadline, "Dispute deadline not passed");

        if (actions[_actionId].executedTimestamp == 0 && actions[_actionId].disputer == address(0) && block.timestamp >= actions[_actionId].executeDeadline) {
            // Make reward and guarantee payment to requester as action was not executed by the deadline
            if (actions[_actionId].executor == address(0)) {
                require((IDoRacleToken(tokenAddress)).transfer(actions[_actionId].requester, actions[_actionId].reward), "Transfer failed");
            } else {
                require((IDoRacleToken(tokenAddress)).transfer(actions[_actionId].requester, actions[_actionId].reward + actions[_actionId].guarantee), "Transfer failed");
            }
        } else if (actions[_actionId].disputer != address(0)) {
            if (voteResult(_actionId)) {console.log("point 2");
                // Make reward payment to executor and return guarantee
                require((IDoRacleToken(tokenAddress)).transfer(actions[_actionId].executor, actions[_actionId].reward + actions[_actionId].guarantee), "Transfer failed");
            } else {
                // Make 2 * guarantee payment to disputer (return guarantee + executor guarantee)
                require((IDoRacleToken(tokenAddress)).transfer(actions[_actionId].disputer, 2 * actions[_actionId].guarantee), "Transfer failed");
                // Return reward to requester
                require((IDoRacleToken(tokenAddress)).transfer(actions[_actionId].requester, actions[_actionId].reward), "Transfer failed");
            }
        } else {
            // Make reward payment to executor and return guarantee
            require((IDoRacleToken(tokenAddress)).transfer(actions[_actionId].executor, actions[_actionId].reward + actions[_actionId].guarantee), "Transfer failed");
        }

        emit ActionExecuted(_actionId);
    }

    function getAction(uint256 _actionId) public view returns (TAction memory) {
        require(_actionId < actions.length, "Action does not exist");

        return actions[_actionId];
    }

    function getActionCount() public view returns (uint256) {
        return actions.length;
    }
}