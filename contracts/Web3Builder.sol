// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Web3Builders is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    using Counters for Counters.Counter;
    uint256 maxSupply = 2000;
    
    bool public publicMintOpen = false;
    bool public allowLisMintOpen = false;

    mapping(address => bool) public allowList;

    uint256 private _nextTokenId;
    Counters.Counter private _tokenIdCounter;

    constructor()
        ERC721("Web3Builders", "WE3")
        Ownable(msg.sender)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // modifiy the mint windows
    function editMintWindows(
        bool _publicMintOpen,
        bool _allowLisMintOpen
    ) external onlyOwner {
        publicMintOpen = _publicMintOpen;
        allowLisMintOpen = _allowLisMintOpen;
    }

    // require only allowlist people to mint
    // Add publicMint and allowListMintOpen Variables 
    function allowListMint() public payable {
        require(msg.value == 0.0001 ether, "Not enough funds");
        require(totalSupply() < maxSupply, "We sold out!");
        require(allowList[msg.sender], "You're no in the allow list");
        require(allowLisMintOpen, "Allowlist mint closed");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);

    } 

    // Add Payment
    // Add limit of supply
    function publicMint() public payable {
        require(msg.value == 0.001 ether, "Not enough funds");
        require(totalSupply() < maxSupply, "We sold out!");
        require(publicMintOpen, "Public mint closed");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function setAllowList(address[] calldata addresses) external onlyOwner {
        for (uint56 i = 0; i < addresses.length; i++) 
        {
            allowList[addresses[i]] = true;
        }
    }


    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
