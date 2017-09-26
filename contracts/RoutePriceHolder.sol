pragma solidity ^0.4.13;

import "./Owned.sol";
import "./interfaces/TollBoothHolderI.sol";
import "./interfaces/RoutePriceHolderI.sol";

contract RoutePriceHolder is Owned, TollBoothHolderI, RoutePriceHolderI{
    
    function RoutePriceHolder(){
        owner = msg.sender;
    }

     struct RoutePrice {
           address entryBooth;
            address exitBooth;
            uint priceWeis;
       bool active;
    }
     mapping(bytes32=>RoutePrice) public routePrices;
  
  
  
    function setRoutePrice(
            address entryBooth,
            address exitBooth,
            uint priceWeis)
            fromOwner()
        public
        returns(bool success){
            require( isTollBooth(entryBooth));
            require( isTollBooth(exitBooth));
            require( entryBooth != exitBooth);
            require( entryBooth != 0);
            require( exitBooth != 0);
            require( routePrices[keccak256(entryBooth,exitBooth)].priceWeis != priceWeis);
            
            routePrices[keccak256(entryBooth,exitBooth)].entryBooth = entryBooth;
            routePrices[keccak256(entryBooth,exitBooth)].exitBooth = exitBooth;
            routePrices[keccak256(entryBooth,exitBooth)].priceWeis = priceWeis;
            routePrices[keccak256(entryBooth,exitBooth)].active = true;

            LogRoutePriceSet(owner,entryBooth,exitBooth,priceWeis);
	
	    return true;
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
