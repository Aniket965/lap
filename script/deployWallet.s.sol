// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SmartWallet} from "../src/SmartWallet.sol";

contract DeploySmartWallet is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        vm.startBroadcast(deployerPrivateKey);

        SmartWallet wallet =
            new SmartWallet(0x2C9031f83b6D3dF09f05738cA61a12263D546EA8, 0x926569D77C80ef9B8126D834F27c52220921cF97);
        console.log("wallet: ", address(wallet));
    }
}
