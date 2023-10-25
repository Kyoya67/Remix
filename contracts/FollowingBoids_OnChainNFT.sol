// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "./makeMeta.sol";

/// @title 時間で成長するフルオンチェーンNFT
/// @dev time-basedを使う
contract FollowingBoids_OnChainNFT is ERC721, ERC721URIStorage, Ownable, makeMeta{
    /// @dev Countersライブラリの全Functionを構造体Counter型に付与
    using Counters for Counters.Counter;
    // 付与したCounter型の変数_tokenIdCounterを定義
    Counters.Counter private _tokenIdCounter;
    constructor() ERC721("FollowingBoids_OnChainNFT", "FBON") {}
    /**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - tokenIdをインクリメント
     * - nftMint関数の実行アドレスにtokenIdを紐づけ
     * - mintの際にURIを設定
     * - EVENT発火 emit TokenURIChanged
    */

    function R_Generator(uint256 tokenId) public view returns (uint256) {
        // 直近のブロックハッシュを取得
        bytes32 blockHash = keccak256(abi.encodePacked(tokenId, block.timestamp));
        
        // ブロックハッシュをuint256に変換
        uint256 randomSeed = uint256(blockHash);
        
        // 0から99の範囲のランダムな整数を生成
        uint256 result = randomSeed % 256;
        
        return result;
    }

    function G_Generator(uint256 tokenId) public view returns (uint256) {
        // 直近のブロックハッシュを取得
        bytes32 blockHash = keccak256(abi.encodePacked(tokenId, block.number));
        
        // ブロックハッシュをuint256に変換
        uint256 randomSeed = uint256(blockHash);
        
        // 0から99の範囲のランダムな整数を生成
        uint256 result = randomSeed % 256;
        
        return result;
    }

    function B_Generator(uint256 tokenId) public pure returns (uint256) {
        // 直近のブロックハッシュを取得
        bytes32 blockHash = keccak256(abi.encodePacked(tokenId));
        
        // ブロックハッシュをuint256に変換
        uint256 randomSeed = uint256(blockHash);
        
        // 0から99の範囲のランダムな整数を生成
        uint256 result = randomSeed % 256;
        
        return result;
    }

    function nftMint() public onlyOwner{
        // tokenIdを1増やす。tokenIdは1から始まる
        _tokenIdCounter.increment();
        // 現時点のtokenIdを取得
        uint tokenId = _tokenIdCounter.current();
        uint256 R = R_Generator(tokenId);
        uint256 G = G_Generator(tokenId);
        uint256 B = B_Generator(tokenId);
        string memory metadata = string(abi.encodePacked("data:application/json;base64,",Base64.encode(makeMetaData(tokenId,R,G,B))));
        // NFTmint
        _mint(msg.sender, tokenId);
        // tokenURIを設定
        _setTokenURI(tokenId, metadata);

    }

    /// @dev 以下は全てoverride重複の整理
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage){
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns(string memory) {
        return super.tokenURI(tokenId);
    }
}
