//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "socket-protocol/contracts/base/AppDeployerBase.sol";
import "./LiquidityAuctionProtocol.sol";

contract LapDeployer is AppDeployerBase  {
    bytes32 contractId = _createContractId("lap");
    constructor(
        address addressResolver_,
        FeesData memory feesData_,
        address userAddress
    ) AppDeployerBase(addressResolver_) {
        creationCodeWithArgs[contractId] = abi.encodePacked(
            type(LiquidityAuctionProtocol).creationCode,
            abi.encode(userAddress)
        );
        _setFeesData(feesData_);
    }

    function deployContracts(uint32 chainSlug ) external async {
        _deploy(contractId, chainSlug);
    }

    function initialize(uint32 chainSlug) public override async {}

    

}