pragma solidity ^0.4.13;
import "RegulatorI.sol";
import "RegulatedI.sol";


contract Regulated is RegulatedI{
    
    address public currentRegulator;
    
    function Regulated(address initialRegulator){
        require(intialRegulator!=0);
         cuurentRegulator= new Regulator();     
    }
    
    function setRegulator(address newRegulator)
    public
     returns(bool success){
         
        require(currentRegulator==msg.sender);
        require(newRegulator !=0);
        require(currentRegulator != newRegulator);
        
        currentRegulator = newRegulator;
        LogRegulatorSet(currentRegulator,newRegulator);
    }
    
    function getRegulator()
    constant
    public
    returns(RegulatorI regulator){
        return Regulator(currentRegulator);
    }
}
