// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {LapDeployer} from "../src/LiquidityAuctionProtocolDeployer.sol";

contract DeploySmartWallet is Script {
    function run() public {
        string memory rpc = vm.envString("SOCKET_RPC");
        vm.createSelectFork(rpc);

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        LapDeployer myLapDeployer = LapDeployer(0x15A66a5f6F212D5FdcF4834fb89b116ac7e30B11);
        
        myLapDeployer.deployContracts(84532);
        myLapDeployer.deployContracts(11155420);
        myLapDeployer.deployContracts(421614);
    }
}