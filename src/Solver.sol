//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {UserTokenLiquidity, AuctionedLiquidity, AccountLiquidity, IAccount, ILiquidityAuctionProtocol} from "./LAPStruct.sol";
contract LiquidityAuctionSolver {
    address public  liquiditiyAuctionProtocol;
    address public owner;

    constructor(address _liquidityAuctionProtocol) {
        owner = msg.sender;
        liquiditiyAuctionProtocol = _liquidityAuctionProtocol;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    function solveAuction(AuctionedLiquidity memory auctioned) external isOwner {
       /// do some magic get some extra tokens
       ILiquidityAuctionProtocol(liquiditiyAuctionProtocol).useLiquidity(auctioned);
       // do some magic again whatever you want
    }
}