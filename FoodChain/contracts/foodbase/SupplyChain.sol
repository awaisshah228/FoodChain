pragma solidity ^0.5.0;

import "../foodaccesscontrol/ConsumerRole.sol";
import "../foodaccesscontrol/DeliveryRole.sol";
import "../foodaccesscontrol/DistributorRole.sol";
import "../foodaccesscontrol/KitchenRole.sol";
import "../foodcore/Ownable.sol";

// Define a contract 'Supplychain'
contract SupplyChain is DeliveryRole, ConsumerRole, DistributorRole,KitchenRole,Ownable{

  // Define 'owner'
  address payable ownerAdd;
 
  uint orderId;
  // Define a public mapping 'items' that maps the UPC to an Item.
 
  mapping (uint => Order) orders;
  mapping (uint => string[]) ordersHistory;

  // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash, 
  // that track its journey through the supply chain -- to be sent from DApp.
  mapping (uint => string[]) itemsHistory;
  
  
    

  // State constant defaultState = State.Harvested;


   enum State 
  { 
    Placed,  // 0
    Received,  // 1
    PrepareOrder,     // 2
    PickOrder,
    RouteOrder,
    Delivered,   // 3
    ReceivedOrderedFood //4
    }

 
    struct Order {
    uint    orderId;  // Stock Keeping Unit (SKU)
    address payable distributorId;
    address payable deliveryPersonId;
    address payable kitchenId;
    address payable consumerId; // Metamask-Ethereum address of the Consumer
    string  orderNotes; // Product Notes
    uint    orderPrice; // Product Price
    uint deliveryCharge;
    State   orderState;  // Product State as represented in the enum above
    
  }


  
  event OrderPlaced(uint orderId);
  event ReceiveOrder(uint orderId);
  event PerpareOrder(uint orderId,address payable kitchenId);
  event OnDeliveryMoneyReceived(address payable deliveryPerson,uint _orderId,uint deliveryCharge);
  event PreparedOrderNotified(uint orderId, address payable kitchenId,address distributorId, uint deliveryCharge);
  event OrderAvailabelForDelivery(address payable _distributorId,address payable kitchenId,uint  _orderId,address consumerId, uint deliveryCharge);
  event KitchenReceivedMoney(uint _orderId, uint orderPrice);
  event PickOrder(uint orderId);
  event RouteOrder(uint orderId);
  event ReceivedOrderedFood(uint orderId);

  
  // Define a modifer that checks to see if msg.sender == owner of the contract
  modifier onlyOwner() {
    require(msg.sender == ownerAdd);
    _;
  }

  // Define a modifer that verifies the Caller
  modifier verifyCaller (address _address) {
    require(msg.sender == _address); 
    _;
  }

 
  
   modifier placedOrder(uint _orderId) {
    require(orders[_orderId].orderState == State.Placed);
    _;
  }

   modifier orderReceived(uint _orderId) {
    require(orders[_orderId].orderState == State.Received);
    _;
  }
  modifier orderPrepared(uint _orderId) {
    require(orders[_orderId].orderState == State.PrepareOrder);
    _;
  }
   modifier pickOrder(uint _orderId) {
    require(orders[_orderId].orderState == State.PickOrder);
    _;
  }

  modifier routeOrder(uint _orderId) {
    require(orders[_orderId].orderState == State.RouteOrder);
    _;
  }

  modifier deliverOrder(uint _orderId) {
    require(orders[_orderId].orderState == State.Delivered);
    _;
  }
   modifier receivedOrderedFood(uint _orderId) {
    require(orders[_orderId].orderState == State.ReceivedOrderedFood);
    _;
  }

 
  // In the constructor set 'owner' to the address that instantiated the contract
  // and set 'sku' to 1
  // and set 'upc' to 1
  constructor() public payable {
    ownerAdd = msg.sender;
  
    orderId = 0;
  }

  // Define a function 'kill' if required
  function kill() public {
    if (msg.sender == ownerAdd) {
      selfdestruct(ownerAdd);
    }
  }

  // customer will place order 
   function placeOrder(string memory orderNotes,uint orderPrice,uint deliveryCharge) payable onlyConsumer public  {
     orderId  = orderId+1;     
     require(orderPrice+deliveryCharge>=msg.value);
     Order memory order =  Order(orderId,address(0x00),address(0x00),address(0x00),msg.sender,orderNotes,orderPrice,deliveryCharge,State.Placed);     
     orders[orderId] = order;
     emit OrderPlaced(orderId);
   }

    function getOrderStatus(uint _orderId) public view returns (
     uint orderid,
     address payable kitchenId,
     address payable consumerId,
     address payable deliveryPersonId,
     address payable distributorId,
     string memory  orderNotes,
     uint    orderPrice,
     uint   deliveryCharge,
     State   orderState
      
    ) {
      
      Order memory o = orders[_orderId];

      return (o.orderId,
            o.kitchenId,
            o.consumerId,
            o.deliveryPersonId,
            o.distributorId,            
            o.orderNotes,
            o.orderPrice,
            o.deliveryCharge,
            o.orderState
             );
    }
    // Kitchen  can call getOrder 
   function getOrder(uint _orderId) onlyKitchen public onlyKitchen()  returns (
     uint orderid,
     address payable kitchenId,
     address payable consumerId,
     string memory  orderNotes,
     uint    orderPrice,
     State   orderState
      ){
     orders[_orderId].kitchenId = msg.sender;
     orders[_orderId].orderState = State.Received;

     emit ReceiveOrder(_orderId);
     
     return (orders[_orderId].orderId,
            orders[_orderId].kitchenId,
            orders[_orderId].consumerId,
            orders[_orderId].orderNotes,
            orders[_orderId].orderPrice,
            orders[_orderId].orderState
             );
   }

  // Kitchen prepares order 
   function  kitchenPrepareOrder( uint _orderId, address  payable _distributorId)  onlyKitchen  public  {
      emit PerpareOrder(_orderId,msg.sender);
      
      msg.sender.transfer(orders[_orderId].orderPrice);
      emit KitchenReceivedMoney(_orderId, orders[_orderId].orderPrice);
      notifyDistrubutor(_distributorId, _orderId,orders[_orderId].deliveryCharge);
      orders[_orderId].orderState =  State.PrepareOrder;
      emit PreparedOrderNotified(_orderId,msg.sender,_distributorId,orders[_orderId].deliveryCharge);

   } 

  // kitchen wil call this function once food is prepared
  function notifyDistrubutor(address payable _distributorId,uint _orderId ,uint deliveryCharge) internal onlyKitchen {
      
      emit OrderAvailabelForDelivery(_distributorId,msg.sender,_orderId,orders[_orderId].consumerId,deliveryCharge);
  }
  // Delivery person will collect the order from ui he can select the order which he wants to delivery
  function orderPicked( uint _orderId) onlyDeliveryPerson() public {
      orders[_orderId].deliveryPersonId = msg.sender;
      orders[_orderId].orderState = State.PickOrder;
      emit PickOrder(_orderId);
  }
  //once the order is delivered and verified by the consumer funds will be transfered
  function orderDeliveredToCustomer(uint _orderId) public onlyDeliveryPerson() receivedOrderedFood(_orderId) {
    
    require(orders[_orderId].orderState == State.ReceivedOrderedFood);
    msg.sender.transfer(orders[_orderId].deliveryCharge);
    emit OnDeliveryMoneyReceived(msg.sender,_orderId,orders[_orderId].deliveryCharge);
  }
  
  // Consumer will call this function once the order id received
  function customerReceivedOrder(uint _orderId) public onlyConsumer() {
    orders[_orderId].orderState=State.ReceivedOrderedFood;
    emit ReceivedOrderedFood(_orderId);
  }
} 