// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Novee Mock", "NOVE") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}

contract MonadTokenWalletTest is Test {
  
    event AddToken(address indexed user, address indexed tokenAddress);

    MonadTokenWallet public wallet;
    MockERC20 public token;
    address public owner;
    address public user;

    function setUp() public {
        token = new MockERC20();
        owner = address(this);
        user = address(0x1);
        wallet = new MonadTokenWallet(address(token));
        
        token.transfer(user, 1000 * 10**18);
    }

    function testDeposit() public {
        vm.startPrank(user);
        uint256 tokenBalanceBefore = token.balanceOf(user);
        token.approve(address(wallet), 100 * 10**18);
        wallet.deposit(100 * 10**18);
        uint256 tokenBalanceAfter = token.balanceOf(user);
        vm.stopPrank();

        assertEq(tokenBalanceBefore - tokenBalanceAfter, 100 * 10**18);
        assertEq(wallet.getBalance(user), 100 * 10**18);
    }

    function testWithdraw() public {
        vm.startPrank(user);
        token.approve(address(wallet), 100 * 10**18);
        wallet.deposit(100 * 10**18);
        wallet.withdraw(50 * 10**18);
        vm.stopPrank();

        assertEq(wallet.getBalance(user), 50 * 10**18);
    }

    function testFailWithdrawTooMuch() public {
        vm.startPrank(user);
        token.approve(address(wallet), 100 * 10**18);
        wallet.deposit(100 * 10**18);
        wallet.withdraw(150 * 10**18);
        vm.stopPrank();
    }

    function testAddToken() public {
        address newTokenAddress = address(new MockERC20());
        vm.prank(user);
        vm.expectEmit(true, true, false, true);
        emit AddToken(user, newTokenAddress);
        wallet.addToken(newTokenAddress);
    }

    function testFailAddInvalidToken() public {
        vm.prank(user);
        wallet.addToken(address(0));
    }
}