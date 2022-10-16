// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721TradableBoxi.sol";

/**
 * @title MyNFT
 * Creature - a contract for my non-fungible creatures.
 */
contract BoxiNFT is ERC721TradableBoxi {
    constructor(
        string memory _name,
        string memory _symbol,
        address _proxyRegistryAddress
    )
    ERC721TradableBoxi(_name, _symbol, _proxyRegistryAddress)
    {}
}