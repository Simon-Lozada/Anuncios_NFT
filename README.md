# Anuncios_NFT
 Un modelo de anuncios descentralizado usando *NFTs*
 
 Este smart contract usa la libreria de *openzeppelin* para la implementación de los tokens ERC721
 
 ## Funcionamiento
Este programa usa un sistema de subasta a ciegas ("https://github.com/Simon-Lozada/Subasta_Solidity")
usamos un modificador el cual permita solo al ganador de la subasta crear un determinado NFT, este tendrá la URI que desee el ganador,
la operación de crear el NFT solo se podrá hacer una vez finalizado el tiempo establecido en el constructor(**revealEnd**)
cada token ERC721 tendrá un tiempo de "expiración"(**ExpireTime**) esto determinara el tiempo usa al NFT como anuncio, una ves finalizado el tiempo el estado de "Expirado" pasara a verdadero y la pagina ya no estará en obligación de seguir publicando su anuncio/NFT

## Funciones
- Funciones Basicas de **Token ERC721:** balanceOf, ownerOf, name, symbol, tokenURI, etc..
- Funciones de la **subasta a ciegas**: generateBlindedBidBytes32, bid, reveal, auctionEnd, withdraw, placeBid
- **CreateNFT:** Sirve para Crear el *NFT/Anuncio*
- **Expire:** Ver si el *NFT/Anuncio* ha expirado o no

