// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";


contract OZOnlyOwnerMint is ERC721, Ownable {

    constructor() ERC721("OZOnlyOwnerMint", "OWNERMOD") {}

    /**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - nftMint関数の実行アドレスにtokenIdを紐づけ
    */
    function nftMint(uint256 tokenId) public onlyOwner{
        _mint(_msgSender(), tokenId);
    }
}



