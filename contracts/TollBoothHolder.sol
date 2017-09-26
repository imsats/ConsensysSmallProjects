pragma solidity ^0.4.13;
import "./Owned.sol";
import "./interfaces/TollBoothHolderI.sol";

contract TollBoothHolder is Owned, TollBoothHolderI {
   
   function TollBoothHolder(){
       owner = msg.sender;
   }
   
    struct TollBoothStruct {
       bool active;
    }
     mapping(address=>TollBoothStruct) public tollBoothStruct;
  
   
   
    function addTollBooth(address tollBooth)
        public
        fromOwner()
        returns(bool success){
            require(tollBoothStruct[tollBooth].active);
            require(tollBooth !=0 );
            
            
        tollBoothStruct[tollBooth].active = true;
        
             LogTollBoothAdded(owner,tollBooth);
             return true;
        }
   
   
    function isTollBooth(address tollBooth)
        constant
        public
        returns(bool isIndeed){
            
            return (tollBoothStruct[tollBooth].active) ;
            
        }
   
    function removeTollBooth(address tollBooth)
        public
        fromOwner()
        returns(bool success){
           require(tollBoothStruct[tollBooth].active);
           require(tollBooth != 0 );
          tollBoothStruct[tollBooth].active == false;
           
              LogTollBoothRemoved(owner,tollBooth);
              return true;
        }
}
