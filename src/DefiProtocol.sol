//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "solady/tokens/ERC20.sol";
import {Token} from "./LAPStruct.sol";
contract DefiProtocol {
 uint256 public rewardForLiquidity = 5000000;

 function utilizeLiquidity(
    address token,
    uint256 amount
 ) external returns (uint256) {
    ERC20(token).transferFrom(msg.sender, address(this), amount);
    // do some magic
    // earn yield

    ERC20(token).transfer(msg.sender, rewardForLiquidity + amount);
    return rewardForLiquidity;
 }
}
