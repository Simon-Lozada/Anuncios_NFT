// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "./BlindAuction.sol";
import "./nft_token.sol";

contract NFT_ads is BlindAuction, nft_token{
    ////////////////////////////// VARIABLES //////////////////////////////

    ////////////////////////////// EVENT //////////////////////////////
    
    ////////////////////////////// MODIFIRS //////////////////////////////
    
    //Con este modificador nos aseguramos que algo solo lo pueda hacer el postor mas alto
    modifier OnlyHighestBidder() {require(msg.sender == highestBidder); _;}
    
    uint ExpireTime;
    ////////////////////////////// FUCTIONS //////////////////////////////
    //Establecemos algunas variable utiles
    constructor(
    uint _ExpireTime,                          //El tiempo que se va usar el nft como anuncio

    uint _biddingTime,                          //El tiempo que va a durar la oferta
    uint _revealTime,                           //El tiempo en que revelareremos todas las ofertas
    address payable _beneficiary,               //El Beneficiario de la subasta
    string memory _features,                    //caracteristicas del producto subastado

    string memory _name,                        //Nombre del NFT
    string memory _symbol                       //Symbolo del nft
    
    )   BlindAuction(_biddingTime, _revealTime, _beneficiary, _features) 
        nft_token(_name, _symbol) {
            ExpireTime = revealEnd + _ExpireTime;
        }

    //Crear nft
    function CreateNFT(address to, string memory uri) onlyAfter(revealEnd) external{
        safeMint(to, uri);
    }

    //Expirar nft
    function Expire(uint256 TokenID) external onlyAfter(ExpireTime){
        SetExpire(TokenID);
    }

}