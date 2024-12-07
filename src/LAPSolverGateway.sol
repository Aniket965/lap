//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {UserTokenLiquidity, AuctionedLiquidity, AccountLiquidity, IAccount, ILiquidityAuctionProtocol} from "./LAPStruct.sol";

import "socket-protocol/contracts/base/AppGatewayBase.sol";
contract LapSolverGatway is AppGatewayBase {
    address public forwarder;
	constructor(address forwarder, address resolverAddress) AppGatewayBase(resolverAddress) {
	}

    function solveAuction(AuctionedLiquidity memory auctioned) external  {
       /// do some magic get some extra tokens
       ILiquidityAuctionProtocol(forwarder).useLiquidity(auctioned);
       // do some magic again whatever you want
    }
}