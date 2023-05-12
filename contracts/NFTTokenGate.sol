//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155URIStorageUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract token1155 is ERC1155URIStorageUpgradeable,Ownable{

    
    struct tokenAmount{
        uint256 mintedAmount;
        uint256 maxAmount;
    }
    
    mapping(uint256 => tokenAmount)private token;

    function initialize(string memory _URI) external virtual initializer{

        __ERC1155_init_unchained(_URI);
    }

    function mint(address _to, uint256 _tokenID, uint256 _amount, bytes memory _data) external virtual {
        require(token[_tokenID].maxAmount > 0,"Token ID not availale");
        token[_tokenID].mintedAmount+= _amount;
        require(token[_tokenID].mintedAmount<=token[_tokenID].maxAmount,"Token max amount reached");
        _mint(_to, _tokenID, _amount, _data);
    
    }

    function setURI(uint256 _tokenID,string memory _URI) external virtual onlyOwner {
        require(token[_tokenID].mintedAmount > 0,"Invalid token ID");
        require(bytes(_URI).length != 0,"URI can't be empty ");
        _setURI(_tokenID, _URI);
    }

    function setAmount(uint256 _tokenID,uint256 _amount) external virtual onlyOwner{
       require(_amount !=0,"Amount can't be zero");
       tokenAmount storage info = token[_tokenID];
       info.maxAmount = _amount;
    }


    function _msgSender() internal view virtual override(ContextUpgradeable,Context) returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual override(ContextUpgradeable,Context) returns (bytes calldata) {
        return msg.data;
    }
}