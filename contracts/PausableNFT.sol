// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";




contract PausableNFT is ERC721URIStorage, Ownable {

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

    constructor() ERC721("PausableNFT", "PAUSE") {}

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

        _mint(_msgSender(), newTokenId);

        string memory jsonFile = string(abi.encodePacked(Strings.toString(newTokenId), '.json'));
        _setTokenURI(newTokenId, jsonFile);
        emit TokenURIChanged(_msgSender(), newTokenId, jsonFile);
    }


    /**
     * @dev
     * - URLプレフィックスの設定
    */
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://bafybeigyod7ldrnytkzrw45gw2tjksdct6qaxnsc7jdihegpnk2kskpt7a/metadata";
    }
    
}


