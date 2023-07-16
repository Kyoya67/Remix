// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";



contract OnURIUnchangable is ERC721URIStorage, Ownable {

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

    constructor() ERC721("OnURIUnchangable", "ONU") {}

    /**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - tokenIdをインクリメント
     * - nftMint関数の実行アドレスにtokenIdを紐づけ
     * - mintの際にURIを設定
     * - EVENT発火 emit TokenURIChanged
    */
    function nftMint() public onlyOwner{
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        string memory imageData = '\
            <svg viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg">\
                <circle cx="100" cy="100" r="90" fill="yellow" stroke="black" stroke-width="2" />\
                <circle cx="80" cy="80" r="15" fill="black" />\
                <circle cx="120" cy="80" r="15" fill="black" />\
                <path d="M80 130 Q100 150 120 130" fill="none" stroke="black" stroke-width="3" />\
            </svg>\
        ';


        bytes memory metaData = abi.encodePacked(
            '{"name":"',
            'SmileOnchainNFT #',
            Strings.toString(newTokenId),
            '","description":"My full on chain NFT",',
            '"image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(imageData)),
            '"}'
        );

        string memory uri = string(abi.encodePacked("data:application/json;base64,",Base64.encode(metaData)));

        _mint(_msgSender(), newTokenId);

        _setTokenURI(newTokenId, uri);
        
        emit TokenURIChanged(_msgSender(), newTokenId, uri);
    }

    
}



