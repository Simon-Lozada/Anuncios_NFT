// SPDX-License-Identifier: MIT

//La version 0.8.0 de solidity ya viene con seguridad aritmetica
pragma solidity ^0.8.4;

//Importamos el modulo basico del token ERC721
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//Importamos una extencion que nos permite configurar nuestro URI
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
//Importaos un cntrato de propiedad
import "@openzeppelin/contracts/access/Ownable.sol";


//Hacemos que nuestro contrato herede todos los anteriores
contract nft_token is ERC721, ERC721URIStorage, Ownable {
    
    ////////////////////////////// VARIABLES //////////////////////////////
    struct ADS {
        bool expired;       //Vemmos si el anuncio ha expirado o no
        uint256 TokenID;    //Guargamos el TokenID de NFT
    }
    
    //Mapiamos la estructura de ADS por wallet
    mapping (uint256 => ADS) public ADSs;
    mapping (address => ADS) public ADS_wallet;

    
    /*Se establece la variable "tokenCounter" la cual va ser usada para 
    Saber la cantidad de tokens que creamos*/
    uint256 public tokenCounter;

    
    uint256 [] IDs; //Array para almacenar los IDs
    ////////////////////////////// EVENT //////////////////////////////
    
    event nuevo_nft(uint, bool);    //Evento de crecion de nft
    event baja_nft(uint);           //Evento de expiracion de un nft
    
    ////////////////////////////// FUCTIONS //////////////////////////////

    //configuramos el nombre y simbolo de mi token
    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol){
        tokenCounter = 0;   //Establecemos un que "tokenCounter" es 0
    }

    //Crear un nft
    function safeMint(address to, string memory uri) internal onlyOwner returns (uint256) {
        uint256 newItemId = tokenCounter;   //establecemos que la varible "newItemId" sea igual a "tokenCounter"
        
        _safeMint(to, newItemId);           //Creamos el NFT de manera segura, ("to" es propietario, "newItemId" es el ID del token)
        _setTokenURI(newItemId, uri);       //Configuramos el URI del token(uri), buscamos el token a configurar atravez de su ID(newItemId)
        tokenCounter = tokenCounter + 1;    //Agregamos uno al contador 
        
        ADSs[newItemId] = ADS(false, newItemId);//Se agrega a nuestra matriz que nestro anuncio NO ha expirado y su TokenID
        IDs.push(newItemId);                    //Almacenamiento en un array el ID del nft
        
        emit nuevo_nft(newItemId, false);    //Emision del evento para la nueva Comida 


        return newItemId;                   //Regresamos su ID

    }
    
    //Expirar nft
    function SetExpire(uint256 TokenID) internal{
        ADSs[TokenID].expired = true;   //Cambiamos el estado de expirado a verdadero

        emit baja_nft(TokenID);         //emitimos la baja de nuestro nft
    }
    
    // Las siguientes funciones son anulaciones requeridas por Solidity.
    function _burn(uint256 TokenID) internal override(ERC721, ERC721URIStorage) {
        super._burn(TokenID);
    }

    function tokenURI(uint256 TokenID) public view override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(TokenID);
    }
}
