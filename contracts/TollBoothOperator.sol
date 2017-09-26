pragma solidity ^0.4.13;

import "./Owned.sol";
import "./Pausable.sol";
import "./DepositHolder.sol";
import "./TollBoothHolder.sol";
import "./MultiplierHolder.sol";
import "./RoutePriceHolder.sol";
import "./Regulated.sol";
import "./interfaces/TollBoothOperatorI.sol";

contract TollBoothOperator is TollBoothOperatorI, Owned, Pausable, DepositHolder, TollBoothHolder, MultiplierHolder, RoutePriceHolder, Regulated{

   address owner;
    bool initialPausedState;
    uint depositWeiValueofTollBoothOperator;
    uint totalCollectedFee;
  
    struct VehicleDetail
    {
        address vehicle;
        uint vehicleType;
        uint multiplier;
        address entryBooth;
        address exitBooth;
        uint depositedWeisofVehicle;
        bytes32 exitSecretHashed;
        uint fee; //fees paid by the vehicle
        uint feeRepaid; //how much did we repay
        uint routePrice; // what was the route price 
        bool feePaid; // did the vehicle pay or not 
        bool exited; // did the vehicle leave the exit gate 
    }
    
    mapping(bytes32 => VehicleDetail) public vehicleDetails;
    
    
    struct PendingPayment
    {
        bytes32 entryexitID;
        address vehicle;
        bool pendingPayment;
    }
    PendingPayment[]  pendingPayments;
    
    function hashSecret(bytes32 secret)
    constant
    public
    returns(bytes32 hashed){
        return keccak256(secret);
    }
    
    function TollBoothOperator(bool _pausedState, uint _depositWeiValue, address _regulator) {
        require( _depositWeiValue!=0);
        require(_regulator!=0);
        owner = msg.sender;
        
        initialPausedState = _pausedState;
        depositWeiValueofTollBoothOperator = _depositWeiValue;
	}
	
    function enterRoad(address entryBooth, bytes32 exitSecretHashed)
    public
    payable
    returns (bool success){
    
        uint vehicleType = getRegulator().getVehicleType(msg.sender);
        uint multiplier = getMultiplier(vehicleType);
        
        require(!isPaused());
        require(isTollBooth(entryBooth));
        require(msg.value > getDeposit()*multiplier);
        
        vehicleDetails[exitSecretHashed].vehicle = msg.sender;
        vehicleDetails[exitSecretHashed].vehicleType = vehicleType;
        vehicleDetails[exitSecretHashed].multiplier = multiplier;
        vehicleDetails[exitSecretHashed].entryBooth = entryBooth;
        vehicleDetails[exitSecretHashed].depositedWeisofVehicle = msg.value;
        vehicleDetails[exitSecretHashed].exitSecretHashed = exitSecretHashed;
        vehicleDetails[exitSecretHashed].exited = false;
        
       
        LogRoadEntered(
        msg.sender,
        entryBooth,
        exitSecretHashed,
        msg.value);
    return true;
    }
    
    
    
    
        function getVehicleEntry(bytes32 exitSecretHashed)
        constant
        public
        returns(
        address vehicle,
        address entryBooth,
        uint depositedWeis){
        
        if(vehicleDetails[exitSecretHashed].exited)
        {
            vehicleDetails[exitSecretHashed].depositedWeisofVehicle = 0;
        }
  
            return(
            vehicleDetails[exitSecretHashed].vehicle,
            vehicleDetails[exitSecretHashed].entryBooth,
            vehicleDetails[exitSecretHashed].depositedWeisofVehicle
            );
        }
            
        function reportExitRoad(bytes32 exitSecretClear)
        public
        returns (uint status){
            
            uint statuss;
        
        bytes32 exitSecretHashed = keccak256(exitSecretClear);
        require(!isPaused());
        require(isTollBooth(msg.sender));
        require(vehicleDetails[exitSecretHashed].entryBooth!= msg.sender);
        require(vehicleDetails[exitSecretHashed].exitSecretHashed == exitSecretHashed );
        
       
        uint routePrice = getRoutePrice(vehicleDetails[exitSecretHashed].entryBooth,msg.sender);
        uint fee = routePrice * vehicleDetails[exitSecretHashed].multiplier;
        uint balance = getDeposit() - fee;
        totalCollectedFee += fee;
        
        vehicleDetails[exitSecretHashed].exitBooth= msg.sender;
        vehicleDetails[exitSecretHashed].fee = fee;
        vehicleDetails[exitSecretHashed].feeRepaid = balance;
        vehicleDetails[exitSecretHashed].routePrice = routePrice;
        
        
        
        
        if(routePrice == 0)
        {
            vehicleDetails[exitSecretHashed].feePaid = false;
             
      
      PendingPayment memory pendingPaymentRecords;
           pendingPaymentRecords.entryexitID = keccak256(vehicleDetails[exitSecretHashed].entryBooth,vehicleDetails[exitSecretHashed].exitBooth);
        pendingPaymentRecords.vehicle = vehicleDetails[exitSecretHashed].vehicle;
        pendingPaymentRecords.pendingPayment = true;
        pendingPayments.push(pendingPaymentRecords);
        
          LogPendingPayment(
        exitSecretHashed,
        vehicleDetails[exitSecretHashed].entryBooth,
        vehicleDetails[exitSecretHashed].exitBooth);
        statuss = 1;
        }
        else
        {
           vehicleDetails[exitSecretHashed].feePaid = false;
             LogRoadExited(
            vehicleDetails[exitSecretHashed].exitBooth,
            vehicleDetails[exitSecretHashed].exitSecretHashed,
            fee,
            balance);
            statuss = 2;
        }
return statuss;
        
        }
    
         function getPendingPaymentCount(address entryBooth, address exitBooth)
        constant
        public
        returns (uint count){
            
         
         bytes32 arrayID = keccak256(entryBooth,exitBooth);
             
            
                uint pendingPaymentArrayCount = pendingPayments.length;
                uint totalPaymentpending = 0;
            for(uint i=0; i < pendingPaymentArrayCount; i++)
            {
               if(pendingPayments[i].entryexitID ==arrayID )
               {
                    totalPaymentpending++;
               }
            }
            
          return totalPaymentpending;
        
        }
        
          function clearSomePendingPayments(
            address entryBooth,
            address exitBooth,
            uint count)
        public
        returns (bool success){
             require(!isPaused());
            require(isTollBooth(entryBooth));
            require(isTollBooth(exitBooth));
            
            bytes32 arrayID = keccak256(entryBooth,exitBooth);
             
            
                uint pendingPaymentArrayCount = pendingPayments.length;
                uint totalPaymentpending = 0;
            for(uint i=0; i < pendingPaymentArrayCount; i++)
            {
               if(pendingPayments[i].entryexitID ==arrayID && totalPaymentpending <count)
               {
                    pendingPayments[i].pendingPayment = false;
                    totalPaymentpending++;
               }
            }
           return true;
        }
        
         function getCollectedFeesAmount()
        constant
        public
        returns(uint amount){
            
            return totalCollectedFee;
            
        }
        
          function withdrawCollectedFees()
        public
        returns(bool success){
            
            require(msg.sender == owner);
            require(totalCollectedFee>0);
            require(msg.sender !=0);
            
            uint totalCollectedFeeTemp = totalCollectedFee;
            totalCollectedFee = 0;
   
   
            require(msg.sender.send(totalCollectedFeeTemp)) ;
            LogFeesCollected(msg.sender,totalCollectedFee);
            return true;

        }
        
        /*
         function setRoutePrice(
            address entryBooth,
            address exitBooth,
            uint priceWeis)
        public
        returns(bool success){
            
            
            require( isTollBooth(entryBooth));
            require( isTollBooth(exitBooth));
            require( entryBooth != exitBooth);
            require( entryBooth != 0);
            require( exitBooth != 0);
            require( routePrices[keccak256(entryBooth,exitBooth)].priceWeis != priceWeis);
            
            routePrices[keccak256(entryBooth,exitBooth)].entryBooth = entryBooth;
            routePrices[keccak256(entryBooth,exitBooth)].exitBooth = exitBooth;
            routePrices[keccak256(entryBooth,exitBooth)].priceWeis = priceWeis;
            routePrices[keccak256(entryBooth,exitBooth)].active = true;

            LogRoutePriceSet(owner,entryBooth,exitBooth,priceWeis);
            
            
            return true;
        }*/
        
	function kill()
	{
	    selfdestruct(owner);
	}
  
  
    function () {
        revert(); 
    }
    
    /*
     * You need to create:
     *
     * - a contract named `TollBoothOperator` that:
     *     - is `OwnedI`, `PausableI`, `DepositHolderI`, `TollBoothHolderI`,
     *         `MultiplierHolderI`, `RoutePriceHolderI`, `RegulatedI` and `TollBoothOperatorI`.
     *     - has a constructor that takes:
     *         - one `bool` parameter, the initial paused state.
     *         - one `uint` parameter, the initial deposit wei value, which cannot be 0.
     *         - one `address` parameter, the initial regulator, which cannot be 0.
     */
}
