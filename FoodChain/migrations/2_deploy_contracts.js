// migrating the appropriate contracts
var ConsumerRole = artifacts.require("./ConsumerRole.sol");
var DistributorRole = artifacts.require("./DistributorRole.sol");
var KitchenRole = artifacts.require("./KitchenRole.sol");
var ConsumerRole = artifacts.require("./ConsumerRole.sol");
var SupplyChain = artifacts.require("./SupplyChain.sol");
var DeliveryChain = artifacts.require("./DeliveryRole.sol");
var Migrations = artifacts.require("./Migrations.sol");



module.exports = function(deployer) {
  deployer.deploy(ConsumerRole);
  deployer.deploy(DistributorRole);
  deployer.deploy(KitchenRole);
  deployer.deploy(SupplyChain);
  deployer.deploy(DeliveryChain);
  deployer.deploy(Migrations); 
  
};
