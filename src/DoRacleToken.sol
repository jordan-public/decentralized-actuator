// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;
//import "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";
import "./interfaces/IDoRacleToken.sol";

contract DoRacleToken is IDoRacleToken {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    address public protocol;

    constructor () {
        name = "DoRacle Token";
        symbol = "DOR";
        decimals = 18;
        totalSupply = 0;
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) public {
        require(msg.sender == owner || msg.sender == protocol, "Unauthorized");
        totalSupply += amount;
        require(totalSupply <= 10**6 * 10**decimals, "Total supply cannot exceed 1 million");
        balanceOf[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function setProtocol(address _protocol) public {
        require(msg.sender == owner, "Only owner can set protocol");
        protocol = _protocol;
    }
}
