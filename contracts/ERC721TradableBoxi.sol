// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./common/meta-transactions/ContentMixin.sol";
import "./common/meta-transactions/NativeMetaTransaction.sol";


/**
 * @title ERC721TradableBoxi
 * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
 */
/*
   by boxi
*/
abstract contract ERC721TradableBoxi is ERC721URIStorage, ContextMixin, NativeMetaTransaction, Ownable {
    address proxyRegistryAddress;

    constructor(
        string memory _name,
        string memory _symbol,
        address _proxyRegistryAddress
    ) ERC721(_name, _symbol) {
        proxyRegistryAddress = _proxyRegistryAddress;
        _initializeEIP712(_name);
    }

    // if OpenSea's ERC721 Proxy Address is detected, auto-return true
    // for Polygon's Mumbai testnet, use 0xff7Ca10aF37178BdD056628eF42fD7F799fAc77c
    // 可以设置 opensea 的代理合约地址
    function setProxyAddress(address _newProxyAddress) public onlyOwner {
        proxyRegistryAddress = _newProxyAddress;
    }

    // get proxyAddress
    function getProxyAddress() public view returns (address){
        return proxyRegistryAddress;
    }


    /**
     * @dev Mints a token to an address with a tokenURI.
     * @param _to address of the future owner of the token
     */
    function mintNFT(address _to, uint256 _tokenId, string memory _tokenURI) public onlyOwner{
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
    }


    /**
     * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
     */
    function isApprovedForAll(address _owner, address _operator)
    override
    public
    view
    returns (bool)
    {
        // Whitelist OpenSea proxy contract for easy trading.
        // if OpenSea's ERC721 Proxy Address is detected, auto-return true  mainnet:0x58807baD0B376efc12F5AD86aAc70E78ed67deaE
        // for Polygon's Mumbai testnet, use 0xff7Ca10aF37178BdD056628eF42fD7F799fAc77c
        if (_operator == proxyRegistryAddress) {
            return true;
        }

        return super.isApprovedForAll(_owner, _operator);
    }

    /**
     * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
     */

    /**
    * 这是用来代替 msg.sender 的，因为交易不会由原始令牌所有者发送，而是由 OpenSea 发送。
    */
    function _msgSender()
    internal
    override
    view
    returns (address sender)
    {
        return ContextMixin.msgSender();
    }
}
