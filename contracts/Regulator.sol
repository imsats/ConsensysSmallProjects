pragma solidity ^0.4.13;
import "./Owned.sol";
import "./interfaces/RegulatorI.sol";
import "./TollBoothOperator.sol";
import "./interfaces/TollBoothOperatorI.sol";

contract Regulator is RegulatorI, Owned{
     
     
    function Regulator() {
        owner = msg.sender;
    }
    
    struct Vehicle { 
        uint vehicleType;
    }
    mapping (address => Vehicle) public vehicles;
    
    struct TollBoothOpertorStruct {
        bool active;
    }
    mapping (address => TollBoothOpertorStruct) public tollBoothOperatorStruct;
  
    TollBoothOpertorStruct[] public tollBoothOperatorList;
    function setVehicleType(address _vehicle, uint _vehicleType)
    public
    returns(bool success){
       
        require(_vehicle!=0);
        require(vehicles[_vehicle].vehicleType != _vehicleType);
        require( owner == msg.sender);
       
        vehicles[_vehicle].vehicleType = _vehicleType;
        LogVehicleTypeSet(owner,_vehicle,_vehicleType);
        return true;
    }
    
    function getVehicleType(address vehicle)
    constant
    public
    returns(uint vehicleType){
        return(vehicles[vehicle].vehicleType);
    }
    
    function createNewOperator(address _owner, uint _depositWeis)
    public
    returns(TollBoothOperatorI newOperator){
      
           require( owner == msg.sender);
        require(owner!=_owner);
  
        TollBoothOperatorI c =  new TollBoothOperator(true, _depositWeis,owner);
        tollBoothOperatorStruct[_owner].active = true;
    
        LogTollBoothOperatorCreated(msg.sender, _owner, owner, _depositWeis);
        return(c);
     
    }
    
    function removeOperator(address operator)
    public
    returns(bool success){
    
        require( owner == msg.sender);
        require(tollBoothOperatorStruct[operator].active);
    
        tollBoothOperatorStruct[operator].active = false;
        LogTollBoothOperatorRemoved(msg.sender, operator);
        return true;    
}
    
    function isOperator(address operator)
    constant
    public
    returns(bool indeed){   
        return(tollBoothOperatorStruct[operator].active);
    }
}
