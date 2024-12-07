//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
struct Token {
  uint256 amount;
  address token;
}

import "solady/tokens/ERC20.sol";

contract SmartWallet {
  // State Variables
  address public immutable owner;
  address public immutable liquidityAuctionProtocol;
  string public version = "1.0.0";

  event LiquidityProvided(address token, uint256 amount, address userAddress);
  constructor(address _owner, address _liquidityAuctionProtocol) {
    owner = _owner;
    liquidityAuctionProtocol = _liquidityAuctionProtocol;
  }

  // Modifier: used to define a set of rules that must be met before or after a function is executed
  // Check the withdraw() function
  modifier isOwner() {
    // msg.sender: predefined variable that represents address of the account that called the current function
    require(msg.sender == owner, "Not the Owner");
    _;
  }


  modifier isLiquidityAuctionProtocol() {
    require(msg.sender == liquidityAuctionProtocol, "Not the LiquidityAuctionProtocol");
    _;
  }


  /**
   * Function that allows the contract to receive ETH
   */
  receive() external payable { }

  function call(
    address _to,
    bytes calldata _data
  ) external isOwner {
    // Low-level call
    (bool success, bytes memory data) = _to.call(_data);
    require(success, "Call failed");
  }

  function delegateCall(
    address _to,
    bytes calldata _data
  ) external isOwner {
    // Low-level delegatecall
    (bool success, bytes memory data) = _to.delegatecall(_data);
    require(success, "Delegatecall failed");
  }

  function provideLiquidity (
    bytes calldata userSignature,
    bytes32 hash,
    Token[] calldata tokens
  ) external isLiquidityAuctionProtocol {
    // Validate signatures
    if (recoverSigner(hash, userSignature) != owner) {
      revert("Invalid Signature");
    }

    // Transfer tokens to the contract
    for (uint256 i = 0; i < tokens.length; i++) {
      ERC20(tokens[i].token).approve(liquidityAuctionProtocol, tokens[i].amount);
      emit LiquidityProvided(tokens[i].token, tokens[i].amount, owner);
    }
  }

  function isValidSignature(
    bytes32 _hash,
    bytes calldata _signature
  ) external view returns (bytes4) {
    // Validate signatures
    if (recoverSigner(_hash, _signature) == owner) {
      return 0x1626ba7e;
    } else {
      return 0xffffffff;
    }
  }


   /**
   * @notice Recover the signer of hash, assuming it's an EOA account
   * @dev Only for EthSign signatures
   * @param _hash       Hash of message that was signed
   * @param _signature  Signature encoded as (bytes32 r, bytes32 s, uint8 v)
   */
  function recoverSigner(
    bytes32 _hash,
    bytes memory _signature
  ) internal pure returns (address signer) {
    require(_signature.length == 65, "SignatureValidator#recoverSigner: invalid signature length");

    // Variables are not scoped in Solidity.
    uint8 v = uint8(_signature[64]);
    bytes32 r;
    bytes32 s;
    assembly {
        r := mload(add(_signature, 32))
        s := mload(add(_signature, 64))
    }

    // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
    // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
    // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
    // signatures from current libraries generate a unique signature with an s-value in the lower half order.
    //
    // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
    // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
    // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
    // these malleable signatures as well.
    //
    // Source OpenZeppelin
    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol

    if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
      revert("SignatureValidator#recoverSigner: invalid signature 's' value");
    }

    if (v != 27 && v != 28) {
      revert("SignatureValidator#recoverSigner: invalid signature 'v' value");
    }

    // Recover ECDSA signer
    signer = ecrecover(_hash, v, r, s);
    
    // Prevent signer from being 0x0
    require(
      signer != address(0x0),
      "SignatureValidator#recoverSigner: INVALID_SIGNER"
    );

    return signer;
  }
}
