pragma solidity ^0.4.24;

//
// Simple Company Selling Share
//

contract SimpleCompanySellingToken {
    uint companySharesAvailable;
    uint sharePriceWei;
    uint sharePriceIncrementMultiplier = 2;
    struct CompanyShare {
        uint shares;
        address owner;
        bool exists;
    }
    //
    // List of Share Owners using address as a key
    //
    mapping(address => CompanyShare) public shareOwners;

    // Constructor
    // Receive the price per share in wei and define the available shares as 100000
    constructor(uint setSharePriceWei) public payable {
        sharePriceWei = setSharePriceWei;
        companySharesAvailable = 100000; // 100000 is 100%
    }

    //Returns the shares of some address
    function getSharesOfOwner(address entityAddress) external view returns (uint){
        return shareOwners[entityAddress].shares;
    }

    //Returns the remaining shares
    function getCompanySharesAvailable() external view returns (uint) {
        return companySharesAvailable;
    }
    //Returns the price per share in wei
    function getSharePriceWei() external view returns (uint) {
        return sharePriceWei;
    }
    //Return balance of the contract
    function getContractBalance() external view returns(uint){
        return address(this).balance;
    }
    // Buy shares for some address
    function buyShares(uint shares) external payable returns(uint) {
        //Check if the shares that the user has placed are greater than zero
        require(shares > 0);
        //Check if the shares that the user is trying to buy are smaller than the available company shares to sell
        require(shares < companySharesAvailable);
        //Made the cost of this transaction
        uint cost = sharePriceWei*shares;
        //Check if the value sended by user is greater than cost
        require(msg.value >= cost);
        //Check if there is change, and if there is return to the address that made the request
        if(msg.value-cost > 0){
            msg.sender.transfer(msg.value-cost);
        }
        // Subtract the buyed shares from available shares
        companySharesAvailable -= shares;
        //Multiply share price by multiplyer defineded
        sharePriceWei *= sharePriceIncrementMultiplier;
        //Check if the address already have shares
        if(!shareOwners[msg.sender].exists){
            //If isn't have create a new CompanyShare object
            CompanyShare memory newCompanyShare = CompanyShare(shares, msg.sender, true);
            shareOwners[msg.sender] = newCompanyShare;
        }else{
            //If already have just increment the shares
            shareOwners[msg.sender].shares += shares;
        }
        return shares;
    }

}