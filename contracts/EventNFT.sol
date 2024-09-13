// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventNFT is ERC721URIStorage, Ownable {
  uint256 private tokenID;

  constructor() payable ERC721("Abaku NFT", "ABAKUNFT") Ownable(msg.sender) {}

  function mint(string memory _tokenURI) public onlyOwner returns (uint256) {
      
      uint256 _newItemId = tokenID++;

      _safeMint(msg.sender, _newItemId);
      _setTokenURI(_newItemId, _tokenURI);

      return _newItemId;
  }

}

// contract NftCreated is ERC721, Ownable {
//     uint256 public mintPrice = 0.005 ether;
//     uint256 public totalSupply;
//     uint256 public maxSupply;
//     bool public isMintEnabled;
//     mapping(address => uint256) public mintedWallets;

//     constructor() payable ERC721("Abaku NFT", "ABAKUNFT") Ownable(msg.sender) {
//         maxSupply = 10;
//     }

//     function toggleIsMintEnabled() external onlyOwner {
//         isMintEnabled = !isMintEnabled;
//     }

//     function setMaxSupply(uint256 maxSupply_) external onlyOwner {
//       maxSupply = maxSupply_;
//     }

//     function mint() external payable {
//       require(isMintEnabled, "Minting not enabled");
//       require(mintedWallets[msg.sender] < 1, "Exceeds max per wallet");
//       require(msg.value == mintPrice, "wrong value");
//       require(maxSupply > totalSupply, "sold out");


//       mintedWallets[msg.sender]++;
//       totalSupply++;
//       uint256 tokenId = totalSupply;

//       _safeMint(msg.sender, tokenId);
//     }
// }