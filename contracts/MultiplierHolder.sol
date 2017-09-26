pragma solidity ^0.4.13;
import "./interfaces/MultiplierHolderI.sol";
import "./interfaces/OwnedI.sol";

contract MultiplierHolder is OwnedI, MultiplierHolderI {
  
  address owner;
    function MultiplierHolder(){
        owner = msg.sender;
    }
    
    struct VehicleMultiplier { // Struct
        uint vehicleType;
        uint multiplier;
    }
    mapping (uint => VehicleMultiplier) public vehicleMultiplier;
    
    
    function setMultiplier(
    uint vehicleType,
    uint multiplier)
    public
    returns(bool success){

        require(vehicleType!=0);
        require(vehicleMultiplier[vehicleType].multiplier != multiplier);

        vehicleMultiplier[vehicleType].multiplier = multiplier;
        LogMultiplierSet( owner, vehicleType, multiplier);
        return true;
    }
    
    function getMultiplier(uint vehicleType)
    constant
    public
    returns(uint multiplier){
        return( vehicleMultiplier[vehicleType].multiplier);
    }
 }
