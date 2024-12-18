// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MonadTokenWallet is ReentrancyGuard, Ownable {

  event Deposit(address indexed _user, uint _amount, uint _timestamp);
  event Withdraw(address indexed _user, uint _amount, uint _timestamp);
  event AddToken(address indexed user, address indexed tokenAddress);   

  IERC20 public token;

  mapping(address => mapping(address => bool)) private userTokens;
  mapping(address => uint) private balances;
  
  /**
    * @dev Constructor => set ERC20 token address
    * @param _tokenAddress ERC20 token address
  */

  constructor(address _tokenAddress) Ownable(msg.sender) {
      if(_tokenAddress != address(0)) revert("Invalid token address");
      token = IERC20(_tokenAddress);
  }

  /**
    * @dev Deposit tokens to wallet
    * @param _amount Deposit amount
  */

  function deposit(uint _amount) external nonReentrant {
    if(_amount == 0) revert("Amount must be greater than 0");
    if(!token.transferFrom(msg.sender, address(this), _amount)) revert("Transfer failed");

    balances[msg.sender] += _amount;
    emit Deposit(msg.sender,_amount, block.timestamp);
  }

  /**
    * @dev Withdraw tokens from wallet
    * @param _amount Amount withdrawn
  */

  function withdraw(uint _amount) external nonReentrant {
    if(_amount == 0) revert("Amount must be greater than 0");
    if(balances[msg.sender] < _amount) revert("Insuficient balance");

    balances[msg.sender] -= _amount;
    if (!token.transfer(msg.sender, amount)) revert("Transfer failed");
    emit Withdraw(msg.sender, _amount, block.timestamp);
  }

  /**
    * @dev Get Token balance
    * @return User token balance
  */

  function getBalance() external view returns(uint) {
    return balances[msg.sender];
  }

  /**
    * @dev Add new token to user wallet
    * @param _tokenAddress Address of token to add
    * @notice Allows users to add new token to their own wallet
  */

  function addToken(address _tokenAddress) external {
    if(_tokenAddress == address(0)) revert("Invalid token address");
    userTokens[msg.sender][_tokenAddress] = true;
    emit AddToken(msg.sender, _tokenAddress);
  }
  
}