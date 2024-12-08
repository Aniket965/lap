// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Console.sol";
import {FeesData} from "socket-protocol/contracts/common/Structs.sol";
import {ETH_ADDRESS} from "socket-protocol/contracts/common/Constants.sol";
import {WalletDeployer} from "../src/SmartWalletDeployer.sol";
contract SetupWallet is Script {
    function run() public {
        address addressResolver = vm.envAddress("ADDRESS_RESOLVER");

        string memory rpc = vm.envString("SOCKET_RPC");
        vm.createSelectFork(rpc);

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Setting fee payment on Ethereum Sepolia
        FeesData memory feesData = FeesData({
            feePoolChain: 11155111,
            feePoolToken: ETH_ADDRESS,
            maxFees: 0.01 ether
        });

        WalletDeployer myWalletDeployer = new WalletDeployer(
            addressResolver,
            feesData,
            0x75BA0717825Cf178bC49f84dd1D9F33298dFCCBf,
            0x926569D77C80ef9B8126D834F27c52220921cF97
        );

        console.log("myWalletDeployer: ", address(myWalletDeployer));
    }
}