// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DefiProtocol} from "../src/DefiProtocol.sol";

contract DeployDefiProtocol is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        vm.startBroadcast(deployerPrivateKey);

        DefiProtocol defi = new DefiProtocol();
        console.log("Defi Protocol: ", address(defi));
    }
}