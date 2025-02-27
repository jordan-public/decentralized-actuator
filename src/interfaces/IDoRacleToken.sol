// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";

interface IDoRacleToken is IERC20Metadata {
    function mint(uint256 amount) external;
    function setProtocol(address _protocol) external;
    function owner() external view returns (address);
    function protocol() external view returns (address);
}