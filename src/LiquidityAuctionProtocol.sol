//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

import {
    UserTokenLiquidity, AuctionedLiquidity, AccountLiquidity, IAccount, IDefiProtocol, Token
} from "./LAPStruct.sol";

import "solady/tokens/ERC20.sol";

contract LiquidityAuctionProtocol {
    // State Variables
    address public immutable owner;
    uint256 public auctionNonce = 0;

    constructor(address _owner) {
        owner = _owner;
    }

    // Modifier: used to define a set of rules that must be met before or after a function is executed
    // Check the withdraw() function
    modifier isOwner() {
        // msg.sender: predefined variable that represents address of the account that called the current function
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    /**
     * Function that allows the contract to receive ETH
     */
    receive() external payable {}

    function hashTokens(UserTokenLiquidity calldata liquidity) public pure returns (bytes32) {
        bytes32 hash = keccak256(abi.encode(liquidity.account));
        return hash;
    }

    function useLiquidity(AuctionedLiquidity calldata auction) external payable {
        for (uint256 i = 0; i < auction.accounts.length; i++) {
            bytes32 hashID = keccak256(abi.encode(auction.accounts[i].account));
            IAccount(auction.accounts[i].account).provideLiquidity(
                auction.accounts[i].userSignature, hashID, auction.accounts[i].tokens
            );
        }
        for (uint256 i = 0; i < auction.accounts.length; i++) {
            AccountLiquidity calldata account = auction.accounts[i];
            _transferTokensFromAccounts(account);
        }
        ERC20(auction.liquidityToken).approve(auction.defiProtocol, auction.liquidityAmount);
        IDefiProtocol(auction.defiProtocol).utilizeLiquidity(auction.liquidityToken, auction.liquidityAmount);
        for (uint256 i = 0; i < auction.accounts.length; i++) {
            AccountLiquidity calldata account = auction.accounts[i];
            _transferTokensToAccountsAndRewards(account, auction.rewards[i], auction.rewardToken);
        }

        ERC20(auction.rewardToken).transfer(auction.solverAddress, auction.solverReward);
    }

    function _transferTokensFromAccounts(AccountLiquidity calldata account) internal {
        for (uint256 i = 0; i < account.tokens.length; i++) {
            Token calldata token = account.tokens[i];
            ERC20(token.token).transferFrom(account.account, address(this), token.amount);
        }
    }

    function _transferTokensToAccountsAndRewards(AccountLiquidity calldata account, uint256 reward, address rewardToken)
        internal
    {
        for (uint256 i = 0; i < account.tokens.length; i++) {
            Token calldata token = account.tokens[i];
            ERC20(token.token).transfer(account.account, token.amount);
        }
        ERC20(rewardToken).transfer(account.account, reward);
    }
}
