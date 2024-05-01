// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
        uint256 private s_tokenCounter;
        string private s_sadSvgImageUri;
        string private s_happySvgImageUri;

        enum Mood {
            HAPPY,
            SAD
        }

        mapping(uint256 => Mood) private s_tokenIdMood;

        constructor(
            string memory sadSvgImageUri,
            string memory happySvgImageUri
        ) ERC721("Mood NFT", "MN") {
            s_tokenCounter = 0;
            s_sadSvgImageUri = sadSvgImageUri;
            s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns(string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        return
            string(
            abi.encodePacked(
            _baseURI(),
            Base64.encode(
                bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                    abi.encodePacked(
                        '{"name":"',
                        name(), // You can add whatever name here
                        '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                        '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                        imageURI,
                        '"}'
                    )
                )
            )));
    }
}