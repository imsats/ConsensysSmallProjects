pragma solidity ^0.4.13;

import "./interfaces/OwnedI.sol";
import "./interfaces/TollBoothHolderI.sol";
import "./interfaces/RoutePriceHolderI.sol";

contract RoutePriceHolder is OwnedI, TollBoothHolderI, RoutePriceHolderI{
    
    address owner;
    function RoutePriceHolder(){
        owner = msg.sender;
    }

     struct RoutePrice {
           address entryBooth;
            address exitBooth;
            uint priceWeis;
       bool active;
    }
     mapping(address=>RoutePrice) public routePrices;
  
  
  
    function setRoutePrice(
            address entryBooth,
            address exitBooth,
            uint priceWeis)
        public
        returns(bool success){
            require( isTollBooth(entryBooth));
            require( isTollBooth(exitBooth));
            require( entryBooth != exitBooth);
            require( entryBooth != 0);
            require( exitBooth != 0);
            require( routePrices[keccak256(entryBooth,exitBooth)].priceWeis != priceWeis);
            require( owner == msg.sender);
            
            routePrices[keccak256(entryBooth,exitBooth)].entryBooth = entryBooth;
            routePrices[keccak256(entryBooth,exitBooth)].exitBooth = exitBooth;
            routePrices[keccak256(entryBooth,exitBooth)].priceWeis = priceWeis;
            routePrices[keccak256(entryBooth,exitBooth)].active = true;

            LogRoutePriceSet(owner,entryBooth,exitBooth,priceWeis);
        }
   
    function getRoutePrice(
            address entryBooth,
            address exitBooth)
        constant
        public
        returns(uint priceWeis){
            if( isTollBooth(entryBooth) && isTollBooth(exitBooth)) 
            {
            
              return(routePrices[keccak256(entryBooth,exitBooth)].priceWeis);
            }
            else
            {
                return 0;
            }
        }
  
}
