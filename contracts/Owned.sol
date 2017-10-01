pragma solidity ^0.4.4;
import "./interfaces/OwnedI.sol";

contract Owned is OwnedI{

     address owner;
    	
      function Owned() {
		owner = msg.sender;	
	}

	modifier fromOwner {
		require(msg.sender == owner) ;
		_;
	}
	
	 function setOwner(address newOwner) 
	fromOwner()		
public returns(bool success){
require(owner != newOwner);
require(newOwner !=0);
	     owner = newOwner;
	     LogOwnerSet(owner, newOwner);
	     return true;
	 }
    
     function getOwner() constant public returns(address _owner){
         return owner;
     }
  

}
