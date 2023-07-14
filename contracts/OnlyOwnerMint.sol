// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 < 0.9.0;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";


contract OnlyOwnerMint is ERC721{

    //このコントラクトをデプロイしたアドレス用変数owner
    address public owner; 

    constructor() ERC721("OnlyOwnerMint", "OWNER") {
        owner = _msgSender();
    }

    /**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 require
     * - nftMint関数の実行アドレスにtokenIdを紐づけ
    */
    function nftMint(uint256 tokenId) public {
        require(owner == _msgSender(), "Caller is not the owner.");
        _mint(_msgSender(), tokenId);
    }
}

