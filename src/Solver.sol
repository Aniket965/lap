//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {
    UserTokenLiquidity,
    AuctionedLiquidity,
    AccountLiquidity,
    IAccount,
    ILiquidityAuctionProtocol
} from "./LAPStruct.sol";

contract LiquidityAuctionSolver {
    address public liquidityAuctionProtocol;
    address public owner;

    constructor(address _liquidityAuctionProtocol) {
        owner = msg.sender;
        liquidityAuctionProtocol = _liquidityAuctionProtocol;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    // ONLY FOR HACKATHON PURPOSES
    function changeLAP(address _liquidityAuctionProtocol) external {
        liquidityAuctionProtocol = _liquidityAuctionProtocol;
    }

    function solveAuction(AuctionedLiquidity memory auctioned) external isOwner {
        /// do some magic get some extra tokens
        ILiquidityAuctionProtocol(liquidityAuctionProtocol).useLiquidity(auctioned);
        // do some magic again whatever you want
    }
}
