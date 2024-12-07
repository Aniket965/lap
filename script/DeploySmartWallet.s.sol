// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {WalletDeployer} from "../src/SmartWalletDeployer.sol";

contract DeploySmartWallet is Script {
    function run() public {
        string memory rpc = vm.envString("SOCKET_RPC");
        vm.createSelectFork(rpc);

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        WalletDeployer myWalletDeployer = WalletDeployer(0xd7B1C1C9E52828aceEeeAB2B7e4d9a670967cD2B);

        bytes32 walletId = keccak256(abi.encode("wallet", 0x75BA0717825Cf178bC49f84dd1D9F33298dFCCBf));
        myWalletDeployer.deployContracts(84532, walletId);
        myWalletDeployer.deployContracts(11155420, walletId);
        myWalletDeployer.deployContracts(421614, walletId);
    }
}