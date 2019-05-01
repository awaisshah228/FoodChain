 
App = {
    web3Provider: null,
    contracts: {},
    emptyAddress: "0x0000000000000000000000000000000000000000",
    sku: 0,
    upc: 0,
    metamaskAccountID: "0x0000000000000000000000000000000000000000",
    ownerID: "0x0000000000000000000000000000000000000000",
    originFarmerID: "0x0000000000000000000000000000000000000000",
    originFarmName: null,
    originFarmInformation: null,
    originFarmLatitude: null,
    originFarmLongitude: null,
    productNotes: null,
    productPrice: 0,
    distributorID: "0x0000000000000000000000000000000000000000",
    retailerID: "0x0000000000000000000000000000000000000000",
    consumerID: "0x0000000000000000000000000000000000000000",

    init: async function () {
        
        /// Setup access to blockchain
        return await App.initWeb3();
       
    },

    readForm: function () {
        App.orderId = $("#orderID").val();
       // App.upc = $("#upc").val();
       console.log(" web3 to wei ",window.web3,window.web3.utils);
        App.totalAmount =  window.web3.toWei( $("#totalAmount").val(), 'wei'); 
        App.deliveryCharge =  window.web3.toWei($("#deliveryCharge").val(), 'wei'); 
        App.consumerID = ($("#consumerID").val()).toLowerCase();
        App.distributorId = ($("#distributorId").val()).toLowerCase();
        App.kitchenId = ($("#kitchenId").val()).toLowerCase();
        App.deliveryID = ($("#deliveryID").val()).toLowerCase();
        App.orderNotes = $("#OrderNotes").val();
  

        console.log("App readForm",
            App.orderId,
            App.totalAmount,
            App.deliveryCharge, 
            App.consumerID, 
            App.distributorId, 
            App.kitchenId, 
            App.deliveryID, 
            App.orderNotes
        );
    },

    initWeb3: async function () {
        /// Find or Inject Web3 Provider
        /// Modern dapp browsers...
        if (window.ethereum) {
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
        }

        App.getMetaskAccountID();

        return App.initSupplyChain();
    },

    getMetaskAccountID: function () {
        web3 = new Web3(App.web3Provider);

        // Retrieving accounts
        web3.eth.getAccounts(function(err, res) {
            if (err) {
                console.log('Error:',err);
                return;
            }
            console.log('getMetaskID:',res);
            App.metamaskAccountID = res[0];

        })
    },

    initSupplyChain: function () {
        /// Source the truffle compiled smart contracts
        var jsonSupplyChain='../../build/contracts/SupplyChain.json';
        
        /// JSONfy the smart contracts
        $.getJSON(jsonSupplyChain, function(data) {
            console.log('data',data);
            var SupplyChainArtifact = data;
            App.contracts.SupplyChain = TruffleContract(SupplyChainArtifact);
            App.contracts.SupplyChain.setProvider(App.web3Provider);
            
            App.getOrderStatus();
            App.fetchEvents();
        });
       

        return App.bindEvents();
        
    },

    bindEvents: function() {
        $(document).on('click', App.handleButtonClick);
    },

    handleButtonClick: async function(event) {
        event.preventDefault();
        App.readForm();
        App.getMetaskAccountID();

        var processId = parseInt($(event.target).data('id'));
        console.log('processId',processId,event);

        switch(processId) {
            case 1:
                return await App.placeOrder(event);
                break;
            case 2:
                return await App.getOrder(event);
                break;
            case 3:
                return await App.kitchenPrepareOrder(event);
                break;
            case 4:
                return await App.orderPicked(event);
                break;
            case 5:
                return await App.customerReceivedOrder(event);
                break;
            case 6:
                return await App.orderDeliveredToCustomer(event);
                break;
            case 7:
                return await App.getOrderStatus();
                break;
            case 8: 
                return await App.showOrders();
                break;

            }
    },

    placeOrder: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            orderPrice = App.totalAmount - App.deliveryCharge;
            console.log(App.totalAmount," Orde Price : ",orderPrice," Delivery Charge: ",App.deliveryCharge);
            return instance.placeOrder(
                App.orderNotes, 
                orderPrice, 
                App.deliveryCharge, 
                {from:  App.consumerID  , value: App.totalAmount}
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('placeOrder',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    getOrder: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            console.log("Kitchen Account",App.kitchenId);
            return instance.getOrder(App.orderId, {from: App.kitchenId});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('processItem',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },
    
    kitchenPrepareOrder: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.kitchenPrepareOrder(App.orderId,App.distributorID, {from: App.kitchenId});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('packItem',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    orderPicked: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const productPrice = web3.toWei(1, "ether");
            console.log('productPrice',productPrice);
            return instance.orderPicked(App.orderId, {from: App.deliveryID});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('sellItem',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    customerReceivedOrder: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const walletValue = web3.toWei(3, "ether");
            return instance.customerReceivedOrder(App.orderId, {from: App.consumerID});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('buyItem',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    orderDeliveredToCustomer: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.orderDeliveredToCustomer(App.orderId, {from: App.deliveryID});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('shipItem',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    getOrderStatus: function () {
        //event.preventDefault();
        //var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.getOrderStatus(App.orderId);
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('receiveItem',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    showOrders:  function(){
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.getOrderStatus(App.orderId);
        }).then(function(result) {
            console.log(result[8].toString()," state ");
            console.log(result[7].toString()," Delivery Charge");
            if( 2=== 2){
                $("#dOrderId").text(result[0]);
                $("#dKitchenID").text(result[1]);
                $("#dConsumerID").text(result[2]);
                $("#dOrderNotes").text(result[5]);        
                $("#dDeliveryCharge").text(result[7].toString());
                $("#dDistributorID").text(result[4]);
            }
            
            console.log('receiveItem',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },
    fetchEvents: function () {
        if (typeof App.contracts.SupplyChain.currentProvider.sendAsync !== "function") {
            App.contracts.SupplyChain.currentProvider.sendAsync = function () {
                return App.contracts.SupplyChain.currentProvider.send.apply(
                App.contracts.SupplyChain.currentProvider,
                    arguments
              );
            };
        }

        App.contracts.SupplyChain.deployed().then(function(instance) {
        var events = instance.allEvents(function(err, log){
          if (!err)
            $("#ftc-events").append('<li>' + log.event + ' - ' + log.transactionHash + '</li>');
        });
        }).catch(function(err) {
          console.log(err.message);
        });
        
    }
};

$(function () {
    $(window).load(function () {
        App.init();
    });
});
