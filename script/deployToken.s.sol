// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {USDC} from "../src/USDC.sol";

contract DeploySmartWallet is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        vm.startBroadcast(deployerPrivateKey);

        USDC token = new USDC("USD Coin", "USDC", 6);
        console.log("USDC Token: ", address(token));
    }
}