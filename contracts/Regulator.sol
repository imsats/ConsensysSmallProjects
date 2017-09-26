pragma solidity ^0.4.4;
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
    fromOwner()
    returns(bool success){
       
        require(_vehicle!=0);
        require(vehicles[_vehicle].vehicleType != _vehicleType);
       
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
    fromOwner()
    returns(TollBoothOperatorI newOperator){
      
        require(owner!=_owner);
  
        TollBoothOperatorI c = new TollBoothOperator(true, owner, _depositWeis);
        tollBoothOperatorStruct[_owner].active = true;
    
        LogTollBoothOperatorCreated(msg.sender, _owner, owner, _depositWeis);
        return(c);
     
    }
    
    function removeOperator(address operator)
    public
    fromOwner()
    returns(bool success){
        require(tollBoothOperatorStruct[operator].active);
        tollBoothOperatorStruct[operator].active = false;
        LogTollBoothOperatorRemoved(msg.sender, operator);
    }
    
    function isOperator(address operator)
    constant
    public
    returns(bool indeed){   
        return(tollBoothOperatorStruct[operator].active);
    }
}
