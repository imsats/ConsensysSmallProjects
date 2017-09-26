pragma solidity ^0.4.13;
import "./interfaces/Owned.sol";
import "./interfaces/TollBoothHolderI.sol";

contract TollBoothHolder is OwnedI, TollBoothHolderI {
   
   address owner;
   function TollBoothHolder(){
       owner = msg.sender;
   }
   
    struct TollBoothStruct {
       bool active;
    }
     mapping(address=>TollBoothStruct) public tollBoothStruct;
  
   
   
    function addTollBooth(address tollBooth)
        public
        returns(bool success){
            require(tollBoothStruct[tollBooth].active);
            require(tollBooth !=0 );
            require(owner == msg.sender);
            
            
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
        returns(bool success){
           require(tollBoothStruct[tollBooth].active);
           require(tollBooth != 0 );
           require(owner == msg.sender);
           
          tollBoothStruct[tollBooth].active == false;
           
              LogTollBoothRemoved(owner,tollBooth);
              return true;
        }
}
