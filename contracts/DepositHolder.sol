pragma solidity ^0.4.13;
import "./interfaces/OwnedI.sol";
import "./interfaces/DepositHolderI.sol";

contract DepositHolder is OwnedI, DepositHolderI{
    
    uint depositWeis;
    address owner;
    
  function DepositHolder(uint _depositWeis){
       require(_depositWeis!=0);
       owner = msg.sender;
        depositWeis = _depositWeis;
    
    }
    
    function setDeposit(uint _depositWeis)
    public 
    returns(bool success){
        require(_depositWeis!=0);
        require(depositWeis!=_depositWeis);
        require(owner == msg.sender);
        depositWeis = _depositWeis;
        LogDepositSet(owner, _depositWeis);
        return true;
    }
    
    function getDeposit()
    constant
    public
    returns(uint weis)
    {
        return depositWeis;
    }
}
