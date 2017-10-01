var regulator = artifacts.require("./Regulator.sol");
module.exports = function(deployer,accounts) {
 
   deployer.deploy(regulator);
   var newRegulator = accounts[0]; 

};
