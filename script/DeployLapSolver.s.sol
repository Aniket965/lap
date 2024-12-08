// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {LiquidityAuctionSolver} from "../src/Solver.sol";

contract DeploySmartWallet is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER");
        vm.startBroadcast(deployerPrivateKey);

        LiquidityAuctionSolver solver =
            new LiquidityAuctionSolver(0x926569D77C80ef9B8126D834F27c52220921cF97);
        console.log("solver Address: ", address(solver));
    }
}
