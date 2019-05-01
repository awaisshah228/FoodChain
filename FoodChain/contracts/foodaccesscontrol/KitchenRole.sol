pragma solidity ^0.5.0;

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'KitchenRole' to manage this role - add, remove, check
contract KitchenRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event KitchenAdded(address indexed account);
  event KitchenRemoved(address indexed account);

  // Define a struct 'Kitchens' by inheriting from 'Roles' library, struct Role
  Roles.Role private Kitchens;

  // In the constructor make the address that deploys this contract the 1st Kitchen
  constructor() public {
    _addKitchen(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyKitchen() {
    require(isKitchen(msg.sender));
    _;
  }

  // Define a function 'isKitchen' to check this role
  function isKitchen(address payable account) public view returns (bool) {
    return Kitchens.has(account);
  }

  // Define a function 'addKitchen' that adds this role
  function addKitchen(address account) public  {
    _addKitchen(account);
  }

  // Define a function 'renounceKitchen' to renounce this role
  function renounceKitchen(address account) public {
    _removeKitchen(account);
  }

  // Define an internal function '_addKitchen' to add this role, called by 'addKitchen'
  function _addKitchen(address account) internal {
    Kitchens.add(account);
    emit KitchenAdded(account);
  }

  // Define an internal function '_removeKitchen' to remove this role, called by 'removeKitchen'
  function _removeKitchen(address account) internal {
    Kitchens.remove(account);
    emit KitchenRemoved(account);
  }
}