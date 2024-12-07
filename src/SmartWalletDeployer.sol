//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "socket-protocol/contracts/base/AppDeployerBase.sol";
import "./SmartWallet.sol";

contract WalletDeployer is AppDeployerBase  {
    // bytes32 walletId = _createContractId("wallet");
    constructor(
        address addressResolver_,
        FeesData memory feesData_,
        address userAddress
    ) AppDeployerBase(addressResolver_) {
          bytes32 walletId = keccak256(abi.encode("wallet", 0x7554d18FBfebcd4bFF4Df97479262715a2203C8a));
        creationCodeWithArgs[walletId] = abi.encodePacked(
            type(SmartWallet).creationCode,
            abi.encode(userAddress)
        );
        _setFeesData(feesData_);
    }

    function deployContracts(uint32 chainSlug, bytes32 walletId ) external async {
        _deploy(walletId, chainSlug);
    }

    function deployContracts(uint32 chainSlug ) external async {
        _deploy(bytes32(0), chainSlug);
    }

    function initialize(uint32 chainSlug) public override async {}

}