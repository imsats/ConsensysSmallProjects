pragma solidity ^0.4.13;
import "./interfaces/RegulatorI.sol";
import "./interfaces/RegulatedI.sol";
import "./Regulator.sol";


contract Regulated is RegulatedI{
    
    address public currentRegulator;
    
    function Regulated(address initialRegulator){
        require(initialRegulator!=address(0));
         currentRegulator= new Regulator();     
    }
    
    function setRegulator(address newRegulator)
    public
     returns(bool success){
         
        require(currentRegulator==msg.sender);
        require(newRegulator != address(0));
        require(currentRegulator != newRegulator);
        
        currentRegulator = newRegulator;
        LogRegulatorSet(currentRegulator,newRegulator);
return true;
    }
    
    function getRegulator()
    constant
    public
    returns(RegulatorI regulator){
        return Regulator(currentRegulator);
    }
}
