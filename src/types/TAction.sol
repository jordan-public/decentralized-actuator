// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;


struct TAction {
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