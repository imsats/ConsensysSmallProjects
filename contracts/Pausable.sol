pragma solidity ^0.4.4;
import "./interfaces/OwnedI.sol";
import "./interfaces/PausableI.sol";


contract Pausable is PausableI, OwnedI{
	bool public paused;
	address owner;

	function Pausable(bool _paused) {
		owner = msg.sender;
		paused = _paused;
	}

	modifier whenPaused {
	require(paused);
		_;
	}
	
	modifier whenNotPaused {
	require(!paused);
		_;
	}
	
    function setPaused(bool newState)  returns(bool success){
        require(owner == msg.sender);
        require(paused != newState);
        paused = newState;
        LogPausedSet(owner,newState);
        return true;
    }
    
    function isPaused() constant returns(bool isIndeed){
          return paused; 
    }
  
  
}
