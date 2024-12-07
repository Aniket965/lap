//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IDefiProtocol {
    function utilizeLiquidity(address token, uint256 amount) external returns (uint256);
}

interface IAccount {
    function isValidSignature(bytes32 _hash, bytes calldata _signature) external view returns (bytes4);
    function provideLiquidity (
        bytes calldata userSignature,
        bytes32 hash,
        Token[] calldata tokens
  ) external;
}


struct Token {
    uint256 chainId;
    address token;
    uint256 amount;
}

struct UserTokenLiquidity {
    Token[] tokens;
    IAccount account;
    bytes userSignature;
}

struct AccountLiquidity {
    Token[] tokens;
    address account;
    bytes userSignature;
    uint256 userNonce;
}

struct AuctionedLiquidity {
    AccountLiquidity[] accounts;
    uint256[] rewards;
    address liquidityToken;
    uint256 liquidityAmount;
    address defiProtocol;
    uint256 deadline;
    address solverAddress;
    uint256 solverReward;
    address rewardToken;
    bytes auctionSignature;
    uint256 auctionNonce;
}


interface ILiquidityAuctionProtocol {
    function useLiquidity(AuctionedLiquidity calldata auction) external;
}