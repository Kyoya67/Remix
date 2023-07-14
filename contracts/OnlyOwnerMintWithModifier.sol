// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 < 0.9.0;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";


contract OnlyOwnerMintWithModifier is ERC721{

    //このコントラクトをデプロイしたアドレス用変数owner
    address public owner; 

    constructor() ERC721("OnlyOwnerMintWithModifier", "OWNERMOD") {
        owner = _msgSender();
    }

/**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけに制御する modifier
    */
    modifier onlyOwner {
        require(_msgSender() == owner, "Caller is not the owner");
        _;
    }

    /**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - nftMint関数の実行アドレスにtokenIdを紐づけ
    */
    function nftMint(uint256 tokenId) public onlyOwner{
        _mint(_msgSender(), tokenId);
    }
}

