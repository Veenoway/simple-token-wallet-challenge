// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/YourContract.sol"; 
import "./DeployHelpers.s.sol";

contract DeployYourContract is ScaffoldETHDeploy {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MonadTokenWallet monadTokenWallet = new MonadTokenWallet(msg.sender);
        console.logString("MonadTokenWallet deployed at:");
        console.logAddress(address(monadTokenWallet));

        vm.stopBroadcast();
    }
}