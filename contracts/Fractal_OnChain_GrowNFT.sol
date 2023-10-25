// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";


/// @title 時間で成長するフルオンチェーンNFT
/// @dev time-basedを使う
contract Fractal_OnChain_GrowNFT is ERC721, ERC721URIStorage, Ownable {
    /// @dev Countersライブラリの全Functionを構造体Counter型に付与
    using Counters for Counters.Counter;
    
    // 付与したCounter型の変数_tokenIdCounterを定義
    Counters.Counter private _tokenIdCounter;

    /// @dev stage設定
    enum Stages {one, two, three, four, five, six}

    /// mint時に設定する成長ステップを定数化
    Stages public constant firstStage = Stages.one;

    /// tokenIdと現stageをマッピングする変数を定義
    mapping(uint => Stages) public tokenStage;

    /// @dev NFTmint時は特定のURIを指定する
    uint256 public start = 1;

    /// @dev URI更新時に記録する
    event UpdateTokenURI(address indexed sender, uint256 indexed tokenId, string uri);

    constructor() ERC721("Fractal_OnChain_GrowNFT", "FOG") {}

    function makeMetaData(uint256 value, uint256 tokenId) public pure returns(bytes memory) {

        bytes memory ArtWorkData = abi.encodePacked(
        '<!DOCTYPE html>',
        '<html>',
        '  <head>',
        '    <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.5.0/p5.min.js"></script>',
        '    <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.7.3/addons/p5.sound.min.js"></script>',
        '    <link rel="stylesheet" type="text/css" href="style.css" />',
        '    <meta charset="utf-8" />',
        '  </head>',
        '  <body>',
        '    <script>',
        '      let tree = [];',
        '        leaves = [];',
        '        time = ',
        Strings.toString(value),
        ';',
        '        count = 0;',
        '        thickness = 28;',
        '        thickRate = 0.8;',
        '        rad = 8;',
        '        fluc = 0.1;',
        '        length = 200;',
        '      function setup() {',
        '        createCanvas(600, 600);',
        '        let a = createVector(width / 2, height);',
        '          b = createVector(width / 2, height - length);',
        '          root = new Branch(a, b, 0);',
        '        tree[0] = root;',
        '      }',
        '      function grow() {',
        '        for (let i = tree.length - 1; i >= 0; i--) {',
        '          if (!tree[i].finished) {',
        '            tree.push(tree[i].branchA());',
        '            tree.push(tree[i].branchB());',
        '          }',
        '          tree[i].finished = true;',
        '        }',
        '        count++;',
        '        if (count === 8) {',
        '          for (var i = 0; i < tree.length; i++) {',
        '            if (!tree[i].finished) {',
        '              let leaf = tree[i].end.copy();',
        '              leaves.push(leaf);',
        '            }',
        '          }',
        '        }',
        '      }',
        '      let cont = 0;',
        '      function draw() {',
        '        background(\'#FFCE7B\');',
        '        if (count++ == 0)',
        '          for (var i = 0; i < time; i++) {',
        '            grow();',
        '          }',
        '        for (var i = 0; i < tree.length; i++) {',
        '          tree[i].show(i);',
        '        }',
        '        for (var i = 0; i < leaves.length; i++) {',
        '          fill(\'#30583B\');',
        '          noStroke();',
        '          ellipse(leaves[i].x, leaves[i].y, 20, 20);',
        '        }',
        '        noLoop();',
        '      }',
        '      class Branch {',
        '        constructor(begin, end) {',
        '          this.begin = begin;',
        '          this.end = end;',
        '          this.finished = false;',
        '        }',
        '        show(i) {',
        '          stroke(\'#892F1B\');',
        '          strokeWeight(thickness * Math.pow(thickRate, log(i + 2) / log(2)));',
        '          line(this.begin.x, this.begin.y, this.end.x, this.end.y);',
        '        }',
        '        fluc() {',
        '          this.end.x += random(-fluc, fluc);',
        '          this.end.y += random(-fluc, fluc);',
        '        }',
        '        branchA() {',
        '          let dir = p5.Vector.sub(this.end, this.begin);',
        '          dir.rotate(PI / rad);',
        '          dir.mult(0.67);',
        '          let newEnd = p5.Vector.add(this.end, dir);',
        '          let b = new Branch(this.end, newEnd);',
        '          return b;',
        '        }',
        '        branchB() {',
        '          let dir = p5.Vector.sub(this.end, this.begin);',
        '          dir.rotate(-PI / rad);',
        '          dir.mult(0.67);',
        '          let newEnd = p5.Vector.add(this.end, dir);',
        '          let b = new Branch(this.end, newEnd);',
        '          return b;',
        '        }',
        '      }',
        '    </script>',
        '  </body>',
        '</html>'
        );

        bytes memory metadata =abi.encodePacked(
            '{"name":"',
            'Fractal_OnChain_GrowNFT #',
            Strings.toString(tokenId),
            '","description":"My full on chain NFT",',
            '"animation_url": "data:text/html;base64,',
            Base64.encode(ArtWorkData),
            '"}'
        );

        return metadata;
    }

    /**
     *@dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - tokenIdをインクリメント
     * - nftMint関数の実行アドレスにtokenIdを紐づけ
     * - mintの際にURIを設定
     * - EVENT発火 emit TokenURIChanged
    */

    function nftMint() public onlyOwner{
        // tokenIdを1増やす。tokenIdは1から始まる
        _tokenIdCounter.increment();
        // 現時点のtokenIdを取得
        uint tokenId = _tokenIdCounter.current();

        string memory startFile = string(abi.encodePacked("data:application/json;base64,",Base64.encode(makeMetaData(start, tokenId))));

        // NFTmint
        _mint(msg.sender, tokenId);
        // tokenURIを設定
        _setTokenURI(tokenId, startFile);

        emit UpdateTokenURI(_msgSender(), tokenId, startFile);
    }

    function growNFT(uint targetId_) public {
        //今のstage
        Stages curStage = tokenStage[targetId_];

        //次のstageを設定(整数値に型変換)
        uint nextStage = uint(curStage) + 1;

        // Enumで指定している範囲を越えなければtokenURIを変更しEventを発行
        require(nextStage <= uint(type(Stages).max), "over stage");
        
        // metaFileの決定
        string memory metaFile = string(abi.encodePacked("data:application/json;base64,",Base64.encode(makeMetaData(nextStage + 1, targetId_))));
        _setTokenURI(targetId_, metaFile);

        // Stageの登録変更
        tokenStage[targetId_] = Stages(nextStage);

        // Event発行
        emit UpdateTokenURI(msg.sender, targetId_, metaFile);
    }

    /// @dev 以下は全てoverride重複の整理
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage){
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns(string memory) {
        return super.tokenURI(tokenId);
    }
}
