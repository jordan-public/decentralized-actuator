// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../types/TAction.sol";

interface IDoRacle {

    function owner() external view returns (address);
    function tokenAddress() external view returns (address);
    function votes(uint256 _actionId, address _voter) external view returns (uint8);

    function requestAction(string memory _description, uint256 _reward, uint256 _guarantee, uint256 _executeDeadline, uint256 _disputeDeadline, uint256 _voteDeadline) external;
    function vote(uint256 _actionId, bool executed) external;
    function voteResult(uint256 _actionId) external view returns (bool executed);
    function claimVoterReward(uint256 _actionId) external;
    function takeAction(uint256 _actionId) external;
    function executeAction(uint256 _actionId) external;
    function disputeAction(uint256 _actionId) external;
    function settleAction(uint256 _actionId) external;
    function getAction(uint256 _actionId) external view returns (TAction memory);
    function getActionsCount() external view returns (uint256);

    event ActionRequested(uint256 actionId, string description);
    event Voted(uint256 actionId, address voter);
    event ActionTaken(uint256 actionId);
    event ActionExecuted(uint256 actionId);
    event ActionDisputed(uint256 actionId);
}