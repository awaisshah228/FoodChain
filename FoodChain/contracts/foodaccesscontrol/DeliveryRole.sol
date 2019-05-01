pragma solidity ^0.5.0;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'DeliveryRole' to manage this role - add, remove, check
contract DeliveryRole {
   using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event DeliveryPersonAdded(address indexed account);//, string name,uint aadharNumber);
  event DeliveryPersonRemoved(address indexed account);//, string name,uint aadharNumber);
  // Define a struct 'Deliverys' by inheriting from 'Roles' library, struct Role
  
  Roles.Role private DeliveryPerson;


 

  // In the constructor make the address that deploys this contract the 1st Delivery
  constructor() public {
    _addDeliveryPerson(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyDeliveryPerson() {
    require(isDeliveryPerson(msg.sender));
    _;
  }

  // Define a function 'isDelivery' to check this role
  function isDeliveryPerson(address account) public view returns (bool) {
    return DeliveryPerson.has(account);
  }

  // Define a function 'addDelivery' that adds this role
  function addDeliveryPerson(address account) public  {
    _addDeliveryPerson(account);
  }

  // Define a function 'renounceDelivery' to renounce this role
  function renounceDeliveryPerson(address account) public {
    _removeDeliveryPerson(account);
  }

  // Define an internal function '_addDelivery' to add this role, called by 'addDelivery'
  function _addDeliveryPerson(address account) internal {
    DeliveryPerson.add(account);
    emit DeliveryPersonAdded(account);
  }

  // Define an internal function '_removeDelivery' to remove this role, called by 'removeDelivery'
  function _removeDeliveryPerson(address account) internal {
    DeliveryPerson.remove(account);
    emit DeliveryPersonRemoved(account);
  }
}