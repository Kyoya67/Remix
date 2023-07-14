// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";



contract CounterNFT is ERC721URIStorage, Ownable {

    /**
     *@dev
     * - _tokenIdsはCountersの全関数が利用可能
    */
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
     *@dev
     * - URI設定時に誰がどのtokenIdに何のURIを設定したかを記録する。
    */
    event TokenURIChanged(address indexed sender, uint256 indexed tokenId, string uri);

    constructor() ERC721("CounterNFT", "COUT") {}

    /**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - tokenIdをインクリメント
     * - nftMint関数の実行アドレスにtokenIdを紐づけ
     * - mintの際にURIを設定
     * - EVENT発火 emit TokenURIChanged
    */
    function nftMint(string calldata uri) public onlyOwner{
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(_msgSender(), newTokenId);
        _setTokenURI(newTokenId, uri);
        emit TokenURIChanged(_msgSender(), newTokenId, uri);
    }
}



