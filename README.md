# MonadTokenWallet Smart Contract

## Overview

`MonadTokenWallet` is a Solidity smart contract that provides a secure token wallet functionality for ERC20 tokens. It allows users to deposit, withdraw, and track their token balances, with built-in security features.

## Features

- Token deposit and withdrawal
- Balance tracking
- Token address management
- Reentrancy protection
- Owner-controlled contract
- Event logging for key actions

## Dependencies

- OpenZeppelin Contracts:
  - `@openzeppelin/contracts/token/ERC20/IERC20.sol`
  - `@openzeppelin/contracts/utils/ReentrancyGuard.sol`
  - `@openzeppelin/contracts/access/Ownable.sol`

## Contract Functions

### Constructor
- `constructor(address _tokenAddress)`: Initializes the contract with a specific ERC20 token address
- Requires a valid token address
- Sets contract owner to the deployer

### `deposit(uint _amount)`
- Allows users to deposit tokens into the wallet
- Requires amount > 0
- Transfers tokens from user to contract
- Updates user balance
- Emits `Deposit` event

### `withdraw(uint _amount)`
- Allows users to withdraw tokens from the wallet
- Requires amount > 0 and sufficient balance
- Transfers tokens from contract to user
- Updates user balance
- Emits `Withdraw` event

### `getBalance(address _user)`
- Returns the token balance for a specific user

### `addToken(address _tokenAddress)`
- Allows users to add new token addresses to their wallet
- Requires a valid token address
- Emits `AddToken` event

## Events

- `Deposit(address indexed _user, uint _amount, uint _timestamp)`: Logged when tokens are deposited
- `Withdraw(address indexed _user, uint _amount, uint _timestamp)`: Logged when tokens are withdrawn
- `AddToken(address indexed _user, address indexed _tokenAddress)`: Logged when a new token is added

## Security Considerations

- Uses OpenZeppelin's `ReentrancyGuard` to prevent reentrancy attacks
- Implements `Ownable` for contract management
- Validates token addresses and transaction amounts
- Uses `transferFrom` and `transfer` with failure checks

## License

MIT License

## Disclaimer

This contract is provided as-is. Always audit and test thoroughly before deployment.
